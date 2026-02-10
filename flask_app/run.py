from app import app, db
from app.models import User, Image, Banned_IP


# For now, this file is only used if you run the server with
# python3 run.py

if __name__ == '__main__':
    app.run(debug=True)
    
@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User, 'Image': Image, 'Banned_IP': Banned_IP}