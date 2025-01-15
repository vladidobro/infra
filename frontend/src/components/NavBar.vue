<template>
    <nav class="navbar">
      <!-- Left side: links -->
      <div class="navbar-left">
        <!-- Link to Home -->
        <router-link to="/">Home</router-link>
        <router-link to="/register">Registrace</router-link>
        <router-link to="/info">Info</router-link>

      </div>
  
      <!-- Right side: show code + logout if logged in -->
      <div class="navbar-right">
        <div v-if="authStore.isLoggedIn">
          <!-- Show the user’s code in brackets -->
          <span class="user-code">[{{ authStore.code }}]</span>
          <button @click="logout" class="logout-btn">
            Logout
          </button>
        </div>
        <div v-else>
          <!-- If not logged in, maybe a link to Login page or just empty -->
          <!-- For example:
               <router-link to="/login">Login</router-link>
          -->
        </div>
      </div>
    </nav>
  </template>
  
  <script setup lang="ts">
  import { useAuthStore } from '../stores/auth'
  import { useRouter } from 'vue-router'
  
  const authStore = useAuthStore()
  const router = useRouter()
  
  function logout() {
    authStore.logout()
    // Redirect back to login (or anywhere):
    router.push({ name: 'Login' })
  }
  </script>
  
  <style scoped>
  .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f5f5f5;
    padding: 10px 20px;
    border-bottom: 1px solid #ccc;
  }
  
  /* Left side (Home link(s)) */
  .navbar-left a {
    margin-right: 16px;
    text-decoration: none;
    color: #333;
  }
  
  /* Right side (code + logout button) */
  .navbar-right {
    display: flex;
    align-items: center;
  }
  
  .user-code {
    margin-right: 10px;
    font-weight: bold;
  }
  
  .logout-btn {
    padding: 6px 10px;
    background: #e74c3c;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  .logout-btn:hover {
    background: #c0392b;
  }
  </style>