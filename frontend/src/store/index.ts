import { createStore } from "vuex";
import api from "../api";

export default createStore({
  state: {
    tasks: [],
  },
  mutations: {
    setTasks(state, tasks) {
      state.tasks = tasks;
    },
  },
  actions: {
    async fetchTasks({ commit }) {
      const response = await api.getTasks();
      commit("setTasks", response.data);
    },
    async createTask({ dispatch }, task) {
      await api.createTask(task);
      dispatch("fetchTasks");
    },
    async updateTask({ dispatch }, { taskId, updatedTask }) {
      await api.updateTask(taskId, updatedTask);
      dispatch("fetchTasks");
    },
    async deleteTask({ dispatch }, taskId) {
      await api.deleteTask(taskId);
      dispatch("fetchTasks");
    },
  },
  modules: {},
});
