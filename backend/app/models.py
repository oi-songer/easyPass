from . import db


class User(db.Model):
    __talbe__name = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    email = db.Column(db.String(30), unique=True)
    password = db.Column(db.String(32))

    companies = db.relationship(
        'UserCompany', backref='company', lazy='dynamic')
    infos = db.relationship('Info', backref='owner', lazy='dynamic')

    def __init__(self, username, email, password):
        self.username = username
        self.email = email
        self.password = password

    def __repr__(self):
        return '<User %r>' % self.username


class Company(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(32))

    users = db.relationship('UserCompany', backref='company', lazy='dynamic')
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


class Info(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    wrappers = db.relationship(
        'InfoWrapper', backref='info_content', lazy='dynamic')

    content = db.Column(db.String(100))


class InfoWrapper(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    # 权限类型
    permission = db.Column(db.Integer)


class UserCompanyRela(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('User.id'))
    company_id = db.Column(db.Integer, db.ForeignKey('Company.id'))

    login_histories = db.relationship(
        'LoginHistory', backref='user_company_rela', lazy='dynamic')

    info_list = db.relationship(
        'InfoWrapper', backref='user_company_rela', lazy='dynamic')

    def __init__(self, user_id, Company_id):
        self.user_id = user_id,
        self.company_id = company_id

    def __repr__(self):
        return '<User-Company %r-%r>' % self.user


class LoginHistory(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    ip = db.Column(db.String(30))
