from app import models
from app import db
from flask import Blueprint, request, make_response

bp = Blueprint('info', __name__, url_prefix='/info')


@bp.route('/get', methods=['POST', 'GET'])
def get():
    data = request.get_json()
    username = data['username']

    user = models.User.query.filter_by(username=username).first()
    infos = [ {"id": info.id, "content": info.content} for info in user.infos]

    ret_json = {
        "infos": infos,
    }

    return make_response(ret_json)

@bp.route('/get', methods=['POST', 'GET'])
def save():
    
    data = request.get_json()
    title = data['']
