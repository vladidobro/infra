<template>
  <TopBar />
  <img class="wedding-logo" src="../assets/pie-placeholder.jpg" alt="Wedding logo"/>
  <NavBar />

  <!-- Where your views (pages) render -->
  <router-view />
</template>

<script setup lang="ts">
import NavBar from './components/NavBar.vue'
import TopBar from './components/TopBar.vue'
</script>

<style>
/* Import styles from the global stylesheet */
@import './style.css';

</style>