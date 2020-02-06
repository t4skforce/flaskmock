#!/bin/sh

if [ "$FLASK_SECRET_KEY" = "" ]; then
	export FLASK_SECRET_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
fi

if [ -e requirements-alpine.txt ]; then
	apk add --no-cache $(cat requirements-alpine.txt)
fi

if [ -e requirements.txt ]; then
	pip3 install --upgrade -r requirements.txt
fi

if [ ! -e "${APP_DIR}/app/__init__.py" ]; then
	mkdir -p "${APP_DIR}/app"
	cp -TRv "${APP_DIR}/_app/" "${APP_DIR}/app/"
	chown -R nginx:nginx "${APP_DIR}/app"
fi

if [ -e "${APP_DIR}/app/requirements-alpine.txt" ]; then
	apk add --no-cache $(cat "${APP_DIR}/app/requirements-alpine.txt")
fi

if [ -e "${APP_DIR}/app/requirements.txt" ]; then
	pip3 install --upgrade -r "${APP_DIR}/app/requirements.txt"
fi

if [ "$FLASK_ENV" = "development" ] || [ "$FLASK_DEBUG" = "True" ]; then
	flask run
else
	chown -R nginx:nginx ${APP_DIR}
	nginx && uwsgi --ini /app.ini
fi
