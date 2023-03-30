<template>
  <div>
    <h2>Task List</h2>
    <form @submit.prevent="createTask">
      <input v-model="newTaskTitle" placeholder="New task" />
      <button type="submit">Add Task</button>
    </form>
    <ul>
      <li v-for="task in tasks" :key="task.id">
        <input v-model="task.title" @change="updateTask(task)" />
        <input
          type="checkbox"
          v-model="task.completed"
          @change="updateTask(task)"
        />
        <button @click="deleteTask(task.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref } from "vue";
import { useStore } from "vuex";

export default defineComponent({
  name: "TaskList",
  setup() {
    const store = useStore();
    const tasks = computed(() => store.state.tasks);
    const newTaskTitle = ref("");

    store.dispatch("fetchTasks");

    const createTask = () => {
      if (newTaskTitle.value.trim()) {
        store.dispatch("createTask", { title: newTaskTitle.value });
        newTaskTitle.value = "";
      }
    };

    const updateTask = (task: {
      id: string;
      title: string;
      completed: boolean;
    }) => {
      store.dispatch("updateTask", { taskId: task.id, updatedTask: task });
    };

    const deleteTask = (taskId: string) => {
      store.dispatch("deleteTask", taskId);
    };

    return { tasks, newTaskTitle, createTask, updateTask, deleteTask };
  },
});
</script>
