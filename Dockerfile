FROM python:latest

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install -r "requirements.txt"

ENV YOUR_NAME="Lavanya in MEA16"

EXPOSE 8080

ENTRYPOINT ["python", "lbg.py"]
