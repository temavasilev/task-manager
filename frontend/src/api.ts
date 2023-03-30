import axios from "axios";

const apiClient = axios.create({
  baseURL: "http://localhost:5000/api",
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

export default {
  getTasks() {
    return apiClient.get("/tasks");
  },
  createTask(task: { title: string }) {
    return apiClient.post("/tasks", task);
  },
  updateTask(
    taskId: string,
    updatedTask: { title: string; completed: boolean }
  ) {
    return apiClient.put(`/tasks/${taskId}`, updatedTask);
  },
  deleteTask(taskId: string) {
    return apiClient.delete(`/tasks/${taskId}`);
  },
};
