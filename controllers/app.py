from flask import Flask, request
from flask import Flask, got_request_exception
from flask import json
from werkzeug.exceptions import HTTPException
from prometheus_client import Gauge
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app
import mysql.connector
import os



app = Flask(__name__)
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {"/metrics": make_wsgi_app()})


HTTP_METHODS = [
    "POST"
]

from werkzeug.exceptions import HTTPException

c = Gauge(
    "client_requests_total", "Total Requests per Client", ["client_ip", "lat", "long"]
)


@app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error

    return "POST call"



def get_location_data(client_ip):
    import requests

    response = requests.get("http://ip-api.com/json/" + client_ip)

    data = response.json()
    return data


@app.route('/ip', methods = ['POST'])
def update_ip():
    request_data = request.get_json()
    address = request_data['address'] # address of the user
    
    mydb = mysql.connector.connect(
        host=os.getenv('DB_HOST'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_DATABASE')
        )

    mycursor = mydb.cursor()

    sql = "INSERT INTO ip_address (address) VALUES ( %s)"
    val = ("address")
    mycursor.execute(sql, val)

    mydb.commit()

    print(mycursor.rowcount, "record inserted.")


if __name__ == "__main__":

    app.run(debug=True, host="0.0.0.0")
