
import typing
from app.status_code import MISSING_ARGUMENT
from flask import json
from app.auth.oauth import generate_oauth_key
from app.auth.jwt import admin_login_required, company_login_required
from app.auth.jwt import jwt_auth, generate_jwt_token_for_company
from http import HTTPStatus
from app import models, db
from app.utils import encode_password
from flask import Blueprint, request
from flask.json import jsonify

bp = Blueprint('company', __name__, url_prefix='/company')

@bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    username = data['username']
    password = data['password']
    description = data['description']

    if (username is None or password is None or description is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.Company.query.filter_by(username=username, status='approved').first() != None):
        return jsonify(message='企业用户名已被注册'), HTTPStatus.BAD_REQUEST
    
    company = models.Company(username, encode_password(password), description)

    db.session.add(company)
    db.session.commit()

    if (models.Company.query.filter_by(username=username).first() is None):
        return jsonify({'message': '注册失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '注册成功，请前往登录界面登录'}), HTTPStatus.CREATED

@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    username = data['username']
    password = data['password']

    company = models.Company.query.filter_by(username=username).first()

    if (company is None):
        resp = jsonify({"message":"企业用户不存在"}), HTTPStatus.BAD_REQUEST
        return resp

    if (encode_password(password) != company.password):
        resp = jsonify({"message":"密码错误"}), HTTPStatus.BAD_REQUEST
        return resp

    if (company.status == 'waiting'):
        resp = jsonify(message='正在审批中，请耐心等待'), HTTPStatus.BAD_REQUEST
        return resp

    if (company.status == 'unapproved'):
        resp = jsonify(message='审批不通过，请尝试重新申请'), HTTPStatus.BAD_REQUEST
        return resp

    token = generate_jwt_token_for_company(company)

    resp = jsonify({'message': '登陆成功', 'token': token})
    return resp, HTTPStatus.OK


@bp.route('/get_oauth_key', methods=['GET'])
@jwt_auth.login_required
@company_login_required
def get_oauth_key():
    company = jwt_auth.current_user()

    client_id = company.client_id
    secret_key = company.secret_key

    return jsonify({
        'client_id': client_id,
        'secret_key': secret_key,
    }), HTTPStatus.OK


@bp.route('/regenerate_oauth_key', methods=['POST'])
@jwt_auth.login_required
@company_login_required
def regenerate_oauth_key():
    company = jwt_auth.current_user()

    ak, sk = generate_oauth_key(company)
    company.client_id = ak
    company.secret_key = sk
    db.session.commit()

    return jsonify(message = '生成成功'), HTTPStatus.OK


@bp.route('/modify_password', methods=['POST'])
@jwt_auth.login_required
@company_login_required
def modify_password():
    user : models.Company = jwt_auth.current_user()

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        

    old_password = data['old_password']
    new_password = data['new_password']

    if (encode_password(old_password) == user.password):
        user.password = encode_password(new_password)
        db.session.commit()
    else:
        return jsonify({'message': '旧密码错误'}), HTTPStatus.BAD_REQUEST


    return jsonify({'message': '更改密码成功'}), HTTPStatus.OK


@bp.route('/approve', methods=['POST'])
@jwt_auth.login_required
@admin_login_required
def approve():
    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    company_id = data.get('company_id', None)
    status = data.get('status', None)

    if (status not in ['approved', 'waiting', 'unapproved']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    if (company_id is None or status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    company = models.Company.query.get(company_id)

    if (status == 'unapproved'):
        db.session.delete(company)
    else:
        company.status = status

    db.session.commit()

    return jsonify({"message": "succeed"}), HTTPStatus.OK


@bp.route('/get', methods=['GET'])
@jwt_auth.login_required
@admin_login_required
def get():
    
    data = request.args
    status = data.get('status', None)

    if (status is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (status not in ['approved', 'waiting', 'all']):
        return jsonify(message='status参数不合法'), HTTPStatus.BAD_REQUEST

    companies : typing.List[models.Company]
    if (status != 'all'):
        companies = models.Company.query.filter_by(status=status).all()
    else:
        companies = models.Company.query.all()

    return jsonify({
        'companies': [
            company.to_dict()
            for company in companies
        ] 
    }), HTTPStatus.OK
