// src/plugins/i18n.ts
import { createI18n } from 'vue-i18n'

// DRY translations: [czech, english]
const translations = {
  login_failed: ['Přihlášení selhalo. Zkuste to znovu.', 'Login failed. Please try again.'],
  enter_code: ['Zadejte svůj přístupový kód', 'Enter your access code'],
  navbar: {
    home: ['Domů', 'Home'],
    register: ['Registrace', 'Register'],
    instruction: ['Informace', 'Instruction'],
    login: ['Přihlásit', 'Login'],
    logout: ['Odhlásit', 'Logout'],
    festival: ['Festival', 'Festival'],
    codeBracket: ['[{code}]', '[{code}]']
  },
  welcome: ['Vítejte v naší svatební aplikaci!', 'Welcome to Our Wedding App!'],
  register: {
    title: ['Registrační formulář', 'Register Form'],
    name: ['Jméno', 'Name'],
    email: ['Email', 'Email'],
    submit: ['Registrovat', 'Register'],
    phone: ['Telefonní číslo', 'Phone Number'],
    accomodation: ['Typ ubytování', 'Accomodation Type'],
    hotel: ['Hotel', 'Hotel'],
    camping: ['Ve stanu', 'Camping'],
    self_hosted: ['Zařídím si ubytování sám', 'Self Hosted'],
    family_hosted: ['U rodiny', 'Family'],
    accept: ['Přijímám pozvánku', 'I accept the invitation'],
    note: ['Poznámka', 'Note'],
    additional_guests: ['Další hosté', 'Additional Guests'],
    is_child: ['Je dítě?', 'Is a child?']
  }
}

// Helper function to transform the translations object into i18n messages
function transformTranslations(obj: any): { cs: any; en: any } {
  const cs: any = {}
  const en: any = {}
  for (const key in obj) {
    if (Array.isArray(obj[key])) {
      cs[key] = obj[key][0]
      en[key] = obj[key][1]
    } else if (typeof obj[key] === 'object') {
      const nested = transformTranslations(obj[key])
      cs[key] = nested.cs
      en[key] = nested.en
    }
  }
  return { cs, en }
}

const messages = transformTranslations(translations)

function detectBrowserLocale(): string {
  const lang = navigator.language || (navigator.languages && navigator.languages[0]) || 'en'
  return lang.toLowerCase().startsWith('cs') ? 'cs' : 'en'
}

const i18n = createI18n({
  legacy: false,
  globalInjection: true,
  locale: detectBrowserLocale(),
  fallbackLocale: 'en',
  messages
})

export default i18n