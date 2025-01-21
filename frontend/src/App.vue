<template>
  <TopBar />
  <img class="wedding-logo" src="../assets/pie-placeholder.png" alt="Wedding logo"/>
  <NavBar />

  <!-- Where your views (pages) render -->
  <router-view />

  <!-- Footer -->
  <footer class="footer">
    <p>Created by <a href="https://jaros.love" target="_blank">Jaroslav Pesek</a></p>
  </footer>
</template>

<script setup lang="ts">
import NavBar from './components/NavBar.vue'
import TopBar from './components/TopBar.vue'
</script>

<style>
/* Import styles from the global stylesheet */
@import './style.css';

.footer {
  border-top: 1px solid #ccc;
  /* small font */
  font-size: 0.8em;
}

.footer a {
  color: #007bff;
  text-decoration: none;
}

.footer a:hover {
  text-decoration: underline;
}
</style>