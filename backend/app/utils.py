
import hashlib

def encode_password(password):
    h = hashlib.md5(password.encode())
    return h.hexdigest()

