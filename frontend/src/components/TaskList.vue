<template>
  <div>
    <h2>Task List</h2>
    <ul>
      <li v-for="task in tasks" :key="task.id">
        {{ task.title }}
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from "vue";
import { useStore } from "vuex";

export default defineComponent({
  name: "TaskList",
  setup() {
    const store = useStore();
    const tasks = computed(() => store.state.tasks);

    store.dispatch("fetchTasks");

    return { tasks };
  },
});
</script>
