
from flask import Blueprint

bp = Blueprint('views', __name__)

@bp.route('/hello')
def hello():
    return 'Hello, World!'