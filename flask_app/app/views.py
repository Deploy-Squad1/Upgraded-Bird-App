from . import app, db
from .models import User, Image
import os
from datetime import datetime
from flask import render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename

@app.route('/')
def index():
    try:
        images = Image.query.order_by(Image.created_at.desc()).all()
    except:
        images = []
    return render_template('index.html', images=images)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        if User.query.filter_by(username=username).first():
            flash('Username already exists')
            return redirect(url_for('register'))

        hashed_pw = generate_password_hash(password)
        new_user = User(username=username, password_hash=hashed_pw)
        db.session.add(new_user)
        db.session.commit()

        login_user(new_user)
        return redirect(url_for('index'))

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        user = User.query.filter_by(username=username).first()
        if user and check_password_hash(user.password_hash, password):
            login_user(user)
            return redirect(url_for('index'))
        else:
            flash('Login Unsuccessful. Please check username and password')

    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/upload', methods=['GET', 'POST'])
@login_required
def upload():
    if request.method == 'POST':
        if 'file' not in request.files:
            return redirect(request.url)

        file = request.files['file']
        bird_name = request.form.get('bird_name')
        location = request.form.get('location')

        if file.filename == '' or not bird_name or not location:
            flash('All fields are required!')
            return redirect(request.url)

        if file:
            filename = secure_filename(file.filename)
            unique_filename = f"{datetime.now().strftime('%Y%m%d%H%M%S')}_{filename}"
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], unique_filename))
            new_image = Image(filename=unique_filename, bird_name=bird_name, location=location, author=current_user)
            db.session.add(new_image)
            db.session.commit()

            return redirect(url_for('index'))

    return render_template('upload.html')



@app.route('/delete/<int:image_id>', methods=['POST'])
@login_required
def delete_image(image_id):
    image = Image.query.get_or_404(image_id)
    if image.author == current_user:
        try:
            os.remove(os.path.join(app.config['UPLOAD_FOLDER'], image.filename))
        except:
            print("File not found on disk")
        db.session.delete(image)
        db.session.commit()
    return redirect(url_for('index'))


@app.route('/like/<int:image_id>', methods=['POST'])
@login_required
def like_image(image_id):
    image = Image.query.get_or_404(image_id)
    if (image in current_user.liked_pictures):
        image.likes.remove(current_user)
        db.session.commit()
    else:
        image.likes.append(current_user)
        db.session.commit()
    return redirect(url_for('index'))

@app.route('/health')
def health_check():
    return "OK", 200
