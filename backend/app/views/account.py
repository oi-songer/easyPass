
from app import db, models
from http import HTTPStatus

from flask.globals import current_app
from app.status_code import MISSING_ARGUMENT
from app.auth.jwt import generate_jwt_token, jwt_auth, user_login_required
from flask.json import jsonify
from flask import Blueprint, request

bp = Blueprint('account', __name__, url_prefix='/account')

@bp.route('/third_party_login', methods=['POST'])
@jwt_auth.login_required
@user_login_required
def third_party_login():
    user = jwt_auth.current_user()

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    client_id = data.get('client_id', None)

    if (client_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    user_id = user.id

    access_token = generate_jwt_token({
        'access_token':{
            'client_id': client_id,
            'user_id': user_id,
        },
    }, current_app.config['ACCESS_EXPIRES_SECOND'])

    refresh_token = generate_jwt_token({
        'refresh_token':{
            'access_token':{
                'client_id': client_id,
                'user_id': user_id,
            },
        },
    }, current_app.config['ACCESS_EXPIRES_SECOND'] * 2)

    return jsonify(
        message='succeed',
        access_token=access_token,
        refresh_token=refresh_token,
    ), HTTPStatus.OK



# @bp.route('/third_party_check_register', methods=['GET'])
# @user_login_required
# def third_party_check_register():
#     user : models.User = jwt_auth.current_user()

#     data = request.get_json()
#     client_id = data.get('client_id', None)

#     if (client_id is None):
#         return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

#     company = models.Company.query.filter_by(client_id=client_id).first()

#     if (company is None):
#         return jsonify(message='client_id not passed'), HTTPStatus.BAD_REQUEST

#     if (user.accounts.query.filter_by(company_id=company.id).first() != None):
#         return jsonify(message='registerd'), HTTPStatus.OK

#     return jsonify(message='unregisterd'), HTTPStatus.OK


@bp.route('/check_requirements_changes', methods=['GET'])
@jwt_auth.login_required
@user_login_required
def check_requirements_changes():
    user : models.User = jwt_auth.current_user()

    data = request.args
    client_id = data.get('client_id', None)

    if (client_id is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    company : models.Company = models.Company.query.filter_by(client_id=client_id).first()
    if (company is None):
        return jsonify(message='client_id not passed'), HTTPStatus.BAD_REQUEST

    requirements = [ req.to_dict() for req in company.requirements]

    # check if user has this info
    for requirement in requirements:
        requirement['exist'] = True
        info = user.infos.filter_by(template_id=requirement['template_id']).first()
        if (info is None):
            requirement['exist'] = False

    account = models.Account.query.filter_by(company_id=company.id, user_id=user.id).first()

    # if it's a new account
    if (account == None):
        return jsonify(requirements=requirements, new_account=True), HTTPStatus.OK

    ret_requirements = []
    # check if user has already auth this info
    for requirement in requirements:
        if (requirement['exist'] == True):
            # 多表联合
            info_auth : models.InfoAuth = models.InfoAuth.query\
                .join(models.Account, models.InfoAuth.account_id == models.Account.id)\
                .filter_by(company_id=company.id).first()

            if (info_auth == None):
                if (requirement['optional'] == True):
                    continue
                requirement['old_optional'] = True
            
            if (info_auth != None):
                if (info_auth.permission == requirement['permission']):
                    continue
                requirement['old_permission'] = info_auth.permission

        ret_requirements.append(requirement)

    return jsonify(requirements=ret_requirements, new_account=False), HTTPStatus.OK


# 该接口不仅仅在注册时使用，在企业的信息需求发生变更时也会被调用
@bp.route('/third_party_register', methods=['POST'])
@jwt_auth.login_required
def third_party_register():
    user : models.User = jwt_auth.current_user()

    data = request.get_json()
    if (data is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    client_id = data.get('client_id', None)
    approvements = data.get('approvements', None)

    if (client_id is None or approvements is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST

    # modify database
    company : models.Company = models.Company.query.filter_by(client_id=client_id).first()
    if (company is None):
        return jsonify(message='client_id not passed'), HTTPStatus.BAD_REQUEST
    
    account = models.Account.query.filter_by(user_id = user.id, company_id = company.id).first()
    # 如果当前未注册
    if (account is None):
        account = models.Account(user.id, company.id)
        db.session.add(account)
        db.session.flush()

    try:
        # 对于每一个需要批准的权限
        for approvement in approvements:
            requirement : models.Requirement = models.Requirement.query.get(approvement['requirement_id'])

            info_auth = models.InfoAuth.query.filter_by(requirement_id = requirement.id, account_id = account.id).first()

            # 如果该info_auth已经存在
            if (info_auth != None):
                info_auth.permission = requirement.permission
            else:   # 否则需要新建一个info_auth
                info = models.Info.query.filter_by(template_id = requirement.template_id, user_id=user.id).first()
                # 如果用户没有填写对应的Info
                if (info is None):
                    raise Exception('用户未填写Info')

                info_auth = models.InfoAuth(account.id, info.id, requirement.id, requirement.permission, requirement.optional)
                db.session.add(info_auth)
    except Exception as e:
        db.session.rollback()
        return jsonify(message=str(e)), HTTPStatus.BAD_REQUEST

    # 保存数据库更改
    db.session.commit()

    # generate key
    user_id = user.id

    access_token = generate_jwt_token({
        'access_token':{
            'client_id': client_id,
            'user_id': user_id,
        },
    }, current_app.config['ACCESS_EXPIRES_SECOND'])

    refresh_token = generate_jwt_token({
        'refresh_token':{
            'access_token':{
                'client_id': client_id,
                'user_id': user_id,
            },
        },
    }, current_app.config['ACCESS_EXPIRES_SECOND'] * 2)

    return jsonify(
        message='succeed',
        access_token=access_token,
        refresh_token=refresh_token,
    ), HTTPStatus.OK


@bp.route('/get', methods=['GET'])
@jwt_auth.login_required
@user_login_required
def get():
    # TODO
    pass

@bp.route('/remove', methods=['POST'])
@jwt_auth.login_required
@user_login_required
def remove():
    # TODO
    pass