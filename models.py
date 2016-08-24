from flask import Flask
from sqlalchemy import DDL, event
from flask.ext.login import LoginManager, UserMixin
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SECRET_KEY'] = '47e585de7f22984d5ee291c2f31412384bfc32d0'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:nothing@localhost:32770/WeightLoss'
app.config['OAUTH_CREDENTIALS'] = {
    'facebook': {
        'id': '247355352098025',
        'secret': 'e0534de8dc07fc8bbc5cd852d975d983'
    }
}


db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'index'


# SQLAlchemy classes that reference to tables
# user_pofile, status, async_operation
class UserProfile(UserMixin, db.Model):
    __tablename__ = 'user_profile'
    id = db.Column(db.Integer, primary_key=True)
    facebook_id = db.Column(db.String(64), nullable=False, unique=True)
    first_name = db.Column(db.String(64), nullable=True)
    last_name = db.Column(db.String(64), nullable=True)
    email = db.Column(db.String(64), nullable=True)


class AsyncOperationStatus(db.Model):
    __tablename__ = 'async_operation_status'
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column('code', db.String(20), nullable=True)


class AsyncOperation(db.Model):
    __tablename__ = 'async_operation'
    id = db.Column(db.Integer, primary_key=True)
    async_operation_status_id = db.Column(db.Integer, db.ForeignKey(AsyncOperationStatus.id))
    user_profile_id = db.Column(db.Integer, db.ForeignKey(UserProfile.id))

    status = db.relationship('AsyncOperationStatus', foreign_keys=async_operation_status_id)
    user_profile = db.relationship('UserProfile', foreign_keys=user_profile_id)


event.listen(
        AsyncOperationStatus.__table__, 'after_create',
        DDL(
                """ INSERT INTO async_operation_status (id,code) VALUES(1,'pending'),(2, 'ok'),(3, 'error'); """)
)
