import pyotp
import csv
import os

# Path to CSV
CSV_FILE = r'c:\CTF\data\resultats.csv'

# Read existing data
rows = []
with open(CSV_FILE, mode='r', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f, delimiter=';')
    fieldnames = reader.fieldnames
    if 'totp_secret' not in fieldnames:
        fieldnames.append('totp_secret')
    
    for row in reader:
        # Generate a random base32 secret for each student
        if 'totp_secret' not in row or not row['totp_secret']:
            row['totp_secret'] = pyotp.random_base32()
        rows.append(row)

# Write back with new column
with open(CSV_FILE, mode='w', encoding='utf-8', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter=';')
    writer.writeheader()
    writer.writerows(rows)

print("TOTP secrets generated successfully!")

# Print secrets for testing
print("\nTest Credentials with TOTP:")
for row in rows:
    if row['matricule'] == '1234':
        print(f"Matricule: {row['matricule']} | Secret: {row['totp_secret']}")
        totp = pyotp.TOTP(row['totp_secret'])
        print(f"Current Code: {totp.now()}")
