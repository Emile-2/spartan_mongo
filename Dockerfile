FROM python:latest
ADD requirements.txt /
ADD database.config /
RUN pip install -r requirements.txt
ADD app /app
CMD python /app/main.py
