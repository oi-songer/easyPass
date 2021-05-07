import os
import click

from flask import Flask
from flask.cli import with_appcontext
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

db = SQLAlchemy()

# 该函数是一个应用工厂函数
def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        # DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('../config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # # ensure the instance folder exists
    # try:
    #     os.makedirs(app.instance_path)
    # except OSError:
    #     pass

    # init database
    db.init_app(app)
    app.cli.add_command(init_db)
    app.cli.add_command(drop_db)

    CORS(app)

    from .views import user
    app.register_blueprint(user.bp)

    # a simple page that says hello

    return app


@click.command('init-db')
@with_appcontext
def init_db():
    # 这里要先import models，才能根据models结构来create数据库表
    from . import models
    db.create_all()
    
    click.echo('Initialized the database.')

@click.command('drop-db')
@with_appcontext
def drop_db():
    from . import models
    db.drop_all()
    
    click.echo('Dropped the database.')
