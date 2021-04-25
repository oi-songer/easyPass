export FLASK_APP=app
export FLASK_ENV=development
flask run

# uwsgi --http 127.0.0.1:5000 --module app:app
