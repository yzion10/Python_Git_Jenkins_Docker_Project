FROM python:3.7-alpine
WORKDIR /app
COPY rest_app.py /app
COPY db_connector.py /app
COPY PageNotFount.html /app
RUN pip install flask
RUN pip install pymysql
RUN pip install requests
EXPOSE 5000
VOLUME /app/logs
CMD python3 rest_app.py