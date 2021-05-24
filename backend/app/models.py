from . import db
from sqlalchemy.sql import column

class User(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    email = db.Column(db.String(30), unique=True)
    password = db.Column(db.String(32))

    accounts = db.relationship(
        'Account', backref='user', lazy='dynamic')
    infos = db.relationship('Info', backref='owner', lazy='dynamic')

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


class Company(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(32))

    accounts = db.relationship('Account', backref='company', lazy='dynamic')
    templates = db.relationship('Template', backref='owner', lazy='dynamic')

    def __init__(self, username, password):
        self.username = username
        self.password = password

    def __repr__(self):
        return '<Company %r>' % self.username


class Template(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(40))
    private = db.Column(db.Boolean)

    infos = db.relationship('Info', backref='template', lazy='dynamic')

    company_id = db.Column(db.Integer, db.ForeignKey('company.id'))


class Info(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    create_time = db.Column(db.String(20))
    modify_time = db.Column(db.String(20))
    content = db.Column(db.String(100))

    wrappers = db.relationship(
        'InfoWrapper', backref='info_content', lazy='dynamic')


    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    template_id = db.Column(db.Integer, db.ForeignKey('template.id'))


class InfoWrapper(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    # 权限类型
    permission = db.Column(db.Integer)
    
    info_id = db.Column(db.Integer, db.ForeignKey('info.id'))
    user_company_rela_id = db.Column(db.Integer, db.ForeignKey('account.id'))


class Account(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    login_histories = db.relationship(
        'LoginHistory', backref='account', lazy='dynamic')

    info_list = db.relationship(
        'InfoWrapper', backref='account', lazy='dynamic')

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    company_id = db.Column(db.Integer, db.ForeignKey('company.id'))

    def __init__(self, user_id, company_id):
        self.user_id = user_id,
        self.company_id = company_id

    def __repr__(self):
        return '<User-Company %r-%r>' % self.user


class LoginHistory(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    ip = db.Column(db.String(30))
    device = db.Column(db.String(20))
    
    account_id = db.Column(db.Integer, db.ForeignKey('account.id'))
