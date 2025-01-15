<template>
  <!-- Always show the NavBar -->
  <NavBar />

  <!-- Where your views (pages) render -->
  <router-view />
</template>

<script setup lang="ts">
import NavBar from './components/NavBar.vue'
</script>

<style>
/* Global or app-wide styles can go here if needed */
</style>