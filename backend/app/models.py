from re import template
import time

from datetime import time

from werkzeug.utils import redirect
from . import db
from sqlalchemy.sql import column

# TIP

class Template(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(40))
    description = db.Column(db.String(200))
    approved = db.Column(db.Boolean)

    infos = db.relationship('Info', backref='template', lazy='dynamic')
    requirements = db.relationship('Requirement', backref='template', lazy='dynamic')

    def __init__(self, title, description, company_id):
        self.title = title
        self.description = description
        self.company_id = company_id
        self.approved = False


class Info(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    create_time = db.Column(db.String(20))
    modify_time = db.Column(db.String(20))
    content = db.Column(db.String(100))

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    template_id = db.Column(db.Integer, db.ForeignKey('template.id'))

    def __init__(self, content, tempalte_id, user_id):
        self.content = content
        self.template_id = tempalte_id
        self.user_id = user_id
        self.create_time = time.asctime( time.localtime( time.time()))
        self.modify_time = time.asctime( time.localtime( time.time()))


infos = db.Table('infos',
    db.Column('account_id', db.Integer, db.ForeignKey('account.id')),
    db.Column('info_id', db.Integer, db.ForeignKey('info.id')),
)

class Account(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    infos = db.relationship('Info', secondary=infos,
        backref = db.backref('accounts', lazy='dynamic'), lazy='dynamic')

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    company_id = db.Column(db.Integer, db.ForeignKey('company.id'))

    def __init__(self, user_id, company_id):
        self.user_id = user_id,
        self.company_id = company_id

    def __repr__(self):
        return '<User-Company %r-%r>' % self.user


class Requirement(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    # 权限类型 (read, all)
    permission = db.Column(db.Integer)
    optional = db.Column(db.Boolean)
    
    template_id = db.Column(db.Integer, db.ForeignKey('template.id'))
    company_id = db.Column(db.Integer, db.ForeignKey('company.id'))

    def to_dict(self):
        return {
            'template_id': self.template_id,
            'template_title': self.template.title,
            'permission': self.permission,
            'optional': self.is_optional,
        }


class Company(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(32))

    client_id = db.Colum(db.String(32))
    secret_key = db.Column(db.String(32))

    # split by ,
    redirect_uris = db.Column(db.String(400))

    accounts = db.relationship('Account', backref='company', lazy='dynamic')
    requirements = db.relationship('Requirement', backref='company', lazy='dynamic')

    def __init__(self, username, password):
        self.username = username
        self.password = password

    def __repr__(self):
        return '<Company %r>' % self.username


class User(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    email = db.Column(db.String(30), unique=True)
    password = db.Column(db.String(32))

    accounts = db.relationship(
        'Account', backref='user', lazy='dynamic')
    infos = db.relationship('Info', backref='user', lazy='dynamic')

    def __init__(self, username, password, email = 'test@test.com'):
        self.username = username
        self.email = email
        self.password = password

    def __repr__(self):
        return '<User %r>' % self.username

    def to_dict(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
        }


class Admin(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(32))