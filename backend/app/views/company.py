
from flask import json
from app.auth.oauth import generate_oauth_key
from app.auth.jwt import jwt_auth, generate_jwt_token_for_company
from http import HTTPStatus
from app import models, db
from app.utils import company_login_required, encode_password
from flask import Blueprint, request
from flask.json import jsonify

bp = Blueprint('company', __name__, url_prefix='/company')

@bp.route('/register', methods=['POST'])
def register():
    # 邮箱验证？管理员审核？
    data = request.get_json()
    username = data['username']
    password = data['password']

    # TODO
    pass

@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    company = models.Company.query.filter_by(username=username).first()

    if (company is None):
        resp = jsonify({"message":"企业用户不存在"}), HTTPStatus.BAD_REQUEST
        return resp

    if (encode_password(password) != company.password):
        resp = jsonify({"message":"密码错误"}), HTTPStatus.BAD_REQUEST
        return resp

    token = generate_jwt_token_for_company(company)

    resp = jsonify({'message': '登陆成功', 'token': token})
    return resp, HTTPStatus.OK


@bp.route('/regenerate_oauth_key', methods=['POST'])
@company_login_required
def regenerate_oauth_key():
    company = jwt_auth.current_user

    ak, sk = generate_oauth_key(company)
    company.client_id = ak
    company.secret_key = sk
    db.session.commit()

    return jsonify(message = '生成成功'), HTTPStatus.OK
