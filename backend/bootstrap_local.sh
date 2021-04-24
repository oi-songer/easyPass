# export FLASK_APP=hello.py

# flask run

uwsgi --http 127.0.0.1:5000 --module hello:app
