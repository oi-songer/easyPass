from re import template
from time import time
import typing
from flask import json
from flask.signals import template_rendered
from app.status_code import FORBIDDEN, MISSING_ARGUMENT
from http import HTTPStatus
from app import models, db
from app.auth.jwt import jwt_auth, user_login_required
from flask import Blueprint, request
from flask.json import jsonify

bp = Blueprint('info', __name__, url_prefix='/info')


@bp.route('/create', methods=['POST'])
@jwt_auth.login_required
@user_login_required
def create():
    user = jwt_auth.current_user()

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    content = data.get('content', None)
    template_id = data.get('template_id', None)

    if (content is None or template_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.Template.query.get(template_id) is None):
        return jsonify(message='对应的模板不存在'), HTTPStatus.BAD_REQUEST

    if (models.Info.query.filter_by(user_id=user.id, template_id=template_id).first() != None):
        return jsonify(message='该条信息已存在'), HTTPStatus.BAD_REQUEST

    info = models.Info(content, template_id, user.id)
    db.session.add(info)
    db.session.commit()

    return jsonify({'message': '创建信息成功'}), HTTPStatus.CREATED


@bp.route('/drop', methods=['POST'])
@jwt_auth.login_required
@user_login_required
def drop():
    user = jwt_auth.current_user()

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
@jwt_auth.login_required
@user_login_required
def get():
    user : models.User = jwt_auth.current_user()

    data = request.args
    keywords = data.get('keywords', None)
    filter_method = data.get('filter_method', None)

    if (keywords is None or filter_method is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (filter_method not in ['我的', '全部']):
        return jsonify(message='filter_method 数值不合法'), HTTPStatus.BAD_REQUEST

    keyword_list = ['%' + keyword.strip() + '%' for keyword in keywords.split()]

    if (filter_method=='我的'):
        infos = user.infos
    else:
        infos = models.infos.query

    # TODO test is this work
    # if has keywords, filter keywords in title or content
    if (keywords != ''):
        infos = infos.filter(
            map(lambda x,y: x&y,
                *[models.Info.content.like('%{0}%'.format(keyword))
                for keyword in keyword_list]
            )&
            map(lambda x,y: x&y,
                *[models.Info.template.title.like('%{0}%'.format(keyword)) 
                for keyword in keyword_list]
            ),
        )

    info_list = [
        {
            'info_id': info.id,
            'title': info.template.title,
            'modify_time': info.modify_time,
            'created': True,
        } for info in infos.all()
    ]

    return jsonify({
        'message': 'success',
        'code': 0,
        'infos': info_list,
    }), HTTPStatus.OK



@bp.route('/get_detail', methods=['GET'])
@jwt_auth.login_required
@user_login_required
def get_detail():
    user : models.User = jwt_auth.current_user()

    data = request.args
    info_id = data.get('info_id', None)

    if (info_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    
    info : models.Info = models.Info.query.get(info_id)
    
    if (info.user.id != user.id):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    return jsonify(
        message='succeed',
        info=info.to_dict(),
    )


@bp.route('/modify', methods=['POST'])
@jwt_auth.login_required
@user_login_required
def modify():
    user = jwt_auth.current_user()

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    info_id = data.get('info_id', None)
    content = data.get('content', None)

    if (id is None or content is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    info = models.Info.query.get(info_id)

    # check owner
    if (info is None):
        return jsonify(message = 'info does not exist'), HTTPStatus.BAD_REQUEST

    if (info.user_id != user.id):
        return jsonify(message = FORBIDDEN), HTTPStatus.FORBIDDEN
    
    info.content = content
    db.session.commit()

    return jsonify(message = '修改成功'), HTTPStatus.OK
