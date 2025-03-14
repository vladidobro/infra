<template>
    <div class="festival">
      <h1> {{ t('festival.title') }} </h1>
      <h2 style="margin-top: -1.2em;" > {{ t("festival.subtitle") }}</h2>
      <p> 14. - 15. 6. 2025 </p>
      <p> {{ t("festival.lineup") }} </p> 
      <p>
        {{ t("festival.detail") }}
      </p>
      <p> {{ t("festival.teaser") }} </p> 
    </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

</script>
