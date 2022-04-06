FROM python:latest
ADD requirements.txt /
ADD database.config /
RUN pip install -r requirements.txt
ADD app /app
ENTRYPOINT ["python", "/app/main.py"]
