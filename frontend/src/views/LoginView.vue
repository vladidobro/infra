<template>
    <div class="login-container">
      <h1>{{ t('enter_code') }}</h1>
      <input v-model="accessCode" type="text"  />
      <button @click="login">{{ t('navbar.login') }}</button>
  
      <div v-if="error" class="error">
        {{ error }}
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted } from 'vue'
  import { useRouter, useRoute } from 'vue-router'
  import { useAuthStore } from '../stores/auth'
  import { useI18n } from 'vue-i18n'

  const { t } = useI18n()
  
  const router = useRouter()
  const route = useRoute()
  const authStore = useAuthStore()
  
  const accessCode = ref('')
  const error = ref<string | null>(null)
  
  // Auto-login if URL has "code" parameter
  onMounted(() => {
    if (route.query.hostkod) {
      accessCode.value = route.query.hostkod as string
      login()
    }
  })

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
      error.value = t('login_failed')
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