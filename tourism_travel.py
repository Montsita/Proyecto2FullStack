from flask import Flask, request, redirect, render_template, url_for
import mysql.connector # pip install flask mysql-connector-python

app = Flask(__name__)

db_config = {
    'user': 'root',
    'password': 'ironhack',
    'host': 'localhost',
    'database': 'tourism_travel'
} 

@app.route('/')
def index():
    # 1º Generámos una hipótesis
    # 2º Experimentamos para validarla
    # 3º Si el experimento sale mal vamos al paso 1, si sale bien vamos al 4
    # 4º Aprendemos del error.
    
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

@app.route('/update_destination')
def update_destinations_pag():
    return render_template('update_destination.html')

@app.route('/update_destination/<int:id>/editar', methods=['POST'])
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
        print(f"Error de MySQL: {err}")  # Punto de depuración específico
    except Exception as e:
        print(f"Error connecting to the database: {e}")  # Punto de depuración genérico

    return "Error to edit destination"


if __name__ == '__main__':
    app.run(debug=True)

