
from app.status_code import MISSING_ARGUMENT
from app.auth.jwt import jwt_auth, admin_login_required, generate_jwt_token_for_admin
from app.utils import encode_password
from http import HTTPStatus
from flask.json import jsonify
from app import db, models
from flask import Blueprint, request

bp = Blueprint('admin', __name__, url_prefix='/admin')

@bp.route('/register', methods=['POST'])
@admin_login_required
def register():
    data = request.get_json()
    username = data.get('username', None)
    password = data.get('password', None)
    email = data.get('email', None)
    
    if (username is None or password is None or email is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    if (models.User.query.filter(username=username).first() != None):
        return jsonify(message='用户名已被注册'), HTTPStatus.BAD_REQUEST

    if (models.User.query.filter(email=email).first() != None):
        return jsonify(message='邮箱已被注册'), HTTPStatus.BAD_REQUEST
    
    user = models.User(username, encode_password(password), email)

    db.session.add(user)
    db.session.commit()

    if (models.User.query.filter(username=username).first() is None):
        return jsonify({'message': '注册失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '注册成功，请前往登录界面登录'}), HTTPStatus.CREATED


@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    admin = models.Admin.query.filter(username=username).first()
    
    if (admin is None):
        resp = jsonify({"message":"用户不存在"}), HTTPStatus.BAD_REQUEST
        return resp

    if (encode_password(password) != admin.password):
        resp = jsonify({"message":"密码错误"}), HTTPStatus.BAD_REQUEST
        return resp

    token = generate_jwt_token_for_admin(admin)

    resp = jsonify({"message": "登陆成功", "token":token})
    return resp, HTTPStatus.OK


@bp.route('/modify_password', methods=['POST'])
@admin_login_required
def modify_password():
    admin : models.Admin = jwt_auth.current_user()

    data = request.get_json()

    old_password = data['old_password']
    new_password = data['new_password']

    if (encode_password(old_password) == admin.password):
        admin.password = encode_password(new_password)
        db.session.commit()
    else:
        return jsonify({'message': '旧密码错误'}), HTTPStatus.BAD_REQUEST


    return jsonify({'message': '更改密码成功'}), HTTPStatus.OK