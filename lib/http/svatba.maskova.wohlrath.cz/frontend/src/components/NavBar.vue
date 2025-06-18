<template>
  <nav class="navbar">
      <router-link to="/home">{{ t('navbar.home') }}</router-link>
      <!-- <router-link to="/register">{{ t('navbar.register') }}</router-link> -->
      <router-link to="/info">{{ t('navbar.instruction') }}</router-link>
      <router-link to="/festival">{{ t('navbar.festival') }}</router-link>
  </nav>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
// i18n
const { t } = useI18n()

</script>

<style>
.navbar {
    display: flex;
    flex-direction: row;
    gap: 1rem; /* optional spacing */
}
@media (max-width: 600px) {
    .navbar {
        flex-direction: column;
    }
}
</style>
