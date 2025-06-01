# backend/app.py
from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# MongoDB connection
client = MongoClient(os.getenv('MONGODB_URI'))
db = client['formdata']
collection = db['submissions']

@app.route('/api/submit', methods=['POST'])
def submit_data():
    try:
        # Get data from form or JSON
        if request.is_json:
            data = request.get_json()
        else:
            data = request.form.to_dict()
        
        # Debug: print the data being received
        print("Received data:", data)
        
        # Validate that we have the required fields
        if not data.get('name') or not data.get('email') or not data.get('message'):
            return jsonify({'error': 'Missing required fields'}), 400
        
        # Insert data into MongoDB
        result = collection.insert_one(data)
        
        print("Inserted document with ID:", result.inserted_id)
        
        return jsonify({'success': True, 'id': str(result.inserted_id)}), 200
        
    except Exception as e:
        print("Error:", str(e))
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)