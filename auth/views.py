# coding=utf-8
# Created 2014 by Janusz Skonieczny
import logging
import datetime
from flask import Blueprint, current_app, render_template
from flask_login import login_required, current_user
from database import *
from flask_sqlalchemy import SQLAlchemy

app = Blueprint("auth", __name__, template_folder="templates")

@app.route("/")
@login_required
def profile():
    ww = Weights.query.filter_by(email=current_user.email)
    today = datetime.now().strftime('%A')

    if settings.WEIGHINDAY == 0:
        weighDay = 'Sunday'
    elif settings.WEIGHINDAY == 1:
        weighDay = 'Monday'
    elif settings.WEIGHINDAY == 2:
        weighDay = 'Tuesday'
    elif settings.WEIGHINDAY == 3:
        weighDay = 'Wednesday'
    elif settings.WEIGHINDAY == 4:
        weighDay = 'Thursday'
    elif settings.WEIGHINDAY == 5:
        weighDay = 'Friday'
    elif settings.WEIGHINDAY == 6:
        weighDay = 'Saturday'

    checkMe = Weights.query.filter_by(email=current_user.email, weekof=datetime.now().strftime('%Y-%m-%d'))
    logging.debug(checkMe)
    today = datetime.now().strftime('%A')

    return render_template('User/profile.html', ww=ww, fixdate=fixdate, today=today, weighday=weighday, needsEntry=True)

def fixDate(thisDate):
    thisWeek = thisDate.strftime('%Y')+ '-' + thisDate.strftime('%m') + '-' + thisDate.strftime('%d')
    return thisWeek
