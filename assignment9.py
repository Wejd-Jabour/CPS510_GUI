import cx_Oracle
import getpass
import random

def create_connection(username, password, hostname, port, sid):
    try:
        # Create DSN (Data Source Name)
        dsn = cx_Oracle.makedsn(hostname, port, sid=sid)
        connection = cx_Oracle.connect(username, password, dsn)
        print(f"Connected to the database: {hostname}:{port}/{sid}")
        return connection
    except cx_Oracle.DatabaseError as e:
        print(f"Database error occurred during connection: {e}")
        return None

def print_table_data(cursor, table_name):
    fetch_query = f"SELECT * FROM {table_name}"
    
    # Execute the fetch query
    cursor.execute(fetch_query)
    
    # Fetch all results (rows)
    results = cursor.fetchall()

    if results:
        # Fetch column names
        columns = [desc[0] for desc in cursor.description]
        
        print(f"List of {table_name}:")
        print(f"{columns}")  # Print column names
        
        # Print each row with its corresponding columns
        for row in results:
            print(row)
    else:
        print(f"No rows returned from {table_name}.")

def check_manager_id(cursor, managerId):
    try:
        query = "SELECT * FROM managers WHERE managerId = :managerId"
        cursor.execute(query, {'managerId': managerId})
        result = cursor.fetchone()
        return result is not None
    except cx_Oracle.DatabaseError as e:
        print(f"Error occurred while checking Manager ID: {e}")
        return False

def check_guest_id_exists(cursor, guestId):
    try:
        query = "SELECT 1 FROM guest WHERE guestId = :guestId"
        cursor.execute(query, {'guestId': guestId})
        return cursor.fetchone() is not None
    except cx_Oracle.DatabaseError as e:
        print(f"Error occurred while checking Guest ID: {e}")
        return False
        
def insert_new_guest(cursor, guest_ID, guest_name, guest_phone, guest_email):
    try:
        insert_query = """
            INSERT INTO guest (guestId, fullName, phone, email)
            VALUES (:guest_ID, :guest_name, :guest_phone, :guest_email)
        """
        cursor.execute(insert_query, {
            'guest_ID': guest_ID,
            'guest_name': guest_name,
            'guest_phone': guest_phone,
            'guest_email': guest_email
        })
        
        cursor.connection.commit()
        print("New guest added successfully.")
        
    except cx_Oracle.DatabaseError as e:
        print(f"Error occurred while inserting new guest: {e}")

def user_input(cursor):
    print("HOTEL MANAGEMENT SYSTEM")
    print("I am a: ")
    print("1. Guest")
    print("2. Manager")
    print("3. Employee")
    
    try:
        user_type = int(input("Please enter corresponding number: "))
    except ValueError:
        print("Invalid input. Please enter a valid number.")
        return  

    if user_type == 1:  # Guest
        print("1. Book a Reservation")
        print("2. View/Edit Personal Guest Details")
        print("3. View Food Menu")
        print("4. View Parking Details")
        guest_option = input("Enter: Reservation, Personal, Menu, Parking> ").lower()
        
        if guest_option == "reservation":
            guest_name = input("Enter Full Name: ")
            guest_phone = input("Enter Phone: ")
            guest_email = input("Email: ")
            unique_guestId = random.randint(100, 1000000)
            
            if check_guest_id_exists(cursor, unique_guestId):
                print(f"Guest ID {unique_guestId} already exists. Generating a new ID.")
                unique_guestId = random.randint(100, 1000000)  # Regenerate if already exists

            print(f"New Guest ID: {unique_guestId}")
            guest_ID = unique_guestId
            
            insert_new_guest(cursor, guest_ID, guest_name, guest_phone, guest_email)
            
        # Add functionality for Guest options

    elif user_type == 2:  # Manager
        manager_Id = input("Enter Manager ID: ")
        if check_manager_id(cursor, manager_Id):
            manager_password = getpass.getpass("Password: ")
            if manager_password == "123":  # Placeholder password
                print("Access granted! Welcome, Manager.")
                print("1. View/Edit Guest Details")
                print("2. View/Edit Employee Details")
                print("3. View/Edit Menu Details")
                print("4. View/Edit Room Details")
                manager_option = input("Enter: Guest, Employee, Menu, Room> ").lower()
                if manager_option == "guest":
                    print_table_data(cursor, 'guest')
                    print_table_data(cursor, 'guestStay')
                    print_table_data(cursor, 'reservation')
                    print_table_data(cursor, 'parking')
                    print_table_data(cursor, 'guestParkingStatus')
                elif manager_option == "employee":
                    print_table_data(cursor, 'employees')
                    print_table_data(cursor, 'kitchen')
                    print_table_data(cursor, 'receptionist')
                elif manager_option == "menu":
                    print_table_data(cursor, 'food')
                elif manager_option == "room":
                    print_table_data(cursor, 'room')
                    print_table_data(cursor, 'roomTypePrice')
                    print_table_data(cursor, 'roomStatus')
                    print_table_data(cursor, 'roomAvailability')
            else:
                print("Incorrect password.")
        else:
            print("Manager ID not found.")

    elif user_type == 3:  # Employee
        print("1. View/Edit Personal Employee Info")
        print("2. View/Edit Work Hours")
        option_3 = input("Enter option: ")
      
    else:
        print("Invalid option. Please enter 1, 2, or 3.")

def main(username, password, hostname, port, sid):
    connection = None  
    cursor = None
    try:
        connection = create_connection(username, password, hostname, port, sid)
        if connection is None:
            return  
        
        cursor = connection.cursor()
        
        user_input(cursor)
        
    except cx_Oracle.DatabaseError as e:
        print(f"Database error occurred: {e}")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

if __name__ == "__main__":
    username = 'mmdelacr'
    password = '01241272'
    hostname = 'oracle.cs.torontomu.ca'
    port = 1521
    sid = 'orcl'

    main(username, password, hostname, port, sid)






    













