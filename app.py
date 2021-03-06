from flask import render_template, redirect, url_for, flash, session, request
from flask_login import logout_user, current_user, login_user
from facebook_auth import FacebookSignIn
from models import *
from task import taskman

from wtforms import validators

import flask_admin
from flask_admin.contrib import sqla
from flask_admin.contrib.sqla import ModelView

@login_manager.user_loader
def load_user(id):
    return Users.query.get(int(id))


# renders a home page
@app.route('/')
def index():
    return render_template('base.html')


@app.route('/success')
def success():
    if 'async_operation_id' in session:
        async_operation_id = session['async_operation_id']
        async_operation = AsyncOperation.query.filter_by(id=async_operation_id).join(Users).first()
        user = Users.query.filter_by(id=async_operation.user_profile_id).first()
        login_user(user, True)
    return redirect(url_for('index'))


# renders a loader page
@app.route('/preloader')
def preloader():
    return render_template('preloader.html')


# renders an error page
@app.route('/error')
def error():
    return render_template('error.html')


@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/admin')
def admin():
    render_template('admin.html')


@app.route('/authorize')
def facebook_authorize():
    if not current_user.is_anonymous:
        return redirect(url_for('index'))
    oauth = FacebookSignIn()
    return oauth.authorize()


# returns status of the async operation
@app.route('/get-status')
def get_status():
    if 'async_operation_id' in session:
        async_operation_id = session['async_operation_id']
        print (async_operation_id)
        # retrieve from database the status of the stored in session async operation
        async_operation = AsyncOperation.query.filter_by(id=async_operation_id).join(AsyncOperationStatus).first()
        status = str(async_operation.status.code)
        print (async_operation.status.code)
    else:
        print ('async operation not in session')
        return redirect(url_for('error'))

    return status


@app.route('/callback')
def show_preloader_start_authentication():

    if not current_user.is_anonymous:
        return redirect(url_for('index'))

    # store in the session id of the asynchronous operation
    status_pending = AsyncOperationStatus.query.filter_by(code='pending').first()
    async_operation = AsyncOperation(async_operation_status_id=status_pending.id)
    db.session.add(async_operation)
    db.session.commit()
    # store in a session the id of asynchronous operation
    session['async_operation_id'] = str(async_operation.id)

    taskman.add_task(external_auth)

    return redirect(url_for('preloader'))


def external_auth():
    oauth = FacebookSignIn()
    facebook_id, email, first_name, last_name = oauth.callback()
    if facebook_id is None:
        flash('Authentication failed')
        # change the status of async operation for 'error'
        status_error = AsyncOperationStatus.query.filter_by(code='error').first()
#        print "external auth" + session['async_operation_id']
        async_operation = AsyncOperation.query.filter_by(id=session['async_operation_id']).first()
        print (async_operation.id)
        async_operation.async_operation_status_id = status_error.id
        db.session.add(async_operation)
        db.session.commit()
        return redirect(url_for('error'))

    # retrieve the user data from the database
    user = Users.query.filter_by(facebook_id=facebook_id).first()

    # if the user is new, we store theirs credentials in user_profile table
    if not user:
        user = Users(facebook_id=facebook_id, email=email, first_name=first_name, last_name=last_name)
        db.session.add(user)
        db.session.commit()

    # change the status of the async operation for 'ok' and insert the value of the user id
    # to the async_operation table
    status_ok = AsyncOperationStatus.query.filter_by(code='ok').first()
    async_operation = AsyncOperation.query.filter_by(id=session['async_operation_id']).first()
    async_operation.async_operation_status_id = status_ok.id
    async_operation.user_profile_id = user.id
    db.session.add(async_operation)
    db.session.commit()


if __name__ == '__main__':

    db.create_all()

    # Create admin
    admin = flask_admin.Admin(app, name='90 Day Challenge Admin', template_mode='bootstrap3')

    # Add views
    admin.add_view(ModelView(Users, db.session))

    app.run(debug=True)
