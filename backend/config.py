
# mysql config
SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://easypass:R8tV7uaU3qJ7BqHc@121.5.160.8/easypass?charset=utf8'
SQLALCHEMY_TRACK_MODIFICATIONS = True

# token secret key
JWT_SECRET_KEY=""   # TODO
JWT_EXPIRES_SECOND=3600*24*14

# oauth token
JWT_OAUTH_EXPIRES_SECOND=3600*24*7
