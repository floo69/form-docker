FROM python:3.12-slim

WORKDIR /app

COPY . .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]