<template>
    <div>
      <h1>Welcome Home!</h1>
      <button @click="logoutUser">Logout</button>
    </div>
  </template>
  
  <script setup lang="ts">
  import { useAuthStore } from '../stores/auth'
  import { useRouter } from 'vue-router'
  
  const router = useRouter()
  const authStore = useAuthStore()
  
  function logoutUser() {
    authStore.logout()
    router.push({ name: 'Login' })
  }
  </script>