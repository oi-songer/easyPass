from flask.json import jsonify
from app import db, models
from app.auth.jwt import generate_jwt_token, jwt_auth
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
        resp = jsonify({"message":"用户不存在"})
        return resp

    if (password != user.password):
        resp = jsonify({"message":"密码错误"})
        return resp

    token = generate_jwt_token(user)

    resp = jsonify({"message": "登陆成功", "token":token})
    return resp

@bp.route('/modify_user_info', methods=['POST'])
@jwt_auth.login_required
def modify_user_info():
    user = jwt_auth.current_user()

    return jsonify(user.to_dict())


@bp.route('/get_infos', methods=['POST'])
@jwt_auth.login_required
def get_infos():
    user : models.User = jwt_auth.current_user

    data = request.get_json()
    keywords = data['keywords']


    user = models.User.query.filter_by(username=user.username).first()
    if (user is None):
        resp = make_response("错误：当前用户不存在")
        return resp

    infos = user.infos

    if (keywords != ''):
        # TODO search using keywords
        pass


    ret_dict = {
        "infos": [
            info.__dict__ for info in infos
        ]
    }

    return make_response(ret_dict)