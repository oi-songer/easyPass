from app.status_code import MISSING_ARGUMENT
from app.utils import encode_password
from http import HTTPStatus
from flask.json import jsonify
from app import db, models
from app.auth.jwt import generate_jwt_token_for_user, jwt_auth, user_login_required
from flask import Blueprint, request

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('/register', methods=['POST', 'GET'])
def register():
    data = request.get_json()
    username = data.get('username', None)
    password = data.get('password', None)
    
    if (username is None or password is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    
    user = models.User(username, encode_password(password))

    if (models.User.query.filter_by(username=username).first() is not None):
        return jsonify({'message': '用户已存在'}), HTTPStatus.BAD_REQUEST

    db.session.add(user)
    db.session.commit()

    if (models.User.query.filter_by(username=username).first() is None):
        return jsonify({'message': '注册失败'}), HTTPStatus.BAD_REQUEST

    return jsonify({'message': '注册成功，请前往登录界面登录'}), HTTPStatus.CREATED

@bp.route('/login', methods=['GET', 'POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    user = models.User.query.filter_by(username=username).first()
    
    if (user is None):
        resp = jsonify({"message":"用户不存在"}), HTTPStatus.BAD_REQUEST
        return resp

    if (encode_password(password) != user.password):
        resp = jsonify({"message":"密码错误"}), HTTPStatus.BAD_REQUEST
        return resp

    token = generate_jwt_token_for_user(user)

    resp = jsonify({"message": "登陆成功", "token":token})
    return resp, HTTPStatus.OK

@bp.route('/modify_user_info', methods=['POST'])
@user_login_required
def modify_user_info():
    user = jwt_auth.current_user()
    
    data = request.get_json()
    username = data.get('username', None)
    # TODO

    return jsonify(user.to_dict())


@bp.route('/modify_password', methods=['POST'])
@user_login_required
def modify_password():
    user : models.User = jwt_auth.current_user()

    data = request.get_json()

    old_password = data['old_password']
    new_password = data['new_password']

    if (encode_password(old_password) == user.password):
        user.password = encode_password(new_password)
        db.session.commit()
    else:
        return jsonify({'message': '旧密码错误'}), HTTPStatus.BAD_REQUEST


    return jsonify({'message': '更改密码成功'}), HTTPStatus.OK
 