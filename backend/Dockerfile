FROM python:3.9-alpine
WORKDIR /app
COPY app.py .
RUN pip install flask redis prometheus-client
EXPOSE 5000
CMD ["python", "app.py"]

