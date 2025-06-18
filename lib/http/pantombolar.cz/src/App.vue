<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>
    <div class="wrapper">
      <nav>
        <ul>
          <li><RouterLink to="/">Domů</RouterLink></li>
          <li><RouterLink to="/pricing">Ceník</RouterLink></li>
          <li><RouterLink to="/contact">Kontakt</RouterLink></li>
          <li><RouterLink to="/faq">Časté dotazy</RouterLink></li>
        </ul>
      </nav>
    </div>
  </header>

  <main>
    <RouterView />
  </main>
</template>
