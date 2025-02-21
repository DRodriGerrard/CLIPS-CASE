from flask import Flask, jsonify, render_template, request, send_file, redirect, url_for

app = Flask(__name__)

@app.route('/')
def home():
    return render_template({"UML.html"})

if __name__ == '__main__':
    app.run(debug=True)