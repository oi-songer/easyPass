
from http import HTTPStatus
import typing

from flask import Blueprint, request
from flask import json
from flask.json import jsonify

from app import models, db
from app.status_code import MISSING_ARGUMENT
from app.utils import admin_login_required, company_login_required
from app.auth.jwt import jwt_auth, require_login

bp = Blueprint('template', __name__, url_prefix='/template')

@bp.route('/create', methods=['POST'])
@company_login_required
def create():
    company : models.Company = jwt_auth.current_user()

    data = request.get_json()
    title = data.get('title', None)
    description = data.get('description', None)

    if (title is None or description is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.Template.query.filter(title=title, status='approved').first() != None):
        return jsonify(message='该标题已被注册'), HTTPStatus.BAD_REQUEST

    template = models.Template(title, description, company.id)
    db.session.add(template)
    db.session.commit()

    if (models.Template.query.filter(title=title).first() is None):
        return jsonify({'message': '申请失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '申请成功，请等待审批'}), HTTPStatus.CREATED


@bp.route('/modify', methods=['POST'])
@company_login_required
def modify():
    # TODO
    pass


@bp.route('/get', methods=['GET'])
@require_login([models.User, models.Company, models.Admin])
def get():
    data = request.args
    status = data.get('status', None)

    if (status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (status not in ['approved', 'unapproved', 'all']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    templates : typing.List[models.Template]
    if (status != 'all'):
        templates = models.Template.query.filter(status=status).all()
    else:
        templates = models.Template.query.all()

    return jsonify({
        'templates': [
            template.to_dict()
            for template in templates
        ]
    }), HTTPStatus.OK


@bp.route('/approve', methods=['POST'])
@admin_login_required
def approve():
    data = request.get_json()
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
