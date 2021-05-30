# 为企业提供的API，使用Oauth鉴权而非jwt鉴权

from re import template
import time
import typing
from flask.globals import current_app
from werkzeug.exceptions import BadRequest
from app.status_code import FORBIDDEN, MISSING_ARGUMENT
from app.utils import encode_password, encode_with_nonce_and_timestamp
from http import HTTPStatus
from flask.json import jsonify
from app import db, models, redis
from app.auth.jwt import auth_access_token_required, generate_jwt_token, generate_jwt_token_for_user, jwt_auth, refresh_token_required, user_login_required
from flask import Blueprint, request

bp = Blueprint('oauth', __name__, url_prefix='/oauth')


@bp.route('/get_info', methods=['POST'])
@jwt_auth.login_required
@auth_access_token_required
def get_info():
    dic = jwt_auth.current_user()
    token = dic.get('access_token')
    client_id = token.get('client_id', None)
    user_id = token.get('user_id', None)

    if (client_id is None or user_id is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    nonce = data.get('nonce', None)
    timestamp = data.get('timestamp', None)
    sign = data.get('sign', None)
    template_id = data.get('template_id', None)

    if (nonce is None or timestamp is None or sign is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    if (template_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    company : models.Company = models.Company.query.filter_by(client_id = client_id).first()

    if (company is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    # 鉴权部分

    # TIP redis config
    if (redis.exists(nonce)):
        return jsonify(message='Nonce is unlegal'), HTTPStatus.FORBIDDEN
    redis.setex(nonce, 30, 'true')

    # TIP
    cur_timestamp = int(round(time.time()))
    if (cur_timestamp - int(timestamp) < 0 or cur_timestamp - int(timestamp) > 30):
        return jsonify(message='Timestamp is unlegal'), HTTPStatus.FORBIDDEN

    # TIP
    my_sign = encode_with_nonce_and_timestamp([company.secret_key, timestamp, nonce])

    if (sign != my_sign):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN


    account : models.Account = models.Account.query.filter_by(user_id=user_id, company_id=company.id).first()
    if (account is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    info_auth = models.InfoAuth.query.join(models.Requirement, models.InfoAuth.requirement_id == models.Requirement.id)\
        .filter(
        models.InfoAuth.account_id == account.id,
        models.Requirement.template_id == template_id,
    ).first()

    if (info_auth == None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    # 业务逻辑部分
    info = info_auth.info

    return jsonify(message='succeed', info=info.content), HTTPStatus.OK

@bp.route('/modify_info', methods=['POST'])
@jwt_auth.login_required
@auth_access_token_required
def modify_info():
    dic = jwt_auth.current_user()
    token = dic.get('access_token')
    client_id = token.get('client_id', None)
    user_id = token.get('user_id', None)

    if (client_id is None or user_id is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
        
    nonce = data.get('nonce', None)
    timestamp = data.get('timestamp', None)
    sign = data.get('sign', None)
    template_id = data.get('template_id', None)
    content = data.get('content', None)

    if (nonce is None or timestamp is None or sign is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    if (template_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    company : models.Company = models.Company.query.filter_by(client_id = client_id).first()

    if (company is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    # 鉴权部分

    # TIP redis config
    if (redis.exists(nonce)):
        return jsonify(message='Nonce is unlegal'), HTTPStatus.FORBIDDEN
    redis.setex(nonce, 30, 'true')

    # TIP
    cur_timestamp = int(round(time.time()))
    if (cur_timestamp - int(timestamp) < 0 or cur_timestamp - int(timestamp) > 30):
        return jsonify(message='Timestamp is unlegal'), HTTPStatus.FORBIDDEN

    # TIP
    my_sign = encode_with_nonce_and_timestamp([company.secret_key, timestamp, nonce])

    if (sign != my_sign):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    # print('! edit user ', user_id, ' with template ', template_id, ' with company', company.id)

    account : models.Account = models.Account.query.filter_by(user_id=user_id, company_id=company.id).first()
    if (account is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    info_auth = models.InfoAuth.query.join(models.Requirement, models.InfoAuth.requirement_id == models.Requirement.id)\
        .filter(
        models.InfoAuth.account_id == account.id,
        models.Requirement.template_id == template_id,
    ).first()

    if (info_auth == None or info_auth.permission != 'all'):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN
    
    # 业务逻辑部分
    info = info_auth.info
    info.content = content
    db.session.commit()

    return jsonify(message='succeed'), HTTPStatus.OK

@bp.route('/refresh_token', methods=['POST'])
@jwt_auth.login_required
@refresh_token_required
def refresh_token():
    dic = jwt_auth.current_user()

    token_dic = dic.get('refresh_token', None)
    if (token_dic is None):
        return jsonify(message=FORBIDDEN), HTTPStatus.FORBIDDEN

    timeout : int
    if ('access_token' in token_dic):
        timeout = current_app.config['ACCESS_EXPIRES_SECOND']
    else:
        timeout = current_app.config['JWT_EXPIRES_SECOND']
    
    access_token = generate_jwt_token({
        'access_token':{
            **token_dic
        },
    }, timeout)

    refresh_token = generate_jwt_token({
        'refresh_token':{
            'access_token':{
                **token_dic
            },
        },
    }, timeout * 2)
    
    return jsonify(
        message='succeed',
        access_token=access_token,
        refresh_token=refresh_token,
    ), HTTPStatus.OK