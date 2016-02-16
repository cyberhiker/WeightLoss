# coding=utf-8
# Created 2014 by Janusz Skonieczny
import logging
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

from flask import app
import settings

from datetime import datetime
import sqlalchemy as sa

from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.ext.declarative import declarative_base

logging.debug(settings.SQLALCHEMY_DATABASE_URI)
engine = create_engine(settings.SQLALCHEMY_DATABASE_URI, convert_unicode=True)
db_session = scoped_session(sessionmaker(autocommit=False,
                                         autoflush=False,
                                         bind=engine))
Base = declarative_base()
Base.query = db_session.query_property()

def init_db():
    # import all modules here that might define models so that
    # they will be registered properly on the metadata.  Otherwise
    # you will have to import them first before calling init_db()
    logging.debug("db.create_all")
    db.create_all()

from flask import current_app
from flask_babel import gettext as _
from flask_sqlalchemy import SQLAlchemy
from flask_security import UserMixin, RoleMixin, Security, SQLAlchemyUserDatastore

class Weeks(db.Model):
    __tablename__ = 'weeks'
    id = sa.Column(sa.Integer(), primary_key=True)
    weekStart = sa.Column(sa.DateTime, unique=True)

    def __init__(self, weekStart=None):
        self.weekStart = weekStart

    def __repr__(self):
        return '<Weeks(weekStart=%s)>' % (self.weekStart)


class Weights(db.Model):
    __tablename__ = 'weights'
    id = sa.Column(sa.Integer(), primary_key=True)
    email = sa.Column(sa.String(50))
    weight = sa.Column(sa.Float)
    weekOf = sa.Column(sa.DateTime)
    dateEntered = sa.Column(sa.DateTime)

    def __init__(self, email=None, weight=None, weekOf=None, dateEntered=None):
        self.email = email
        self.weight = weight
        self.weekOf = weekOf
        self.dateEntered = dateEntered

    def __repr__(self):
        return "<Weights(email='%s', weight='%s', weekOf='%s', dateEntered='%s')>" % (
            self.email, self.weight, self.weekOf, self.dateEntered)


class Measurements(db.Model):
    __tablename__ = 'measurements'
    id = sa.Column(sa.Integer(), primary_key=True)
    email = sa.Column(sa.String(50))
    weekOf = sa.Column(sa.DateTime)
    dateEntered = sa.Column(sa.DateTime)
    waist = sa.Column(sa.Float)
    thigh = sa.Column(sa.Float)
    hips = sa.Column(sa.Float)
    chest = sa.Column(sa.Float)
    arm = sa.Column(sa.Float)
    calf = sa.Column(sa.Float)

    def __init__(self, email=None, weekOf=None, dateEntered=None, waist=None, thigh=None, hips=None, chest=None, arm=None, calf=None):
        self.email = email
        self.weekOf = weekOf
        self.dateEntered = dateEntered
        self.waist = waist
        self.thigh = thigh
        self.hips = hips
        self.chest = chest
        self.arm = arm
        self.calf = calf

    def __repr__(self):
        return "<Measurements(email='%s', weekOf='%s', dateEntered='%s', waist='%s', thigh='%s', hips='%s', chest='%s', arm='%s', calf='%s')>" % (
            self.email, self.weekOf, self.dateEntered, self.waist, self.thigh, self.hips, self.chest, self.arm, self.calf)
