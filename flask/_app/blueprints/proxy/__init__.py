from flask import Blueprint, make_response
import requests

bp = Blueprint('proxy', __name__, template_folder='templates', static_folder='_static', url_prefix='/')

@bp.route('/', methods=['GET'])
def proxy_index():
    r = requests.get('https://pypi.org')
    response = make_response(r.content,r.status_code)
    response.headers['Content-Type'] = r.headers['Content-Type']
    return response

@bp.route('/<path:fullpath>', methods=['GET'])
def proxy_path(fullpath):
    r = requests.get('https://pypi.org/{}'.format(fullpath))
    response = make_response(r.content,r.status_code)
    response.headers['Content-Type'] = r.headers['Content-Type']
    return response
