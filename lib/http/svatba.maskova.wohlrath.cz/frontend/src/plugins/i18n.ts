// src/plugins/i18n.ts
import { createI18n } from 'vue-i18n'

// DRY translations: [czech, english]
const translations = {
  login_failed: ['Přihlášení selhalo. Zkuste to znovu.', 'Login failed. Please try again.'],
  enter_code: ['Zadejte svůj přístupový kód', 'Enter your access code'],
  navbar: {
    home: ['Úvod', 'Intro'],
    register: ['Registrace', 'Register'],
    instruction: ['Další info', 'Important info'],
    login: ['Přihlásit', 'Login'],
    logout: ['Odhlásit', 'Logout'],
    festival: ['Festival', 'Festival'],
    codeBracket: ['[{code}]', '[{code}]']
  },
  welcome: ['Vítejte v naší svatební aplikaci!', 'Welcome to Our Wedding App!'],
  home_text: [
    `S velkou radostí Vás zveme na naši svatbu, která se bude konat v pátek 13. června 2025 na samotě Melmatěj uprostřed brdských lesů.
Na témže místě pak v sobotu a neděli proběhne hudební minifestival Melmatějská veselka, na nějž jste rovněž srdečně zváni.
Abychom s Vámi mohli počítat, prosíme Vás o vyplnění registračního formuláře, nejpozději do 5. dubna 2025.
<br />
<br />
Veškeré další informace o svatbě i festivalu naleznete na těchto stránkách. Doporučujeme stránky zkontrolovat ještě krátce před svatbou, kvůli případným změnám v programu.
<br />
<br /> 
Těšíme se na Vás!
<br />
Andrea a Vláďa`,

    `With great joy we invite you to our wedding, which will be held on Friday, June 13, 2025, in Melmatěj in the midst of the Brdy forests.
On the same venue, a musical mini-festival "Melmatějská Veselka" will take place on Saturday and Sunday, to which you are also warmly invited.
To let us know if you will join us, please fill out the registration form by the date of April 5, 2025.
<br />
<br />
All further information about the wedding and the festival can be found on this website. We recommend checking the website again shortly before the wedding due to possible schedule changes.
<br />
<br />
We look forward to seeing you!
<br />
Andrea and Vláďa`
  ],
  festival: {
    title: ['MELMATĚJSKÁ VESELKA', 'MELMATEJSKA VESELKA'],
    subtitle: ['HUDEBNÍ MINIFESTIVAL', 'MUSIC MINI-FESTIVAL'],
    lineup: [ 
      `Line-up bude doplněn. Stay tuned!`,
      `Line-up will be updated. Stay tuned!`
    ],
    lineup_title: ['LINE UP', 'LINE UP'],
    saturday: ['Sobota', 'Saturday'],
    sunday: ['Neděle', 'Sunday'],
    food_drink_title: ['JÍDLO A PITÍ BĚHEM FESTIVALU', 'FOOD AND DRINKS DURING THE FESTIVAL'],
    food_title: ['JÍDLO', 'FOOD'],
    food_description: [
      'Během festivalu se sní to, co zbyde ze svatby, dále bude k dispozici prostší strava jako buřty, utopence, chleba či těstoviny.',
      'During the festival, we will eat what is left from the wedding. Additionally, simpler food like sausages, pickled sausages, bread, or pasta will be available.'
    ],
    food_additional: [
      'Pokud nám jídlo nevystačí, nebojte, nemusíte s sebou tahat zásoby. Ve vzdálenosti pár kilometrů se nachází několik obchodů (Billa, potraviny) a v okrese také funguje rozvoz (pizza, čína ap.).',
      'If we run out of food, don\'t worry, you don\'t need to bring supplies. There are several stores (Billa, grocery) a few kilometers away, and food delivery (pizza, Chinese, etc.) is also available in the district.'
    ],
    drinks_title: ['PITÍ', 'DRINKS'],
    drinks_description: [
      'Pivo by nám snad mělo vystačit na celý víkend. Tvrdý a víno bude k dispozici podle toho, kolik zbyde ze svatby. Pokud máte strach, že zbytky nedokáží uspokojit vaši spotřebu, můžete s sebou přivézt vlastní zásoby nebo je během víkendu doplnit v nedalekých obchodech.',
      'Beer should hopefully last us the whole weekend. Hard liquor and wine will be available depending on how much is left from the wedding. If you\'re worried that the leftovers won\'t satisfy your consumption, you can bring your own supplies or replenish them during the weekend at nearby stores.'
    ],
    coffee_available: [
      'Káva bude k dispozici po dobu celé akce.',
      'Coffee will be available throughout the entire event.'
    ],
    performers_title: ['O ÚČINKUJÍCÍCH', 'ABOUT THE PERFORMERS'],
    performances: {
      adam_capek: {
        name: ['ADAM ČAPEK', 'ADAM CAPEK'],
        description: [
          'Adam Čapek, syn mnohem slavnějšího klavírního mistra, pedagoga, držitele pamětní medaile Vyznamenání rady města Lysé nad Labem a rodáka z Dobrušky Libora Čapka, se od dětství zabývá předválečnou klasickou hudbou. Mezi jeho oblíbené skladatele patří Sibelius, Kotzwara, Leibowitz a Glazunov, jejichž díla v sobotu neuslyšíte.',
          'Adam Capek, son of the much more famous piano master, educator, holder of the memorial medal of the Honors of the Lysá nad Labem City Council and native of Dobruška Libor Capek, has been involved in pre-war classical music since childhood. His favorite composers include Sibelius, Kotzwara, Leibowitz, and Glazunov, whose works you will not hear on Saturday.'
        ],
        genre: ['klasika k obědu', 'classical music for lunch']
      },
      karaoke_party: {
        name: ['KARAOKE PARTY', 'KARAOKE PARTY'],
        genre: ['party sing‑along', 'party sing‑along']
      },
      chichimeku: {
        name: ['CHICHIMEKÚ', 'CHICHIMEKU'],
        description: [
          'Legendární big band nestora české reggae scény Karla Babuljaka. Dred dred dredy dred dredy dredy dred, džamen fíl a makočuba singsong. To vše a mnohem víc.',
          'Legendary big band of the nestor of the Czech reggae scene, Karel Babuljak. Dread dread dreads dread dreads dreads dread, jammin\' feel and makochuba singsong. All this and much more.'
        ],
        genre: ['reggae / staré rocksteady', 'reggae / old rocksteady']
      },
      stribrny_rafael: {
        name: ['STŘÍBRNÝ RAFAEL', 'STRIBRNY RAFAEL'],
        description: [
          'Stříbrný hlas z Modřan od roku 2016 smývá hranice mezi rapem a alternativní hudbou. Grafomanské texty plné klukovin, ze kterých zároveň místy zamrazí. Multiinstrumentalista rapující do převážně vlastních produkcí, které vynikají barevností a zastoupením živých nástrojů. Nejlepší naživo s DJem Kazisvětem.',
          'The silver voice from Modřany has been washing away the boundaries between rap and alternative music since 2016. Graphomaniac lyrics full of shenanigans that sometimes give you chills. A multi-instrumentalist rapping to mostly his own productions, which excel in colorfulness and representation of live instruments. Best live with DJ Kazisvět.'
        ],
        genre: ['momentálně rap', 'currently rap']
      },
      after_taborak: {
        name: ['AFTER TÁBORÁK', 'AFTER CAMPFIRE'],
        genre: ['', '']
      },
      dj_jaxx: {
        name: ['DJ Masta JAXX', 'DJ Masta JAXX'],
        description: [
          'Když se něco má stát, tak se to stane. Tomu se říká osud. DJ Masta JAXX, známý svou podmanivou pódiovou energií a lyrickým projevem, začínal jako oceňovaný country písničkář. Zásadní proměnu svého stylu prodělal poté, co se seznámil s novými formami Tokijské klubové scény. Na jeho debutovou dýdžejskou party musela veřejnost počkat až do letošního roku, ale když se něco má stát, tak se to stane.',
          'When something is meant to happen, it happens. That\'s called destiny. DJ Masta JAXX, known for his captivating stage energy and lyrical expression, started as an acclaimed country songwriter. He underwent a fundamental transformation of his style after discovering new forms of the Tokyo club scene. The public had to wait until this year for his debut DJ party, but when something is meant to happen, it happens.'
        ],
        genre: ['Wake up tech house', 'Wake up tech house']
      },
      gripozna_kokos: {
        name: ['GRIPOZNA KOKOS', 'GRIPOZNA KOKOS'],
        description: [
          'Gripozna Kokos je česko-litevská avantgardně jazzcorová trojice, která debutovala v létě 2018 albem \'Sounds of Kokos\'. Nyní hraje ve složení Gripo (kytara, zpěv), Znak (basa) a Okos (klávesy) a Zoom.',
          'Gripozna Kokos is a Czech-Lithuanian avant-garde jazzcore trio that debuted in the summer of 2018 with the album \'Sounds of Kokos\'. They now play with Gripo (guitar, vocals), Znak (bass), and Okos (keyboards) and Zoom.'
        ],
        genre: ['avantgarde jazzcore', 'avantgarde jazzcore']
      },
      taborak: {
        name: ['TÁBORÁK PRO TY, KDO ZBYLI', 'CAMPFIRE FOR THOSE WHO REMAINED'],
        genre: ['', '']
      }
    },
    detail: [
      `
      Pokud máte zájem vystoupit s vaším hudebním, 
      tanečním nebo jiným uměleckým číslem, pište na 
      svatba{'@'}wohlrath.cz. Jakákoliv iniciativa je vítaná.
      `
      ,
      `If you are interested in performing with your own dance, 
      musical, or other artistic act, write to 
      svatba{'@'}wohlrath.cz. Any initiative is welcome.`
    ],
    teaser: [
      `Zatím se můžete těšit na esa jako Stříbrný Rafael, Gripozna Kokos nebo Chichimekú.`,
      `For now, you can look forward to such stars like Stribrny Rafael, Gripozna Kokos, or Chichimekú.`
    ]
  },
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
    refuse: ['Lituji, nemohu se zúčastnit', 'I am sorry, I cannot join'],
    acceptQuestion: ['Prosím, vyberte, zda pozvánku přijímáte', 'Please choose whether you accept the invitation'],
    note: ['Poznámka', 'Note'],
    additional_guests: ['Další hosté', 'Next Guests'],
    is_child: ['Je dítě?', 'Is it a child?'],
    attendance_days: ['Dny účasti', 'Attendance Days'],
    day_13: ['13. června (Svatba)', '13 June (Wedding)'],
    day_14: ['14. června (Festival)', '14 June (Festival)'],
    day_15: ['15. června (Festival)', '15 June (Festival)'],
    transportation: ['Typ dopravy', 'Transportation Type'],
    own_car: ['Vlastní auto', 'Own car'],
    with_someones_car: ['Autem s někým', "With someone's car"],
    no_car: ['Bez auta', 'No car'],
    no_sleepover: ['Bez přespání', 'No sleepover'],
    camping_with_someone: ['Ve stanu s někým', 'Camping with someone'],
    arrival_time: ['Čas příjezdu', 'Arrival time'],
    in_car: ['V autě', 'In a car'],
    other: ['Jinde', 'Somewhere else'],
  },
  info: {
    kdy: {
      title: [ "Kdy?", "When?" ],
      svatba: [ "Svatba: pátek, 13. 6. 2025", "Wedding: Friday, June 13, 2025" ],
      casovy_rozvrh: {
        title: [ "Harmonogram:", "Schedule:" ],
        items: [
`
<table>
<tr><td>12:30 - 13:00</td><td>příjezd na Melmatěj</td></tr>
<tr><td>13:30</td> <td>odjezd svatebními autobusy na místo obřadu</td></tr>
<tr><td>14:00 - 14:30</td><td>obřad</td></tr>
<tr><td>14:30 - 15:00</td><td>společné focení</td></tr>
<tr><td>15:00</td><td>odjezd svatebními autobusy zpět na veselku</td></tr>
<tr><td>15:30 - 16:00</td><td>příjezd novomanželů</td></tr>
<tr><td>16:00</td><td>přípitky, hostina</td></tr>
<tr><td>17:00</td><td>házení kytice</td></tr>
<tr><td>17:30</td><td>první tanec</td></tr>
<tr><td>21:30</td><td>TOMBOLA!!!!!</td></tr>
<tr><td>22:30</td><td>afterparty</td></tr>
</table>`
,
`<table>
<tr><td>12:30 - 13:00</td><td>arrival at Melmatěj</td></tr>
<tr><td>13:30</td><td>departure by wedding buses to the ceremony venue</td></tr>
<tr><td>14:00 - 14:30</td><td>ceremony</td></tr>
<tr><td>14:30 - 15:00</td><td>group photos</td></tr>
<tr><td>15:00</td><td>departure by wedding buses back to the reception</td></tr>
<tr><td>15:30 - 16:00</td><td>arrival of the newlyweds</td></tr>
<tr><td>16:00</td><td>toasts, banquet</td></tr>
<tr><td>17:00</td><td>bouquet toss</td></tr>
<tr><td>17:30</td><td>first dance</td></tr>
<tr><td>21:30</td><td>TOMBOLA!!!!!</td></tr>
<tr><td>22:30</td><td>afterparty</td></tr>
</table>`
        ]
      },
      festival: [ "festival: 14.-15. 6. 2025", "Festival: June 14-15, 2025" ],
      festival_program: [ "Program zde.", "Program here." ]
    },
    kde: {
      title: [ "Kde?", "Where?" ],
      detail: [
        `Veselka a sraz svatebčanů bude na Melmatěji v Dobřívě u Rokycan.<br /> <br />
Adresa: Dobřív 133 <br /> <br />
Obřad proběhne ve Strašicích u loveckého zámečku Tři Trubky. Na místo obřadu a zpět svatebčany přepraví svatební autobusy.
(Místo obřadu se nachází v CHKO Brdy, není proto možné přijet vlastním vozem.)`,
        `The wedding reception and gathering will be held at Melmatěj in Dobřív near Rokycany.<br /> <br />
Address: Dobřív 133 <br /> <br />
The ceremony will take place in Strašice near Tři Trubky chateau. Wedding buses will transport guests to and from the ceremony.
(The ceremony venue is located in the Brdy Protected Landscape Area, so it is not possible to arrive by car.)
`
      ]
    },
    ubytovani: {
      title: [ "Ubytování", "Accommodation" ],
      detail: [
        `My mladí budeme stanovat přímo na místě. K dispozici bude koupelna s toaletou i mobilní toalety s venkovním umyvadlem.<br />
Pokud vám spaní ve stanu nevyhovuje, dejte nám vědět  e-mailem na svatba{'@'}wohlrath.cz.<br />
Příbuzní zdaleka mají možnost ubytování v penzionu.`,
        `We will camp on-site. Facilities include a bathroom with toilet as well as mobile toilets with an outdoor sink.<br />
If sleeping in a tent doesn't suit you, please let us know via e-mail at svatba{'@'}wohlrath.cz.<br />
Relatives coming from afar have the option of staying in a guesthouse.`
      ]
    },
    doprava: {
      title: [ "Doprava", "Transport" ],
      detail: [
        "Dostanete se k nám autem nebo autobusem (zastávka Dobřív, Melmatěj).",
        "You can reach us by car or bus (Dobřív, Melmatěj stop)."
      ]
    },
    obcerstveni: {
      title: [ "Občerstvení", "Refreshments" ],
      detail: [
        `Na svatbě bude občerstvení formou rautu. Na baru najdete kávu, pivo a další alko i nealko nápoje.<br />
Hostina začne až mezi 15:00 - 16:00, ale už před odjezdem na obřad bude k dispozici drobné občerstvení, káva, koláče a nealko.`,
        `Refreshments will be served buffet-style. The bar will offer coffee, beer, and other alcoholic and non-alcoholic beverages.<br />
The banquet will start between 15:00 and 16:00, but light refreshments, coffee, cakes, and soft drinks will be available before the ceremony departure.`
      ]
    },
    co_na_sebe: {
      title: [ "Co na sebe?", "What to wear?" ],
      detail: [
`Dress code: Přijďte v oděvu, ve kterém se budete cítit příjemně. Veselka se koná z velké části na travnatém povrchu, proto nedoporučujeme vysoké podpatky.<br />
Děvčata!!!! Pokud chcete nevěstu obzvlášť potěšit, vyneste prosím na afterparty a sobotu <u>bílé šaty/sukně/whatever</u>. Opravdu to ocení a budou z toho super fotky!!!
<br />
<br />
Účastníte-li se také festivalu, vezměte si určitě i pohodlné oblečení k táboráku, pláštěnky či deštníky pro případ deště a plavky na koupání v potoce.<br />
`,
`Dress code: Come in clothes that make you feel comfortable. Since the reception will largely take place on a grassy surface, high heels are not recommended.<br />
Ladies!!!! If you want to especially delight the bride, please wear <u>white</u> dress/skirt/whatever to the afterparty and on Saturday. It will truly be appreciated and make for great photos!!!
<br />
<br />
If you are also attending the festival, be sure to bring comfortable clothing for the campfire, rain jackets or umbrellas in case of rain, and swimwear for river bathing.<br />
`
      ]
    },
    co_s_sebou: {
      title: [ "Co s sebou?", "What to bring?" ],
      detail: [
        `Budete-li spát ve stanu, nezapomeňte na klasické vybavení na kempování (spacáky atd.).<br />
Pokud hrajete na hudební nástroje, neváhejte je vzít s sebou na festival.
<br />
<br />
Chcete-li nás něčím potěšit, určitě oceníme spíš nehmotné dary. 
Samozřejmě, že tím největším darem pro nás bude vaše přítomnost.`,
        `If you’re camping, don’t forget standard camping gear (sleeping bags, etc.).<br />
If you play any musical instruments, feel free to bring them to the festival.<br />
<br />
<br />
If you wish to please us, we would prefer non-material gifts. Of course, your presence is the greatest gift of all.`
      ]
    },
    kontakt: {
      title: [ "Kontakt", "Contact" ],
      detail: [
        `V případě dotazů ohledně svatby nás můžete kontaktovat přes mail: svatba{'@'}wohlrath.cz<br />
nebo na telefonním čísle: +420 732 207 655<br />
V den obřadu volejte pouze na číslo svědka Vojtěcha Slováka: +420 773 584 412`,
        `For any questions, please contact us via e-mail: svatba{'@'}wohlrath.cz <br />
or by phone: +420 732 207 655<br />
On the day of the ceremony, please call only bridesman Vojtěch Slovák at: +420 773 584 412`
      ]
    }
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
  messages,
  warnHtmlMessage: false
})

export default i18n