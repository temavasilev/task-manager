from flask import Flask, jsonify, request
from flask_cors import CORS
import uuid

app = Flask(__name__)
CORS(app)

tasks = [
    {
        "id": 1,
        "title": "Sample Task",
        "completed": False
    }
]

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    return jsonify(tasks)


@app.route('/api/tasks', methods=['POST'])
def create_task():
    new_task = {
        "id": str(uuid.uuid4()),
        "title": request.json['title'],
        "completed": False
    }
    tasks.append(new_task)
    return jsonify(new_task), 201


@app.route('/api/tasks/<task_id>', methods=['PUT'])
def update_task(task_id):
    task = next((t for t in tasks if t["id"] == task_id), None)
    if task is None:
        return jsonify({"error": "Task not found"}), 404

    task.update(request.json)
    return jsonify(task)


@app.route('/api/tasks/<task_id>', methods=['DELETE'])
def delete_task(task_id):
    task = next((t for t in tasks if t["id"] == task_id), None)
    if task is None:
        return jsonify({"error": "Task not found"}), 404

    tasks.remove(task)
    return jsonify({"success": "Task deleted"}), 200


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0:5000')
