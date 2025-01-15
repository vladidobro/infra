<template>
    <div class="login-container">
      <h1>Enter Your Access Code</h1>
      <input v-model="accessCode" type="text" placeholder="Enter code" />
      <button @click="login">Login</button>
  
      <div v-if="error" class="error">
        {{ error }}
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue'
  import { useRouter } from 'vue-router'
  import { useAuthStore } from '../stores/auth'
  
  const router = useRouter()
  const authStore = useAuthStore()
  
  const accessCode = ref('')
  const error = ref<string | null>(null)
  
  async function login() {
    error.value = null
  
    if (!accessCode.value) {
      error.value = 'Please enter a code.'
      return
    }
  
    try {
      // Call the auth store
      await authStore.login(accessCode.value)
  
      // If successful, go to a protected page - e.g. "Home"
      router.push({ name: 'Home' })
    } catch (err: any) {
      // If login fails, show an error
      error.value = err?.message || 'Invalid code'
    }
  }
  </script>
  
  <style scoped>
  .login-container {
    max-width: 400px;
    margin: 50px auto;
    text-align: center;
  }
  .error {
    color: red;
    margin-top: 1rem;
  }
  </style>