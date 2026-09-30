from flask import Flask, request, jsonify
# 1. Import Prometheus utilities
from prometheus_client import make_wsgi_app, Counter
from werkzeug.middleware.dispatcher import DispatcherMiddleware

app = Flask(__name__)

# 2. Define your application metrics
VOTE_COUNTER = Counter('total_votes_cast', 'Total number of votes processed', ['candidate'])

@app.route('/vote', methods=['POST'])
def vote():
    
    candidate = request.json.get('candidate', 'unknown')
    
    # Increasing the metric counter when vote happens
    VOTE_COUNTER.labels(candidate=candidate).inc()
    
    return jsonify({"status": "Vote registered!"})


app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
