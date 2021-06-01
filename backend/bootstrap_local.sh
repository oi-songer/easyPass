# disable check https
# export AUTHLIB_INSECURE_TRANSPORT=1

# flask drop-db
# flask init-db
# flask logger init_db

export FLASK_APP=app
export FLASK_ENV=development
flask run -h 0.0.0.0

# uwsgi --http 127.0.0.1:5000 --module app:create_app
