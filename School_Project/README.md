# Database Management System for Apartment Rentals

This project implements a database management system for managing apartment rentals. It includes user management, apartment details, lease agreements, payments, maintenance requests, and notifications.

---

## Features

- **User Management**: Add, retrieve, and delete users including tenants, managers, and landlords.  
- **Apartment Management**: Add, retrieve, and delete apartments linked to their owners.  
- **Unit Management**: Manage individual rental units within apartments.  
- **Lease Management**: Track leases associated with tenants and their respective units.  
- **Payment Tracking**: Record and manage payments made by tenants.  
- **Debt Management**: Monitor outstanding debts for each tenant.  
- **Maintenance Requests**: Submit and track maintenance issues reported by tenants.  
- **Expense Tracking**: Record expenses related to apartment maintenance.  
- **Notifications**: Manage messages sent to users regarding important updates.  

---

## Database Schema

The database consists of the following tables:

- `users`: Stores user information (`id`, `username`, `email`, `password_hash`, `role`)  
- `apartments`: Stores apartment details (`id`, `name`, `address`, `owner_id`)  
- `units`: Stores unit information (`id`, `apartment_id`, `unit_number`, `rent`, `status`)  
- `leases`: Stores lease agreements (`id`, `unit_id`, `tenant_id`, `start_date`, `end_date`)  
- `payments`: Records payment transactions (`id`, `tenant_id`, `lease_id`, `amount`, `method`)  
- `debts`: Tracks outstanding debts (`id`, `tenant_id`, `lease_id`, `amount`, `due_date`)  
- `maintenance_requests`: Manages maintenance issues (`id`, `tenant_id`, `apartment_id`, `description`, `status`)  
- `expenses`: Logs expenses related to apartments (`id`, `apartment_id`, `description`, `amount`)  
- `notifications`: Stores messages sent to users (`id`, `user_id`, `message`, `status`)  

---

## Installation

### Clone the Repository:

```bash
git clone https://github.com/yourusername/project.git
cd project


Set Up the Database:
Create a new database in MySQL:

Use the provided SQL script to create the tables and insert sample data.

Install Required Packages:
Make sure you have Python and the necessary packages installed. You can install them using pip:

pip install mysql-connector-python tabulate


Usage
Run the main script to interact with the database:

python main.py

You will be presented with a menu to choose various operations such as inserting, retrieving, or deleting users and apartments.

Contributing
Feel free to contribute by submitting issues or pull requests.

License
This project is for educational purposes only. It is not licensed for commercial use


---

You can copy and save this as `README.md` in your project root. GitHub will automatically render it nicely.

Would you like me to generate a downloadable `.md` file for this?
