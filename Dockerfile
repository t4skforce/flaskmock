FROM alpine

ENV APP_DIR /flask
ENV FLASK_ENV development
ENV FLASK_DEBUG True
ENV FLASK_RUN_PORT 8080
ENV FLASK_RUN_HOST 0.0.0.0

RUN apk add --no-cache git nginx \
	python3 \
	# dev libs for building
	python3-dev mariadb-dev postgresql-dev imagemagick-dev libffi-dev \
	py3-openssl \
	# uwsgi packages and extensions
	uwsgi uwsgi-python3 uwsgi-http uwsgi-gevent3 py3-gevent \
	# python pip
	py3-pip \
	&& pip3 install --upgrade pip \
	&& pip3 install --upgrade setuptools \
	# SQLAlchemy
	&& apk add --no-cache py3-sqlalchemy \
	# pymysql for SQLAlchemy (mysql+pymysql://<username>:<password>@<host>/<dbname>[?<options>])
	&& apk add --no-cache py3-mysqlclient \
	# psycopg2 for SQLAlchemy (postgresql+psycopg2://user:password@host:port/dbname[?key=value&key=value...])
	&& apk add --no-cache py3-psycopg2 \
	# disable -> https://github.com/pymssql/pymssql/issues/586
	# pymssql for SQLAlchemy (mssql+pymssql://<username>:<password>@<freetds_name>/?charset=utf8)
	# && apk add --no-cache musl-dev cython \
	# && pip3 install --no-cache-dir python-tds bitarray pymssql \
	# Flask + Extensions
	&& pip3 install --no-cache-dir flask flask-login Flask-SQLAlchemy Flask-Limiter flask-mail Flask-WTF \
	# Tools
	&& pip3 install --no-cache-dir python-dotenv requests flaskcode \
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
