FROM python:latest3.6

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install -r "requirements.txt"

ENV YOUR_NAME="Lavanya in MEA16"

EXPOSE 5500

ENTRYPOINT ["python", "lbg.py"]
