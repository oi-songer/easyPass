from app.status_code import FORBIDDEN
from functools import wraps
import hashlib

from app.auth.jwt import jwt_auth
from app.models import Admin, Company, User

def encode_password(password):
    h = hashlib.md5(password.encode())
    return h.hexdigest()

def user_login_required(f):
    @wraps(f)
    def wrapper():
        user = jwt_auth.current_user()

        if (isinstance(user, User)):
            return f()

        return FORBIDDEN
    
    return wrapper


def company_login_required(f):
    @wraps(f)
    def wrapper():
        user = jwt_auth.current_user()

        if (isinstance(user, Company)):
            return f()

        return FORBIDDEN
    
    return wrapper

def admin_login_required(f):
    @wraps(f)
    def wrapper():
        user = jwt_auth.current_user()

        if (isinstance(user, Admin)):
            return f()

        return FORBIDDEN
    
    return wrapper