from functools import wraps
import hashlib

from http import HTTPStatus
from flask.json import jsonify
from app.auth.jwt import jwt_auth
from app.models import User

def encode_password(password):
    h = hashlib.md5(password.encode())
    return h.hexdigest()

def user_login_required(f):
    @wraps(f)
    def wrapper():
        user = jwt_auth.current_user()

        if (isinstance(user, User)):
            return f()

        return jsonify({'message':'403 Request forbidden'}), HTTPStatus.FORBIDDEN
    
    return wrapper
