from flask import Flask
from sqlalchemy import DDL, event
from flask.ext.login import LoginManager, UserMixin
from flask.ext.sqlalchemy import SQLAlchemy
import settings

import flask_admin as admin
from flask_admin.contrib import sqla
from flask_admin.contrib.sqla import filters

app = Flask(__name__)
app.config['SECRET_KEY'] = settings.SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = settings.SQLALCHEMY_DATABASE_URI
app.config['OAUTH_CREDENTIALS'] = settings.OAUTH_CREDENTIALS

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'index'


# SQLAlchemy classes that reference to tables
# user_pofile, status, async_operation
class Users(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    facebook_id = db.Column(db.String(64), nullable=False, unique=True)
    username = db.Column(db.String(80), nullable=True, unique=True)
    first_name = db.Column(db.String(64), nullable=True)
    last_name = db.Column(db.String(64), nullable=True)
    email = db.Column(db.String(64), nullable=True)

    def __unicode__(self):
        return self.username

class AsyncOperationStatus(db.Model):
    __tablename__ = 'async_operation_status'
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column('code', db.String(20), nullable=True)


class AsyncOperation(db.Model):
    __tablename__ = 'async_operation'
    id = db.Column(db.Integer, primary_key=True)
    async_operation_status_id = db.Column(db.Integer, db.ForeignKey(AsyncOperationStatus.id))
    user_profile_id = db.Column(db.Integer, db.ForeignKey(Users.id))

    status = db.relationship('AsyncOperationStatus', foreign_keys=async_operation_status_id)
    user_profile = db.relationship('Users', foreign_keys=user_profile_id)


event.listen(
        AsyncOperationStatus.__table__, 'after_create',
        DDL(
                """ INSERT INTO async_operation_status (id,code) VALUES(1,'pending'),(2, 'ok'),(3, 'error'); """)
)
