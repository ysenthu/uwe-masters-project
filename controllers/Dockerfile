FROM ubuntu:18.04


RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev

# We copy just the requirements.txt first to leverage Docker cache

WORKDIR /app

RUN pip3 install Flask && pip3 install prometheus-client && pip3 install requests grpcio grpcio-tools

COPY app.py app.py

RUN adduser --system --no-create-home nonroot && chown -R nonroot /app

# ... do the various install and setup steps as root ...

# Specify metadata for when you run the container

RUN python -m grpc_tools.protoc -I./proto --python_out=. --grpc_python_out=. ./proto/envoy/service/discovery/v3/ads.proto

USER nonroot

CMD ["python3", "app.py" ]
