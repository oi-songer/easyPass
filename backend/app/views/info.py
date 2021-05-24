from http import HTTPStatus
from app import models, db
from app.auth.jwt import jwt_auth
from flask import Blueprint, request, make_response
from flask.json import jsonify

bp = Blueprint('info', __name__, url_prefix='/info')


@bp.route('/get', methods=['POST'])
@jwt_auth.login_required
def get():
    user : models.User = jwt_auth.current_user

    if (not isinstance(user, models.User)):
        return jsonify({'code':401, 'message':'401 Unauthorized Access'})

    data = request.get_json()
    info_id = data.get('info_id', None)
    keywords = data.get('keywords', None)

    infos = user.infos

    if (info_id != None):
        # TODO find info by id
        pass


    ret_json = {
        "infos": infos,
    }

    return make_response(ret_json)

@bp.route('/save', methods=['POST', 'GET'])
def save():
    
    # data = request.get_json()
    # title = data['']

    return jsonify({'message': 'error'}), HTTPStatus.BAD_REQUEST
