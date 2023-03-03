from asgiref.wsgi import WsgiToAsgi
from flask import Flask
import time

app = Flask(__name__)
app.config['DEBUG'] = False

@app.route('/')
async def index():
    # time.sleep(0.2)
    return ('', 204)

asgi_app = WsgiToAsgi(app)
