from flask import Flask
app = Flask(__name__)
@app.route('/vote/cars')
def vote_cars():
    return "Vote received for Cars"

@app.route('/vote/bikes')
def vote_bikes():
    return "Vote received for Bikes"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
