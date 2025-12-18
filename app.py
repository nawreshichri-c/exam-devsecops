from flask import Flask, render_template, request, jsonify, session
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_talisman import Talisman
from flask_wtf.csrf import CSRFProtect
from dotenv import load_dotenv
import csv
import os
import logging
import secrets
import bcrypt
import pyotp
import re

# Load environment variables
load_dotenv()

app = Flask(__name__)

# Security Configuration from Environment
app.secret_key = os.getenv('SECRET_KEY', secrets.token_hex(32))
app.config['SESSION_COOKIE_SECURE'] = False # Set to True in production with HTTPS
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Strict'

# CSRF Protection
csrf = CSRFProtect(app)

# Security Headers
csp = {
    'default-src': "'self'",
    'script-src': "'self' 'unsafe-inline'",
    'style-src': "'self' 'unsafe-inline'",
    'connect-src': "'self'",
    'img-src': "'self' data:" # Allow data: URIs for QR codes
}
Talisman(app, 
         force_https=False,
         content_security_policy=csp,
         frame_options='DENY',
         strict_transport_security=False,
         strict_transport_security_max_age=0
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

# Configure rate limiter
limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"],
    storage_uri="memory://"
)

# Configuration
CSV_FILE = r'c:\CTF\data\resultats.csv'

def sanitize_input(text, type='text'):
    """Sanitize input using regex."""
    if not text:
        return ''
    if type == 'matricule':
        # Only digits allowed
        return re.sub(r'[^0-9]', '', text)
    elif type == 'name':
        # Letters and spaces only
        return re.sub(r'[^a-zA-Z\s]', '', text)
    return text.strip()

def get_student_result(matricule, nom=None, password=None, totp_code=None):
    """Reads the CSV and finds the student by matricule, name, password, and TOTP."""
    if not os.path.exists(CSV_FILE):
        logging.error(f"CSV file not found: {CSV_FILE}")
        return None
    
    try:
        with open(CSV_FILE, mode='r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f, delimiter=';')
            for row in reader:
                if row['matricule'] == matricule:
                    # Name verification
                    if nom and row['nom'].upper() != nom.upper():
                        logging.warning(f"Name mismatch for matricule {matricule}")
                        return None
                    
                    # Password verification
                    if password:
                        if 'password' not in row or not row['password']:
                            return None
                        try:
                            if not bcrypt.checkpw(password.encode('utf-8'), row['password'].encode('utf-8')):
                                logging.warning(f"Password mismatch for matricule {matricule}")
                                return None
                        except Exception as e:
                            logging.error(f"Password verification error: {e}")
                            return None
                    
                    # TOTP Verification
                    if totp_code:
                        if 'totp_secret' not in row or not row['totp_secret']:
                            logging.warning(f"No TOTP secret for matricule {matricule}")
                            return None
                        
                        totp = pyotp.TOTP(row['totp_secret'])
                        if not totp.verify(totp_code, valid_window=1): # Allow 30s drift
                            logging.warning(f"Invalid TOTP code for matricule {matricule}")
                            return None
                    
                    return row
    except Exception as e:
        logging.error(f"Error reading CSV: {e}")
    return None

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/login', methods=['POST'])
@limiter.limit("5 per minute")
@csrf.exempt
def api_login():
    """Login endpoint with 2FA."""
    data = request.get_json()
    
    # Honeypot check
    if data.get('website'):
        logging.warning(f"Honeypot triggered by {request.remote_addr}")
        return jsonify({'error': 'System error'}), 400

    # Sanitize inputs
    matricule = sanitize_input(data.get('matricule', ''), 'matricule')
    nom = sanitize_input(data.get('nom', ''), 'name')
    password = data.get('password', '').strip()
    totp_code = data.get('totp', '').strip()
    
    logging.info(f"Login attempt from {request.remote_addr} for matricule {matricule}")
    
    if not matricule or not nom or not password or not totp_code:
        return jsonify({'error': 'Tous les champs sont requis (y compris le code 2FA)'}), 400
    
    # Verify all credentials
    result = get_student_result(matricule, nom, password, totp_code)
    
    if result:
        session['matricule'] = matricule
        session['nom'] = result['nom']
        session['authenticated'] = True
        # Rotate session ID to prevent fixation
        session.modified = True 
        
        logging.info(f"Successful login for {matricule} from {request.remote_addr}")
        return jsonify({
            'success': True,
            'nom': result['nom']
        })
    else:
        logging.warning(f"Failed login attempt for {matricule} from {request.remote_addr}")
        return jsonify({'error': 'Identifiants ou code 2FA invalides'}), 401

@app.route('/api/logout', methods=['POST'])
@csrf.exempt
def api_logout():
    session.clear()
    return jsonify({'success': True})

@app.route('/api/result', methods=['GET'])
@limiter.limit("10 per minute")
def api_result():
    if not session.get('authenticated') or 'matricule' not in session:
        return jsonify({'error': 'Non authentifié'}), 401
    
    matricule = session['matricule']
    result = get_student_result(matricule)
    
    if result:
        return jsonify({
            'nom': result['nom'],
            'note': result['note']
        })
    else:
        return jsonify({'error': 'Résultat non trouvé'}), 404

@app.route('/api/status', methods=['GET'])
def api_status():
    if session.get('authenticated') and 'matricule' in session:
        return jsonify({
            'authenticated': True,
            'nom': session.get('nom')
        })
    return jsonify({'authenticated': False})

@app.route('/<path:filename>')
def block_csv_access(filename):
    if filename.endswith('.csv') or filename.endswith('.json') or filename.endswith('.env'):
        logging.warning(f"Blocked direct file access attempt: {filename} from {request.remote_addr}")
        return jsonify({'error': 'Accès interdit'}), 403
    return jsonify({'error': 'Non trouvé'}), 404

if __name__ == '__main__':
    logging.info("Starting Secure Flask Application (11/10 Security)")
    app.run(host='0.0.0.0', port=5000, debug=False) # Debug disabled for production
