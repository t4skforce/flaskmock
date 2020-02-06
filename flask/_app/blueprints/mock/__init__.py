from flask import Blueprint

bp = Blueprint('mock', __name__, template_folder='templates', static_folder='static', url_prefix='/mock')

@bp.route('/ping')
def ping():
    return "pong"
