import pyotp
import csv
import sys

CSV_FILE = r'c:\CTF\data\resultats.csv'

def get_all_students():
    students = []
    try:
        with open(CSV_FILE, mode='r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f, delimiter=';')
            for row in reader:
                students.append(row)
    except FileNotFoundError:
        print(f"Error: Data file not found at {CSV_FILE}")
    return students

def generate_code(matricule, students):
    for student in students:
        if student['matricule'] == matricule:
            if 'totp_secret' in student and student['totp_secret']:
                totp = pyotp.TOTP(student['totp_secret'])
                print(f"\n>>> Code for {student['nom']} ({matricule}): {totp.now()} <<<")
                return True
            else:
                print(f"Error: No TOTP secret found for {matricule}")
                return False
    print(f"Error: Student with matricule {matricule} not found.")
    return False

def main():
    students = get_all_students()
    if not students:
        return

    # If argument provided, use it
    if len(sys.argv) > 1:
        generate_code(sys.argv[1], students)
        return

    # Otherwise, interactive mode
    print("\nAvailable Students:")
    print("-" * 30)
    print(f"{'Matricule':<10} | {'Name'}")
    print("-" * 30)
    for s in students:
        print(f"{s['matricule']:<10} | {s['nom']}")
    print("-" * 30)
    
    while True:
        choice = input("\nEnter Matricule (or 'q' to quit): ").strip()
        if choice.lower() == 'q':
            break
        generate_code(choice, students)

if __name__ == "__main__":
    main()
