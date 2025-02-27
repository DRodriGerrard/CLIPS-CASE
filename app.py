from flask import Flask, jsonify, render_template, request, send_from_directory
from flask_cors import CORS, cross_origin
import subprocess
import os

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = 'generated'
app.config['GENERATED_FOLDER'] = 'generated'

@app.route('/')
def home():
    return render_template({"UML.html"})

# Ruta para manejar el archivo generado (diagram.xmi) y ejecutar
@app.route('/generated', methods=['POST'])
@cross_origin()
def process_diagram():
    try:
        # Guardar el archivo subido
        if 'xmi' in request.files:
            file = request.files['xmi']
            diagram_path = os.path.join(app.config['UPLOAD_FOLDER'], 'diagram.xmi')
            file.save(diagram_path)
            app.logger.info(f'Archivo guardado en: {diagram_path}')

        # Verificar si el archivo existe
        if not os.path.exists(diagram_path):
            return jsonify({'error': 'Archivo diagram.xmi no encontrado'}), 400

        # Confirmar éxito
        return jsonify({'message': 'Archivo procesado correctamente'}), 200

    except Exception as e:
        return jsonify({'error': f'Error inesperado: {e}'}), 500

@app.route('/mostrar_clp', methods=['GET'])
@cross_origin()
def mostrar_clp():
    try:
        # Ejecutar Traductor.py y capturar la salida
        result = subprocess.run(['python', 'Traductor.py'], capture_output=True, text=True)
        if result.returncode != 0:
            app.logger.error(f'Error al ejecutar Traductor.py: {result.stderr}')
            return jsonify({'error': f'Error al ejecutar Traductor.py: {result.stderr}'}), 500

        # Devolver la salida generada por Traductor.py
        return jsonify({'output': result.stdout}), 200

    except Exception as e:
        app.logger.error(f'Error al leer el archivo de código Java: {e}')
        return jsonify({'error': f'Error al leer el archivo de código Java: {e}'}), 500

# Ruta para servir el archivo generado
@app.route('/generated/<path:filename>')
@cross_origin()
def download_file(filename):
    return send_from_directory(app.config['GENERATED_FOLDER'], filename)

if __name__ == '__main__':
    app.run(debug=True)