import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'
import i18n from './plugins/i18n'

import CountryFlag from 'vue-country-flag-next'

import { useAuthStore } from './stores/auth'

const app = createApp(App)
const pinia = createPinia()

app.component('CountryFlag', CountryFlag)

app.use(pinia)
app.use(router)
app.use(i18n)

const authStore = useAuthStore()
authStore.initFromLocalStorage()

app.mount('#app')
