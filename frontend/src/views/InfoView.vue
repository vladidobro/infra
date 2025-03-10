<template>
  <div style="text-align: left;">
    <section>
      <h2>{{ t('info.kdy.title') }}</h2>
      <p v-html="t('info.kdy.svatba')"></p>
      <h3 v-html="t('info.kdy.casovy_rozvrh.title')"></h3>
      <p v-html="t('info.kdy.casovy_rozvrh.items')"></p>
      <p v-html="t('info.kdy.festival')"></p>
      <p v-html="t('info.kdy.festival_program')"></p>
    </section>
    <section>
      <h2>{{ t('info.kde.title') }}</h2>
      <p v-html="t('info.kde.detail')"></p>
      <div> 
        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2644.01080187264!2d14.23869931572872!3d49.97422917933913!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x470bc9fd2eb9aa27%3A0x50cf7c4a14b7ef40!2sDob%C5%99%C3%ADv%20133%2C%20036%2001%20Dob%C5%99%C3%ADv!5e0!3m2!1sen!2scz!4v1698943467845!5m2!1sen!2scz" width="600" height="450" style="border:0;" loading="lazy"></iframe>
    </div>
    </section>
    <section>
      <h2>{{ t('info.ubytovani.title') }}</h2>
      <p v-html="t('info.ubytovani.detail')"></p>
    </section>
    <section>
      <h2>{{ t('info.doprava.title') }}</h2>
      <p v-html="t('info.doprava.detail')"></p>
    </section>
    <section>
      <h2>{{ t('info.obcerstveni.title') }}</h2>
      <p v-html="t('info.obcerstveni.detail')"></p>
    </section>
    <section>
      <h2>{{ t('info.co_na_sebe.title') }}</h2>
      <p v-html="t('info.co_na_sebe.detail')"></p>
    </section>
    <section>
      <h2>{{ t('info.co_s_sebou.title') }}</h2>
      <p v-html="t('info.co_s_sebou.detail')"></p>
    </section>
    <section>
      <h2>{{ t('info.kontakt.title') }}</h2>
      <p v-html="t('info.kontakt.detail')"></p>
    </section>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

</script>
