from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
Config.init_app(app)


@app.context_processor
def inject_template_urls():
    return {
        'secret_society_url': app.config.get('SECRET_SOCIETY_URL')
    }

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = 'login'
    
from . import views