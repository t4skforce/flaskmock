from flask import Flask, request, make_response
import pkgutil
import os
import sys
import flaskcode

def load_blueprints(dirname):
    for importer, package_name, _ in pkgutil.iter_modules([os.path.join('app',dirname)]):
        full_package_name = '{}.{}'.format(dirname, package_name)
        if full_package_name not in sys.modules:
            yield (package_name,importer.find_module(full_package_name).load_module())

def add_auth(blueprint, username, password, realm="Default"):
    @blueprint.before_request
    def http_basic_auth():
        auth = request.authorization
        if not (auth and auth.password == password and auth.username == username):
            response = make_response('Unauthorized', 401)
            response.headers.set('WWW-Authenticate', 'Basic realm="%s"' % realm)
            return response
        return None

def create_app():
    """Initialize the core application."""
    app = Flask(__name__, instance_relative_config=True, static_folder = '/__static')
    app.config.from_object(flaskcode.default_config)
    app.config.from_object('app.config.Config')

    with app.app_context():
        from flaskcode import blueprint as bp
        add_auth(bp,app.config['FLASKCODE_USERNAME'],app.config['FLASKCODE_PASSWORD'])
        app.register_blueprint(bp, url_prefix='/admin')

        for name,module in load_blueprints('blueprints'):
            if hasattr(module, 'bp'):
                app.logger.info('loading blueprint {}'.format(name))
                app.register_blueprint(module.bp)
            else:
                app.logger.error('error loading blueprint {} you need to define "bp" in __init__.py'.format(name))

        return app
