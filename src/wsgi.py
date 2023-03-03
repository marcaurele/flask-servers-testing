from flask import Flask
import time

app = Flask(__name__)
app.config['DEBUG'] = False

@app.route('/')
def index():
    # time.sleep(0.2)
    return ('', 204)
    
if __name__ == '__main__':
    import bjoern
    bjoern.run(app, '0.0.0.0', 8000)