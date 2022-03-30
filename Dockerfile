FROM python:3.8-slim-buster
#FROM python:2.7
RUN apt-get update
RUN apt-get install -y vim nano
RUN apt-get install -y iputils-ping
WORKDIR /doker-flask-app
#VOLUME ["/doker-flask-app"]
#copy content to workink dir
#ADD . doker-flask-app
COPY requirements.txt .
COPY app.py .
RUN pip install -r requirements.txt
CMD [ "python", "app.py"]
EXPOSE 8181/tcp
