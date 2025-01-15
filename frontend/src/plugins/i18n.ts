// src/plugins/i18n.ts
import { createI18n } from 'vue-i18n'

const messages = {
  en: {
    enter_code: 'Enter your access code',
    navbar: {
      home: 'Home',
      register: 'Register',
      instruction: 'Instruction',
      login: 'Login',
      logout: 'Logout',
      codeBracket: '[{code}]' // if you want to embed code in some template
    },
    welcome: 'Welcome to Our Wedding App!',
    register: {
      title: 'Register Form',
      name: 'Name',
      email: 'Email',
      companion: 'Number of companions',
      submit: 'Register'
    },
  },
  cs: {
    enter_code: 'Zadejte svůj přístupový kód',
    navbar: {
      home: 'Domů',
      register: 'Registrace',
      instruction: 'Pokyny',
      login: 'Přihlásit',
      logout: 'Odhlásit',
      codeBracket: '[{code}]'
    },
    welcome: 'Vítejte v naší svatební aplikaci!',
    register: {
      title: 'Registrační formulář',
      name: 'Jméno',
      email: 'Email',
      companion: 'Počet dalších hostů',
      submit: 'Registrovat'
    },
  }
}

function detectBrowserLocale(): string {
  // Typically returns something like "en-US" or "cs-CZ"
  const lang = navigator.language || navigator.languages?.[0] || 'en'
  // We only care about "en" or "cs"
  if (lang.toLowerCase().startsWith('cs')) {
    return 'cs'
  }
  return 'en'
}

const i18n = createI18n({
  legacy: false, // Using Composition API mode
  globalInjection: true,
  locale: detectBrowserLocale(), // auto-detect user’s language
  fallbackLocale: 'en',
  messages
})

export default i18n