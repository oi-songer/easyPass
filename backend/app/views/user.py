from app import models
from app import db
from flask import Blueprint, request, make_response

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('/register', methods=['POST', 'GET'])
def register():
    try:
        data = request.get_json()
        username = data['username']
        password = data['password']
    except Exception as e:
        print(e)
        raise
    
    user = models.User(username, password)

    if (models.User.query.filter_by(username=username).first() is not None):
        resp = make_response("用户已存在")
        return resp

    db.session.add(user)
    db.session.commit()

    if (models.User.query.filter_by(username=username).first() is None):
        resp = make_response("注册失败")
        return resp

    resp = make_response("注册成功，请前往登录界面登录")
    return resp

@bp.route('/login', methods=['GET', 'POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    user = models.User.query.filter_by(username=username).first()
    
    if (user is None):
        resp = make_response("用户不存在")
        return resp

    if (password != user.password):
        resp = make_response("密码错误")
        return resp

    resp = make_response("success")
    return resp
