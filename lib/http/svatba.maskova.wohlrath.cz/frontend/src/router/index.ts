// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import HomeView from '../views/HomeView.vue'
import RegisterView from '../views/RegisterView.vue'
import InfoView from '../views/InfoView.vue'
import FestivalView from '../views/FestivalView.vue'

import { useAuthStore } from '../stores/auth'

const routes: Array<RouteRecordRaw> = [
    {
      path: '/',
      name: 'Login',
      component: LoginView
    },
    {
      path: '/home',
      name: 'Home',
      component: HomeView,
      meta: { requiresAuth: true }
    }, 
    {
      path: '/register',
      name: 'Register',
      component: RegisterView,
      meta: { requiresAuth: true }
    },
    {
      path: '/info',
      name: 'Info',
      component: InfoView,
      meta: { requiresAuth: true }
    },
    {
      path: '/festival',
      name: 'Festival',
      component: FestivalView
    }
  ]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

// This guard checks if a route requires auth, then checks the store
router.beforeEach((to, _) => {
  const authStore = useAuthStore()
  if (to.meta.requiresAuth && !authStore.isLoggedIn) {
    // If not logged in, go to /login
    return { name: 'Login' }
  }
})

export default router