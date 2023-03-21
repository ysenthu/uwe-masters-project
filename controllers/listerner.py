import grpc, os
from concurrent import futures
import envoy.service.discovery.v3.ads_pb2_grpc as ads_grpc
import envoy.service.discovery.v3.ads_pb2 as ads_pb2
import envoy.config.listener.v3.listener_components_pb2 as listener_components
import envoy.config.core.v3.base_pb2 as base_pb2
import mysql.connector


# Replace this with your listener configuration
def create_listener_config(ip_address):
    ROUTE_CONFIG = {
        "route_config": {
            "name": "local_route",
            "virtual_hosts": [
                {
                    "name": "local_service",
                    "domains": ["*"],
                    "routes": [
                        {
                            "match": {
                                "prefix": "/*", "headers": [{"name": "X-Forwarded-For", "contains_match": ip_address}]
                            },
                            "route": {
                                "cluster": "honeypotservice",
                                "request_mirror_policies": [
                                    {
                                        "cluster": "service2",
                                        "runtime_fraction": {
                                            "default_value": {"numerator": 100}
                                        },
                                    }
                                ],
                            },
                        }
                    ],
                }
            ],
        }
    }

    listener = listener_components.Listener(
        name="listener_0",
        address=base_pb2.Address(
            socket_address=base_pb2.SocketAddress(address="0.0.0.0", port_value=8080)
        ),
        filter_chains=[
            listener_components.FilterChain(
                filters=[
                    listener_components.Filter(
                        name="envoy.filters.network.http_connection_manager",
                        typed_config=base_pb2.Any(
                            type_url="type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager",
                            value=b"{}",
                        ),
                    )
                ]
            )
        ],
    )
    return listener


class XdsAdsService(ads_grpc.AggregatedDiscoveryServiceServicer):
    def StreamAggregatedResources(self, request_iterator, context):
        for request in request_iterator:

            mydb = mysql.connector.connect(
                host=os.getenv("DB_HOST"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASSWORD"),
                database=os.getenv("DB_DATABASE"),
            )

            mycursor = mydb.cursor(dictionary=True)

            mycursor.execute("SELECT address FROM ip_address")

            myresult = mycursor.fetchall()

            for x in myresult:
                ip = x["address"]

            if (
                request.type_url
                == "type.googleapis.com/envoy.config.listener.v3.Listener"
            ):
                listener = create_listener_config(ip)
                response = ads_pb2.DiscoveryResponse(
                    type_url="type.googleapis.com/envoy.config.listener.v3.Listener",
                    resources=[listener.SerializeToString()],
                    version_info="1",
                    nonce="1",
                )
                yield response


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    ads_grpc.add_AggregatedDiscoveryServiceServicer_to_server(XdsAdsService(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("xDS server started on port 50051")
    server.wait_for_termination()


if __name__ == "__main__":
    serve()
