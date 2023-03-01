from asgiref.wsgi import WsgiToAsgi
from flask import Flask

app = Flask(__name__)
app.config['DEBUG'] = False

@app.route('/')
async def index():
    return ('', 204)

asgi_app = WsgiToAsgi(app)
