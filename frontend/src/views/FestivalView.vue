<template>
    <div class="festival">
      <h1> {{ t('festival.title') }} </h1>
      <h2> {{ t("festival.subtitle") }}</h2>

      <h2>{{ t('festival.lineup_title') }}</h2>
    <section class="lineup">

    <article class="day">
      <h3>{{ t('festival.saturday') }}</h3>
      <ul>
        <li class="slot">
          <span class="time">13:00</span>
          <span class="artist">{{ t('festival.performances.adam_capek.name') }}</span>
          <span class="genre">{{ t('festival.performances.adam_capek.genre') }}</span>
        </li>

        <li class="slot">
          <span class="time">15:00</span>
          <span class="artist">{{ t('festival.performances.karaoke_party.name') }}</span>
          <span class="genre">{{ t('festival.performances.karaoke_party.genre') }}</span>
        </li>

        <li class="slot">
          <span class="time">20:00</span>
          <span class="artist">{{ t('festival.performances.chichimeku.name') }}</span>
          <span class="genre">{{ t('festival.performances.chichimeku.genre') }}</span>
        </li>

        <li class="slot">
          <span class="time">22:00</span>
          <span class="artist">{{ t('festival.performances.stribrny_rafael.name') }}</span>
          <span class="genre">{{ t('festival.performances.stribrny_rafael.genre') }}</span>
        </li>

        <li class="slot wide">
          <span class="time">00:00</span>
          <span class="artist">{{ t('festival.performances.after_taborak.name') }}</span>
        </li>
      </ul>
    </article>

    <article class="day">
      <h3>{{ t('festival.sunday') }}</h3>
      <ul>
        <li class="slot">
          <span class="time">10:30</span>
          <span class="artist">{{ t('festival.performances.dj_jaxx.name') }}</span>
          <span class="genre">{{ t('festival.performances.dj_jaxx.genre') }}</span>
        </li>

        <li class="slot">
          <span class="time">14:00</span>
          <span class="artist">{{ t('festival.performances.gripozna_kokos.name') }}</span>
          <span class="genre">{{ t('festival.performances.gripozna_kokos.genre') }}</span>
        </li>

        <li class="slot wide">
          <span class="time">20:00</span>
          <span class="artist">{{ t('festival.performances.taborak.name') }}</span>
        </li>
      </ul>
    </article>
  </section>

  <section class="catering">
    <h2>{{ t('festival.food_drink_title') }}</h2>

    <h3>{{ t('festival.food_title') }}</h3>
    <p>{{ t('festival.food_description') }}</p>
    <p>{{ t('festival.food_additional') }}</p>

    <h3>{{ t('festival.drinks_title') }}</h3>
    <p>{{ t('festival.drinks_description') }}</p>
    <p>{{ t('festival.coffee_available') }}</p>
  </section>


  <section class="performers">
    <h2>{{ t('festival.performers_title') }}</h2>

    <article class="performer">
      <h4>{{ t('festival.performances.adam_capek.name') }}</h4>
      <p>{{ t('festival.performances.adam_capek.description') }}</p>
    </article>

    <article class="performer">
      <h4>{{ t('festival.performances.chichimeku.name') }}</h4>
      <p>{{ t('festival.performances.chichimeku.description') }}</p>
      <div class="video-container">
        <iframe width="560" height="315" src="https://www.youtube.com/embed/KSbBFpmtkvI" title="Chichimekú video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      </div>
    </article>

    <article class="performer">
      <h4>{{ t('festival.performances.stribrny_rafael.name') }}</h4>
      <p>{{ t('festival.performances.stribrny_rafael.description') }}</p>
      <div class="video-container">
        <iframe width="560" height="315" src="https://www.youtube.com/embed/4PVS1vw89pE" title="Stříbrný Rafael video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      </div>
    </article>

    <article class="performer">
      <h4>{{ t('festival.performances.dj_jaxx.name') }}</h4>
      <p>{{ t('festival.performances.dj_jaxx.description') }}</p>
    </article>

    <article class="performer">
      <h4>{{ t('festival.performances.gripozna_kokos.name') }}</h4>
      <p>{{ t('festival.performances.gripozna_kokos.description') }}</p>
      <div class="video-container">
        <iframe width="560" height="315" src="https://www.youtube.com/embed/jJj-N9TpTio" title="Gripozna Kokos video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      </div>
    </article>

  </section>




  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

</script>

<style scoped>
.festival {
  font-family: 'Bebas Neue', sans-serif;
  text-transform: uppercase;
}

.lineup {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-bottom: 2rem;
}

.day {
  width: 100%;
}

ul{
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  margin-bottom: 2.3rem;
  padding-left: 0;
}

.slot {
  display: flex;
  flex-wrap: wrap;       
  justify-content: center;
  gap: 0.5rem;
  padding: 0.5rem;
  background-color: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
}

.wide {
  grid-column: span 1;
}

.artist {
  font-size: 1.1rem;
}

.time {
  font-size: 1.1rem;
}

.genre {
  margin-top: -0.4rem;
  flex-basis: 100%;
  color: #af0606;
  font-size: 0.9rem;
  text-align: center;
}

h2, h3, h4 {
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.catering, .performers {
  margin-top: 3rem;
}

/* Video container for responsive embeds */
.video-container {
  position: relative;
  padding-bottom: 56.25%; /* 16:9 aspect ratio */
  height: 0;
  margin: 1rem 0;
  overflow: hidden;
  max-width: 100%;
}

.video-container iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border-radius: 4px;
}

/* Add media query for mobile responsiveness */
@media (max-width: 768px) {
  .lineup {
    grid-template-columns: 1fr;
  }
}
</style>