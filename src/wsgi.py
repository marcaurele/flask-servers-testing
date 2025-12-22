from flask import Flask
import sys

app = Flask(__name__)
app.config['DEBUG'] = False

@app.route('/')
def index():
    return ('', 204)

if __name__ == '__main__':
    if "bjoern" in sys.modules:
        import bjoern
        bjoern.run(app, '0.0.0.0', 8000)
    else:
        exit(1)
