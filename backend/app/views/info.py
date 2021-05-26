from flask.signals import template_rendered
from app.status_code import FORBIDDEN, MISSING_ARGUMENT
from http import HTTPStatus
from app import models, db
from app.auth.jwt import jwt_auth, user_login_required
from flask import Blueprint, request
from flask.json import jsonify

bp = Blueprint('info', __name__, url_prefix='/info')


@bp.route('/create', methods=['POST'])
@user_login_required
def create():
    user = jwt_auth.current_user

    data = request.get_json()
    content = data.get('content', None)
    template_id = data.get('template_id', None)

    if (content is None or template_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.Template.query.get(template_id) is None):
        return jsonify(message = '对应的模板不存在'), HTTPStatus.BAD_GATEWAY

    info = models.Info(content, template_id, user.id)
    db.session.add(info)
    db.session.commit()

    return jsonify({'message': '创建信息成功'}), HTTPStatus.CREATED


@bp.route('/drop', methods=['POST'])
@user_login_required
def drop():
    user = jwt_auth.current_user

    data = request.get_sjon()
    info_id = data.get('info_id', None)

    if (info_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    info = models.Info.query.get(info_id)
    if (info is None):
        return jsonify(message = '该信息已不存在'), HTTPStatus.BAD_REQUEST
    
    if (info.user_id != user.id):
        return jsonify(message = FORBIDDEN), HTTPStatus.FORBIDDEN

    db.session.delete(info);
    db.session.commit()

    return jsonify({'message': '删除信息成功'}), HTTPStatus.NO_CONTENT


@bp.route('/get', methods=['GET'])
@user_login_required
def get():
    user : models.User = jwt_auth.current_user

    # TODO 获取get的参数
    data = request.get_json()
    info_id = data.get('info_id', None)
    keywords = data.get('keywords', None)

    infos = user.infos

    if (info_id != None):
        # TODO find info by id
        pass

    if (keywords != ''):
        # TODO
        pass

    return jsonify({
        'message': 'success',
        'code': 0,
        'infos': [
            {
                'id': info.id,
                'content': info.content,
                'title': info.template.title,
                'create_time': info.create_time,
                'modify_time': info.modify_time,
            } for info in infos
        ],
    }), HTTPStatus.OK



@bp.route('/modify', methods=['POST'])
@user_login_required
def modify():
    user = jwt_auth.current_user

    data = request.get_json()
    info_id = data.get('id', None)
    content = data.get('content', None)

    if (id is None or content is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    info = models.Info.get(info_id)

    # check owner
    if (info.user_id != user.id):
        return jsonify(message = FORBIDDEN), HTTPStatus.FORBIDDEN
    
    if (info is None):
        return jsonify(message = 'info does not exist'), HTTPStatus.BAD_REQUEST

    info.content = content
    db.session.commit()

    return jsonify(message = '修改成功'), HTTPStatus.OK
