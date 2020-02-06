FROM alpine

ENV APP_DIR /flask
ENV FLASK_ENV development
ENV FLASK_DEBUG True
ENV FLASK_RUN_PORT 8080
ENV FLASK_RUN_HOST 0.0.0.0

RUN apk add --no-cache nginx \
	python3 \
	python3-dev \
	mariadb-dev \
	postgresql-dev \
	imagemagick-dev \
	libffi-dev \
	py3-sqlalchemy \
	py3-mysqlclient \
	py3-psycopg2 \
	py3-gevent \
	uwsgi \
	uwsgi-python3 \
	uwsgi-http \
	uwsgi-gevent3 \
	py3-pip \
	&& pip3 install --upgrade pip \
	&& pip3 install --upgrade setuptools \
	&& pip3 install --no-cache-dir flask python-dotenv flaskcode requests flask-login Flask-SQLAlchemy Flask-Limiter flask-mail Flask-WTF \
	&& find / -type d -name __pycache__ -exec rm -r {} + \
	&& rm -rf /root/.cache /var/cache

ADD flask /flask
ADD nginx.conf /etc/nginx/nginx.conf
ADD app.ini /app.ini
ADD entrypoint.sh /entrypoint.sh
RUN chown -R nginx:nginx ${APP_DIR} \
	&& chmod 777 /run/ -R \
	&& chmod 777 /root/ -R
VOLUME ${APP_DIR}/app/
WORKDIR ${APP_DIR}

EXPOSE ${FLASK_RUN_PORT}
ENTRYPOINT ["/entrypoint.sh"]
