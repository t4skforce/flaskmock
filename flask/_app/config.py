import os
from dotenv import load_dotenv
basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))

class Config(object):
	SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
	FLASKCODE_USERNAME = os.environ.get('FLASKCODE_USERNAME') or "admin"
	FLASKCODE_PASSWORD = os.environ.get('FLASKCODE_PASSWORD') or "admin"
	FLASKCODE_RESOURCE_BASEPATH = os.environ.get('FLASKCODE_RESOURCE_BASEPATH') or os.path.abspath(basedir)
	FLASKCODE_EDITOR_THEME = os.environ.get('FLASKCODE_EDITOR_THEME') or "vs-dark"
