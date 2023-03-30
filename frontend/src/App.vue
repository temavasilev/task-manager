<template>
  <div id="app">
    <TaskList />
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import TaskList from "./components/TaskList.vue";

export default defineComponent({
  name: "App",
  components: {
    TaskList,
  },
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
