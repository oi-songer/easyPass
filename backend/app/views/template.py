
from http import HTTPStatus
import typing

from flask import Blueprint, request
from flask import json
from flask.json import jsonify

from app import models, db
from app.status_code import MISSING_ARGUMENT
from app.auth.jwt import admin_login_required, company_login_required
from app.auth.jwt import jwt_auth, require_login

bp = Blueprint('template', __name__, url_prefix='/template')

@bp.route('/create', methods=['POST'])
@jwt_auth.login_required
@require_login([models.Company, models.Admin])
def create():
    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    title = data.get('title', None)
    description = data.get('description', None)

    if (title is None or description is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.Template.query.filter_by(title=title, status='approved').first() != None):
        return jsonify(message='该标题已被注册'), HTTPStatus.BAD_REQUEST

    template = models.Template(title, description)
    db.session.add(template)
    db.session.commit()

    if (models.Template.query.filter_by(title=title).first() is None):
        return jsonify({'message': '申请失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '申请成功，请等待审批'}), HTTPStatus.CREATED


@bp.route('/get', methods=['GET'])
@jwt_auth.login_required
@require_login([models.User, models.Company, models.Admin])
def get():
    user = jwt_auth.current_user()

    data = request.args
    status = data.get('status', None)
    account_id = data.get('account_id', None)
    # TODO use keywords

    if (status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (status not in ['approved', 'waiting', 'all', 'others', 'mine']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    templates = models.Template.query
    if (isinstance(user, models.Company)):
        if (status not in ['all', 'mine', 'others']):
            return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

        if (status == "mine"):
            templates = models.Template.query.filter_by(status='approved')\
                .join(models.Requirement, models.Requirement.template_id == models.Template.id)\
                .filter(models.Requirement.company_id == user.id)

    elif (isinstance(user, models.Admin)):
        if (status not in ['waiting', 'approved', 'all']):
            return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST
            
        if (status in ['waiting', 'approved']):
            templates = models.Template.query.filter_by(status=status)
    elif (isinstance(user, models.User)):
        if (status not in ['all', 'others']):
            return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

        # TODO 获取用户没用过的template（用户，无信息）


    # print("! count of templates: ", templates.count())


    # 如果是企业在请求，带上权限信息
    if (isinstance(user, models.Company)):
        return jsonify({
            'templates': [
                template.to_dict(company_id=user.id)
                for template in templates
            ]
        }), HTTPStatus.OK

    return jsonify({
        'templates': [
            template.to_dict()
            for template in templates
        ]
    }), HTTPStatus.OK



@bp.route('/approve', methods=['POST'])
@jwt_auth.login_required
@admin_login_required
def approve():
    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    template_id = data.get('template_id', None)
    status = data.get('status', None)

    if (status not in ['approved', 'unapproved']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    if (template_id is None or status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    template = models.Template.query.get(template_id)

    template.status = status
    db.session.commit()

    return jsonify({"message": "succeed"}), HTTPStatus.OK
