from . import db, login_manager
from flask_login import UserMixin
from datetime import datetime

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

likes = db.Table(
    "likes",
    db.Column('image_id', db.Integer, db.ForeignKey('images.id')),
    db.Column('user_id', db.Integer, db.ForeignKey('users.id'))
)

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    images = db.relationship('Image', backref='author', lazy=True)


class Image(db.Model):
    __tablename__ = 'images'
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    bird_name = db.Column(db.String(100), nullable=False)
    location = db.Column(db.Text, nullable=False)
    #is_encrypted = db.Column(db.Boolean, default=False)
    password_hash = db.Column(db.String(200), nullable=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    likes = db.relationship('User', secondary=likes, backref='liked_pictures')
    
class Banned_IP(db.Model):
    __tablename__ = 'banned_ips'
    id = db.Column(db.Integer, primary_key=True)
    ip_hash = db.Column(db.String(255), unique=True, nullable=False)