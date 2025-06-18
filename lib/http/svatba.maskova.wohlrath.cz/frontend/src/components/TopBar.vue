<template>
    <div class="topbar">
      <!-- Single toggle icon for language -->
      <div class="topbar-lang-switch">
        <CountryFlag
          v-if="isCzech"
          country="gb"
          class="round-flag"
          @click="toggleLang"
          title="Switch to English"
        />
        <CountryFlag
          v-else
          country="cz"
          class="round-flag"
          @click="toggleLang"
          title="Přepnout na češtinu"
        />
      </div>
  
      <!-- Logout link if logged in -->
      <div class="topbar-logout" v-if="authStore.isLoggedIn">
        <a href="/" @click.prevent="logout" class="logout-btn">
          {{ t('navbar.logout') }}
        </a>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { computed } from 'vue'
  import { useAuthStore } from '../stores/auth'
  import { useRouter } from 'vue-router'
  import { useI18n } from 'vue-i18n'
  
  // (If globally registered) No need to import CountryFlag here,
  // but if you want local registration, do:
  // import CountryFlag from 'vue-country-flag-next'
  
  const authStore = useAuthStore()
  const router = useRouter()
  
  // Logout function
  function logout() {
    authStore.logout()
    router.push({ name: 'Login' })
  }
  
  // i18n
  const { t, locale } = useI18n()
  
  // Computed to see if current locale is Czech
  const isCzech = computed(() => locale.value === 'cs')
  
  // Single toggle function
  function toggleLang() {
    // if it's Czech -> switch to English, else switch to Czech
    locale.value = isCzech.value ? 'en' : 'cs'
  }
  </script>
  
