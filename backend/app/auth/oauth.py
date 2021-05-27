# TODO
from http import HTTPStatus
from app.status_code import MISSING_ARGUMENT
import uuid
import time
import secrets
from flask import Blueprint, request
from flask.globals import current_app
from flask.json import jsonify
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer

bp = Blueprint('oauth', __name__, url_prefix='/oauth')


def generate_oauth_key(company):
    name = str(int(time.time())) + str(company.id)

    ak_uuid = uuid.uuid3(uuid.NAMESPACE_URL, name)

    # TIP
    ak = ''.join(str(ak_uuid).split('-'))

    # TIP
    sk = secrets.token_urlsafe(32)

    return ak, sk


@bp.route('/authorize', methods=['POST'])
def authorize():
    data = request.get_json()
    request_type = data.get('request_type', None)
    client_id = data.get('client_id', None)
    state = data.get('state', None)

    if (request_type is None or client_id is None or state is None):
        return jsonify(message=MISSING_ARGUMENT), HTTPStatus.BAD_REQUEST
    if (request_type != 'code'):
        return jsonify(message='request_type should be code'), HTTPStatus.BAD_REQUEST

    s = Serializer(current_app.config['JWT_SECRET_KEY'], expires_in=10 * 3600)
    code = s.dumps({
        'grant_token_dict': {
            'client_id': client_id,
        },
    })
