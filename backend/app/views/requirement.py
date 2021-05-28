
from http import HTTPStatus
import http
from app.status_code import MISSING_ARGUMENT
from flask.json import jsonify
from app import db, models
from app.auth.jwt import jwt_auth, require_login
from flask import Blueprint, request

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('/create', methods=['POST'])
@require_login([models.Company])
def create():
    company : models.Company = jwt_auth.current_user()

    data = request.get_json()
    template_id = data.get('tempalte_id', None)
    permission = data.get('permission', None)
    optional = data.get('optional', None)

    if (template_id is None or permission is None or optional is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (permission not in ['read', 'all']):
        return jsonify(message='请求的权限不合法'), HTTPStatus.BAD_REQUEST

    if (models.Requirement.query.filter(company_id = company.id, template_id = template_id).first() != None):
        return jsonify(message='您已提出过该需求'), HTTPStatus.BAD_REQUEST

    requirement = models.Requirement(company.id, template_id, permission, optional)
    db.session.add(requirement)
    db.session.commit()

    if (models.Requirement.query.filter(company_id = company.id, template_id = template_id).first() is None):
        return jsonify({'message': '创建失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '创建成功'}), HTTPStatus.OK


@bp.route('/remove', methods=['POST'])
@require_login([models.Company])
def remove():
    company : models.Company = jwt_auth.current_user()
    
    data = request.get_json()
    template_id = data.get('template_id', None)

    requirement = models.Requirement.query.filter(company_id = company.id, template_id = template_id).first()
    if (requirement is None):
        return jsonify(message='该需求已经不存在'), HTTPStatus.BAD_REQUEST

    db.session.delete(requirement)
    db.session.commit()

    requirement = models.Requirement.query.filter(company_id = company.id, template_id = template_id).first()
    if (requirement != None):
        return jsonify(message='删除失败'), HTTPStatus.INTERNAL_SERVER_ERROR

    return jsonify(message='删除成功'), HTTPStatus.OK


@bp.route('/edit', methods=['POST'])
@require_login([models.Company])
def edit():
    company : models.Company = jwt_auth.current_user()

    data = request.get_json()
    template_id = data.get('tempalte_id', None)
    permission = data.get('permission', None)
    optional = data.get('optional', None)

    if (template_id is None or permission is None or optional is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (permission not in ['read', 'all']):
        return jsonify(message='请求的权限不合法'), HTTPStatus.BAD_REQUEST\
    
    requirement = models.Requirement.query.filter(company_id = company.id, template_id = template_id).first()
    requirement.permission = permission
    requirement.optional = optional
    db.session.commit()

    return jsonify(message='修改成功'), HTTPStatus.OK
