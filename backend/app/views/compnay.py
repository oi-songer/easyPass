
from app.auth.jwt import generate_jwt_token_for_admin, generate_jwt_token_for_company
from http import HTTPStatus
from app import models
from app.utils import company_login_required, encode_password
from flask import Blueprint, request
from flask.json import jsonify

bp = Blueprint('company', __name__, url_prefix='/company')

@bp.route('/register', methods=['POST'])
def register():
    # 邮箱验证？管理员审核？
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


@bp.route('/generate_oauth_key', methods=['GET'])
@company_login_required
def generate_oauth_key():
    # TODO
    pass
