from flask.globals import current_app
from app.utils import encode_password
from flask_request_logger import RequestLogger
import os
import click

from redis import StrictRedis
from flask import Flask, g
from flask.cli import with_appcontext
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

db = SQLAlchemy()
redis = StrictRedis(host='121.5.160.8', port=6379, db=0, password='redis_pass')

# req_logger = RequestLogger()

# TIP
# 该函数是一个应用工厂函数
def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('../config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # init database
    db.init_app(app)
    app.cli.add_command(init_db)
    app.cli.add_command(drop_db)

    CORS(app)

    from app.views import account, admin, company, doc, info_auth
    from app.views import info, oauth, requirement, template, user
    bp_list = [
        account.bp, admin.bp, company.bp, doc.bp, info_auth.bp,
        info.bp, oauth.bp, requirement.bp, template.bp, user.bp
    ]
    for bp in bp_list:
        app.register_blueprint(bp)

    # req_logger.init_app(app)

    # a simple page that says hello

    return app

# TIP
@click.command('init-db')
@with_appcontext
def init_db():
    # 这里要先import models，才能根据models结构来create数据库表
    from app import models
    db.create_all()

    admin = models.Admin('admin', encode_password('admin'))
    db.session.add(admin)
    db.session.commit()
    
    click.echo('Initialized the database.\n')

@click.command('drop-db')
@with_appcontext
def drop_db():
    from app import models
    db.drop_all()
    
    click.echo('Dropped the database.\n')
