<template>
  <nav class="navbar">
    <!-- Left side: links -->
    <div class="navbar-left">
      <router-link to="/home">{{ t('navbar.home') }}</router-link>
      <router-link to="/register">{{ t('navbar.register') }}</router-link>
      <router-link to="/instruction">{{ t('navbar.instruction') }}</router-link>
    </div>

    <!-- Right side: show code + logout if logged in, plus language switch -->
    <div class="navbar-right">
      <div v-if="authStore.isLoggedIn">
        <!-- Show the user’s code in brackets, e.g. "[abc-123]" -->
        <span class="user-code">
          {{ t('navbar.codeBracket', { code: authStore.code }) }}
        </span>
        <button @click="logout" class="logout-btn">
          {{ t('navbar.logout') }}
        </button>
      </div>
      <div v-else>
        <router-link to="/login">{{ t('navbar.login') }}</router-link>
      </div>

      <!-- Language switch buttons (or dropdown) -->
      <div class="lang-switch">
        <button
          v-for="lang in ['cs', 'en']"
          :key="lang"
          :class="{ active: currentLocale === lang }"
          @click="setLocale(lang)"
        >
          {{ lang.toUpperCase() }}
        </button>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { useAuthStore } from '../stores/auth'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { computed } from 'vue'

const authStore = useAuthStore()
const router = useRouter()

function logout() {
  authStore.logout()
  router.push({ name: 'Login' })
}

// i18n
const { t, locale } = useI18n()

// We'll track the current locale
const currentLocale = computed({
  get: () => locale.value,
  set: (val: string) => {
    locale.value = val
  }
})

// Helper to set the locale
function setLocale(lang: string) {
  currentLocale.value = lang
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

.navbar-left a {
  margin-right: 16px;
  text-decoration: none;
  color: #333;
}

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
  margin-right: 10px;
}

.logout-btn:hover {
  background: #c0392b;
}

.lang-switch {
  display: flex;
  gap: 8px;
}

.lang-switch button {
  padding: 6px 10px;
  background: #eaeaea;
  border: none;
  cursor: pointer;
  border-radius: 4px;
}

.lang-switch button.active {
  background: #007bff;
  color: #fff;
}
</style>