
from http import HTTPStatus

from flask import Blueprint, request
from flask import json
from flask.json import jsonify

from app import models, db
from app.status_code import MISSING_ARGUMENT
from app.utils import admin_login_required, company_login_required
from app.auth.jwt import jwt_auth

bp = Blueprint('template', __name__, url_prefix='/template')

@bp.route('/create', methods=['POST'])
@company_login_required
def create():
    company = jwt_auth.current_user

    data = request.get_json()
    title = data.get('title', None)
    description = data.get('description', None)

    if (title is None or description is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    template = models.Template(title, description, company.id)
    db.session.add(template)
    db.session.commit()

    if (models.Template.query.filter_by(title=title).first() is None):
        return jsonify({'message': '注册失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '注册成功，请前往登录界面登录'}), HTTPStatus.CREATED

@bp.route('/drop', methods=['POST'])
@company_login_required
def drop():
    # TODO
    pass


@bp.route('/modify', methods=['POST'])
@company_login_required
def modify():
    # TODO
    pass


@bp.route('/get', methods=['GET'])
@company_login_required
def get():
    # TODO
    pass


@bp.route('/approve', methods=['POST'])
@admin_login_required
def approve():
    data = request.get_json()
    template_id = data.get('template_id', None)
    approve = data.get('approve', None)

    if (template_id is None or approve is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    template = models.Template.query.get(template_id)
    template.approved = approve
    db.session.commit()

    return jsonify({"message": "succeed"}), HTTPStatus.OK
