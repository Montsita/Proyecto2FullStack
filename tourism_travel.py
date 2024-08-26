from flask import Flask, jsonify, request, redirect, render_template, url_for
import mysql.connector # pip install flask mysql-connector-python

app = Flask(__name__)

db_config = {
    'user': 'root',
    'password': 'ironhack',
    'host': 'localhost',
    'database': 'tourism_travel'
} 

@app.route('/api/projects', methods=['GET'])
def get_projects():
    try: 
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor(dictionary=True)  # dictionary=True para obtener resultados como diccionarios
            cursor.execute("SELECT id, name, country, MainAttractions FROM destinations")
            destinations = cursor.fetchall()
            cursor.close()
            conn.close()
    except:
        print(f"Error al conectar a la base de datos")
    return jsonify(destinations)  # Flask convierte automáticamente el resultado a JSON

@app.route('/')
def index():
    try: 
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor()
            cursor.execute("SELECT id, name, country, MainAttractions FROM destinations")
            destinations = cursor.fetchall()
            cursor.close()
            conn.close()
            print(destinations)
            return render_template('index_tourism_travel.html', destinations=destinations)
    except:
        print(f"Error al conectar a la base de datos")
    return "Error al conectar a la base de datos"

@app.route('/add_destinations')
def add_destinations_pag():
    return render_template('add_destinations.html')
    
@app.route('/add_destination', methods=['POST'])
def add_destination():
    name = request.form['name']
    country = request.form['country']
    main_attractions = request.form['main_attractions']

    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    query = "INSERT INTO destinations (name, country, MainAttractions) VALUES (%s, %s, %s)"
    cursor.execute(query, (name, country, main_attractions))

    # Confirmar los cambios
    conn.commit()
    # Cerrar cursor y cerrar DB ¡siempre!
    cursor.close()
    conn.close()

    return redirect('/')

@app.route('/details_destination/<int:id>')
def details_destination(id):
    try:
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor()
            query = "SELECT id, name, country, MainAttractions FROM destinations WHERE id = %s"
            cursor.execute(query, (id,))
            destination = cursor.fetchone()
            cursor.close()
            conn.close()
            if destination:
                return render_template('details_destination.html', destination=destination)
            else:
                return "Destination not found"
    except:
        print(f"Error connecting to the database")
    return "Error connecting to the database"

@app.route('/update_destination/<int:id>')
def update_destinations_pag(id):
    try:
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor()
            query = "SELECT id, name, country, MainAttractions FROM destinations WHERE id = %s"
            cursor.execute(query, (id,))
            destination = cursor.fetchone()
            cursor.close()
            conn.close()
            if destination:
                return render_template('update_destination.html', destination=destination)
            else:
                return "Destination not found"
    except:
        print(f"Error connecting to the database")
    return "Error connecting to the database"

@app.route('/edit/<int:id>', methods=['POST'])
def edit_destination(id):
    name = request.form['name']
    country = request.form['country']
    main_attractions = request.form['main_attractions']

    try:
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor()
            query = "UPDATE destinations SET name = %s, country = %s, MainAttractions = %s WHERE id = %s"
            cursor.execute(query, (name, country, main_attractions, id))
            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('details_destination', id=id))
    except mysql.connector.Error as err:
        print(f"Error de MySQL: {err}")  
    except Exception as e:
        print(f"Error connecting to the database: {e}") 

    return "Error when editing destination"

@app.route('/details_destination/<int:id>/eliminar', methods=['POST'])
def destination_delete(id):
    try:
        conn = mysql.connector.connect(**db_config)
        if conn.is_connected():
            cursor = conn.cursor()
            accommodation_id_query = "SELECT DISTINCT r.AccommodationID FROM Destinations d JOIN Accommodations a ON d.Id = a.DestinationID JOIN Reservations r ON a.Id = r.AccommodationID WHERE d.Id = %s"
            cursor.execute(accommodation_id_query, (id,))
            result= cursor.fetchone()
            if result:
                accommodation_id = result[0]
                 # Elimina las filas dependientes en la tabla reservations
                delete_reservations_query = "DELETE FROM reservations WHERE id = %s"
                cursor.execute(delete_reservations_query, (accommodation_id,))

                delete_accommodations_query = "DELETE FROM accommodations WHERE id = %s"
                cursor.execute(delete_accommodations_query, (id,))

                delete_travelpackages_query = "DELETE FROM travelpackages WHERE id = %s"
                cursor.execute(delete_travelpackages_query, (id,))

                delete_destinations_query = "DELETE FROM destinations WHERE id = %s"
                cursor.execute(delete_destinations_query, (id,))

            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('index'))
    except mysql.connector.Error as err:
        print(f"Error de MySQL: {err}")  
    except Exception as e:
        print(f"Error connecting to the database: {e}")  

    return "Error when deleting destination"

if __name__ == '__main__':
    app.run(debug=True)

