
from http import HTTPStatus
from flask.json import jsonify

MISSING_ARGUMENT = jsonify({'message': 'missing argument'}), HTTPStatus.BAD_REQUEST
UNAUTHORIZED = jsonify({'message': '401 Unauthorized Access'}), HTTPStatus.UNAUTHORIZED
FORBIDDEN = jsonify({'message': '403 Request forbidden'}), HTTPStatus.FORBIDDEN
