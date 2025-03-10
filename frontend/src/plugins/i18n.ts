// src/plugins/i18n.ts
import { createI18n } from 'vue-i18n'

// DRY translations: [czech, english]
const translations = {
  login_failed: ['Přihlášení selhalo. Zkuste to znovu.', 'Login failed. Please try again.'],
  enter_code: ['Zadejte svůj přístupový kód', 'Enter your access code'],
  navbar: {
    home: ['Úvod', 'Intro'],
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
    submit: ['Odeslat', 'Send'],
    submit_edit: ['Odeslat změny', 'Send changes'],
    submitted_new: ['Registrační formulář byl odeslán. Těšíme se na Vás!', 'Registration form was sent. We are looking forward!'],
    submitted_edit: ['Změny byly odeslány', 'Edit was sent'],
    phone: ['Telefonní číslo', 'Phone Number'],
    accomodation: ['Typ ubytování', 'Accomodation Type'],
    hotel: ['Hotel', 'Hotel'],
    camping: ['Ve svém stanu', 'Camping (I have my own tent)'],
    self_hosted: ['Zařídím si ubytování sám', 'Self Hosted'],
    family_hosted: ['U rodiny', 'Family'],
    accept: ['Přijímám pozvánku', 'I accept the invitation'],
    refuse: ['Lituji, nemohu se zúcastnit', 'I am sorry, I cannot join'],
    acceptQuestion: ['Prosím, vyberte, zda pozvánku přijímáte', 'Please choose whether you accept the invitation'],
    note: ['Poznámka', 'Note'],
    additional_guests: ['Další hosté', 'Additional Guests'],
    is_child: ['Je dítě?', 'Is a child?'],
    attendance_days: ['Dny účasti', 'Attendance Days'],
    day_13: ['13. června', '13 June'],
    day_14: ['14. června', '14 June'],
    transportation: ['Typ dopravy', 'Transportation Type'],
    own_car: ['Vlastní auto', 'Own car'],
    with_someones_car: ['S cizím autem', "With someone's car"],
    no_car: ['Bez auta', 'No car'],
    no_sleepover: ['Bez přespání', 'No sleepover'],
    camping_with_someone: ['Ve stanu s někým', 'Camping with someone'],
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