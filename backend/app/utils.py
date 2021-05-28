
import hashlib
import typing

def encode_password(password):
    h = hashlib.md5(password.encode())
    return h.hexdigest()

def encode_with_nonce_and_timestamp(key_list : typing.List[int]):
    key_list.sort()
    s = ''.join(map(str, key_list))
    h = hashlib.md5(s)
    return h.hexdigest()
