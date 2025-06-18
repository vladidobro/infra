<template>
    <div>
      <p style="text-align: left;" v-html="t('home_text')"></p>
    </div>
    <img src="../../assets/andrea-vlada.png" alt="Andrea a Vlada" style="width: 30%; border-radius: 100%;"/>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

</script>
