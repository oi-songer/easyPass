from flask.json import jsonify
from itsdangerous import BadSignature, SignatureExpired, TimedJSONWebSignatureSerializer as Serializer
from app.models import Company, User
from flask import current_app
from flask_httpauth import HTTPTokenAuth
from http import HTTPStatus

jwt_auth = HTTPTokenAuth()

def generate_jwt_token_for_user(user : User):
    s = Serializer(current_app.config['JWT_SECRET_KEY'], expires_in=current_app.config['JWT_EXPIRES_SECOND'])
    token = s.dumps({'user_id': user.id}).decode('utf-8')

    return token


def generate_jwt_token_for_user(user : User):
    s = Serializer(current_app.config['JWT_SECRET_KEY'], expires_in=current_app.config['JWT_EXPIRES_SECOND'])
    token = s.dumps({'company_id': user.id}).decode('utf-8')

    return token


@jwt_auth.verify_token
def verify_token(token):
    s = Serializer(current_app.config['JWT_SECRET_KEY'])

    try:
        data = s.loads(token)
    except SignatureExpired:
        return False
    except BadSignature:
        return False
    
    if 'user_id' in data:
        user_id = data['user_id']
        user = User.query.get(user_id)

        if user is not None:
            return user
    if 'company_id' in data:
        company_id = data['company_id']
        company = Company.query.get(company_id)

        if company is not None:
            return company

    return False


@jwt_auth.error_handler
def error_handler():
    return jsonify({'message':'401 Unauthorized Access'}), HTTPStatus.UNAUTHORIZED
