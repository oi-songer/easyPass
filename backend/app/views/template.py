
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

    if (models.Template.query.filter_by(title=title, status='approved').first() != None):
        return jsonify(message='该标题已被注册'), HTTPStatus.BAD_REQUEST

    template = models.Template(title, description, company.id)
    db.session.add(template)
    db.session.commit()

    if (models.Template.query.filter_by(title=title).first() is None):
        return jsonify({'message': '申请失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '申请成功，请等待审批'}), HTTPStatus.CREATED


@bp.route('/get', methods=['GET'])
@require_login([models.User, models.Company, models.Admin])
def get():
    data = request.args
    status = data.get('status', None)
    account_id = data.get('account_id', None)

    if (status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (status not in ['approved', 'unapproved', 'all']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    if (account_id != None):
        account : models.Account = models.Account.get(account_id)

        # 找到该企业用户要求的所有Template
        templates = models.Template.query\
            .join(models.Requirement, models.Requirement.template_id == models.Template.id)\
            .filter(models.Requirement.company_id == account.company_id)

        info_auths : typing.List[models.InfoAuth] = account.info_auths

        info_list = []
        for template in templates:
            info_list.append(
                {
                    'info_id': template.id,
                    'title': template.title,
                    'created': True,
                }
            )
        info_list = [
            {
                'info_id': info.id,
                'title': info.template.title,
                'modify_time': info.modify_time,
                'created': True,
            } for index, info in enumerate(infos)
        ]
        # TODO

    templates : typing.List[models.Template]
    if (status != 'all'):
        templates = models.Template.query.filter_by(status=status).all()
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
