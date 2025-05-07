import mysql.connector
from tabulate import tabulate

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="@Mmuuo2015",
    database="PROJECT"
)

cursor = db.cursor()

def display_options():
    print("\nChoose an operation:")
    print("1. Insert User")
    print("2. Retrieve Users")
    print("3. Insert Apartment")
    print("4. Retrieve Apartments")
    print("5. Delete User")
    print("6. Delete Apartment")
    print("7. Exit")

def insert_user():
    username = input("Enter username: ")
    email = input("Enter email: ")
    password_hash = input("Enter password hash: ")
    role = input("Enter role (Tenant/Manager/Landlord): ")

    cursor.execute(
        "INSERT INTO users (username, email, password_hash, role) VALUES (%s, %s, %s, %s)",
        (username, email, password_hash, role)
    )
    db.commit()
    print("✅ User inserted successfully.")

def retrieve_users():
    cursor.execute("SELECT id, username, email, role FROM users")
    users = cursor.fetchall()
    if users:
        headers = ["ID", "Username", "Email", "Role"]
        print("\n📋 Users:")
        print(tabulate(users, headers=headers, tablefmt="grid"))
    else:
        print("No users found.")

def delete_user():
    user_id = input("Enter user ID to delete: ")
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()
    if user:
        print("User found:", user)
        confirm = input("Are you sure you want to delete this user? (yes/no): ").lower()
        if confirm == 'yes':
            cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
            db.commit()
            print("🗑️ User deleted.")
        else:
            print("Cancelled.")
    else:
        print("❌ User not found.")

def insert_apartment():
    name = input("Enter apartment name: ")
    address = input("Enter apartment address: ")
    owner_id = input("Enter owner ID: ")

    cursor.execute("SELECT id FROM users WHERE id = %s", (owner_id,))
    result = cursor.fetchone()
    if not result:
        print("❌ Error: Owner ID does not exist. Please enter a valid user ID.")
        return

    cursor.execute(
        "INSERT INTO apartments (name, address, owner_id) VALUES (%s, %s, %s)",
        (name, address, owner_id)
    )
    db.commit()
    print("✅ Apartment inserted successfully.")

def retrieve_apartments():
    cursor.execute("SELECT id, name, address, owner_id FROM apartments")
    apartments = cursor.fetchall()
    if apartments:
        headers = ["ID", "Name", "Address", "Owner ID"]
        print("\n🏢 Apartments:")
        print(tabulate(apartments, headers=headers, tablefmt="grid"))
    else:
        print("No apartments found.")

def delete_apartment():
    apt_id = input("Enter apartment ID to delete: ")
    cursor.execute("SELECT * FROM apartments WHERE id = %s", (apt_id,))
    apt = cursor.fetchone()
    if apt:
        print("Apartment found:", apt)
        confirm = input("Are you sure you want to delete this apartment? (yes/no): ").lower()
        if confirm == 'yes':
            cursor.execute("DELETE FROM apartments WHERE id = %s", (apt_id,))
            db.commit()
            print("🗑️ Apartment deleted.")
        else:
            print("Cancelled.")
    else:
        print("❌ Apartment not found.")

def main():
    while True:
        display_options()
        choice = input("Enter your choice: ")

        if choice == '1':
            insert_user()
        elif choice == '2':
            retrieve_users()
        elif choice == '3':
            insert_apartment()
        elif choice == '4':
            retrieve_apartments()
        elif choice == '5':
            delete_user()
        elif choice == '6':
            delete_apartment()
        elif choice == '7':
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

    cursor.close()
    db.close()

if __name__ == "__main__":
    main()
