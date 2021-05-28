import uuid
import time
import secrets


def generate_oauth_key(company):
    name = str(int(time.time())) + str(company.id)

    ak_uuid = uuid.uuid3(uuid.NAMESPACE_URL, name)

    # TIP
    ak = ''.join(str(ak_uuid).split('-'))

    # TIP
    sk = secrets.token_urlsafe(32)

    return ak, sk

