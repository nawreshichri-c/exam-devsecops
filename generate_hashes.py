import bcrypt

# Generate bcrypt hash for password "student123"
password = b'student123'
hash1 = bcrypt.hashpw(password, bcrypt.gensalt()).decode()

print("Generated hash for 'student123':")
print(hash1)

# Create CSV content with real hashes
csv_content = f"""nom;matricule;note;password
MOHAMED;1234;10,01;{hash1}
MAHDI;1235;11,99;{hash1}
MARWEN;1236;12,25;{hash1}
BAYREM;1237;13,5;{hash1}
ADEL;1238;14,87;{hash1}
MOEZ;1239;15;{hash1}
RIDHA;1231;16,25;{hash1}
WASSIM;1232;17,5;{hash1}
AMINE;1233;18,75;{hash1}
WALID;1230;19,25;{hash1}
"""

# Write to CSV file
with open(r'c:\CTF\data\resultats.csv', 'w', encoding='utf-8') as f:
    f.write(csv_content)

print("\nCSV file updated successfully!")
print(f"All passwords set to: student123")
