import time

from app import db

# TIP

class Template(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(40))
    description = db.Column(db.String(200))

    # status: [approved, waiting]
    status = db.Column(db.String(10))

    infos = db.relationship('Info', backref='template', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)
    requirements = db.relationship('Requirement', backref='template', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)


    def __init__(self, title, description):
        self.title = title
        self.description = description
        self.status = 'waiting'

    def to_dict(self, company_id = 0):
        if (company_id != 0):
            requirement = self.requirements.filter_by(company_id=company_id).first()
            if (requirement != None):
                req_dic = requirement.to_dict()
            else:
                req_dic = {}
        return {
            'template_id': self.id,
            'title': self.title,
            'description': self.description,
            'status': self.status,
            'requirement': req_dic,
        }


class Info(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    create_time = db.Column(db.String(50))
    modify_time = db.Column(db.String(50))
    content = db.Column(db.String(1000))

    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    template_id = db.Column(db.Integer, db.ForeignKey('template.id', ondelete='CASCADE'))

    info_auths = db.relationship('InfoAuth', backref = 'info', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)

    def __init__(self, content, tempalte_id, user_id):
        self.content = content
        self.template_id = tempalte_id
        self.user_id = user_id
        self.create_time = time.asctime( time.localtime( time.time()))
        self.modify_time = time.asctime( time.localtime( time.time()))

    def to_dict(self):
        return {
            'info_id': self.id,
            'template_id': self.template.id,
            'title': self.template.title,
            'content': self.content,
            'user_id': self.user_id,
            'create_time': self.create_time,
            'modify_time': self.modify_time,
        }


class InfoAuth(db.Model):
    id = db.Column(db.Integer, primary_key=True)

    account_id = db.Column(db.Integer, db.ForeignKey('account.id', ondelete='CASCADE'))
    info_id = db.Column(db.Integer, db.ForeignKey('info.id', ondelete='CASCADE'))
    requirement_id = db.Column(db.Integer, db.ForeignKey('requirement.id', ondelete='CASCADE'))

    # 权限类型 (read, all)
    permission = db.Column(db.String(10))

    def __init__(self, account_id, info_id, requirement_id, permission, optional):
        self.account_id = account_id
        self.info_id = info_id
        self.requirement_id = requirement_id
        self.permission = permission
        self.optional = optional

    def to_dict(self):
        return {
            'info_auth_id': self.id,
            'permission': self.permission,
            'optional': self.optional,
        }


class Account(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    # infos = db.relationship('Info', secondary=infos,
    #     backref = db.backref('accounts', lazy='dynamic'), lazy='dynamic')
    info_auths = db.relationship('InfoAuth', backref = 'account', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    company_id = db.Column(db.Integer, db.ForeignKey('company.id', ondelete='CASCADE'))

    def __init__(self, user_id, company_id):
        self.user_id = user_id,
        self.company_id = company_id

    def __repr__(self):
        return '<User-Company %r-%r>' % self.user

    def to_dict(self):
        return {
            'account_id': self.id,
            'user_id': self.user_id,
            'company_id': self.company_id,
            'company_name': self.company.username,
            'company_description': self.company.description,
        }


class Requirement(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    # 权限类型 (read, all)
    permission = db.Column(db.String(10))
    optional = db.Column(db.Boolean)
    
    template_id = db.Column(db.Integer, db.ForeignKey('template.id', ondelete='CASCADE'))
    company_id = db.Column(db.Integer, db.ForeignKey('company.id', ondelete='CASCADE'))

    info_auths = db.relationship('InfoAuth', backref = 'requirement', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)

    def __init__(self, company_id, template_id, permission, optional):
        self.company_id = company_id
        self.template_id = template_id
        self.permission = permission
        self.optional = optional

    def to_dict(self):
        return {
            'requirement_id': self.id,
            'template_id': self.template_id,
            'template_title': self.template.title,
            'permission': self.permission,
            'optional': self.optional,
        }


class Company(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(32))
    description = db.Column(db.String(400))

    # status in [approved, unapproved, waiting]
    status = db.Column(db.String(10))

    client_id = db.Column(db.String(64))
    secret_key = db.Column(db.String(64))

    # split by ,
    redirect_uris = db.Column(db.String(400))

    accounts = db.relationship('Account', backref='company', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)
    requirements = db.relationship('Requirement', backref='company', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)

    def __init__(self, username, password, description):
        self.username = username
        self.password = password
        self.description = description
        self.status = 'waiting'
        self.client_id = ''
        self.secret_key = ''


    def __repr__(self):
        return '<Company %r>' % self.username

    def to_dict(self):
        return {
            'company_id': self.id,
            'username': self.username,
            'description': self.description,
        }


class User(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    email = db.Column(db.String(30), unique=True)
    password = db.Column(db.String(32))

    accounts = db.relationship(
        'Account', backref='user', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)
    infos = db.relationship('Info', backref='user', lazy='dynamic', cascade='all, delete-orphan', passive_deletes = True)

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

    def __init__(self, username, password):
        self.username = username
        self.password = password