<template>
  <div class="register-page">
    <h1>{{ $t('register.title') }}</h1>
    <form @submit.prevent="submitForm">
      <div class="form-row">
        <!-- RSVP Checkbox -->
        <div class="form-group checkbox-group">
          <input type="checkbox" v-model="accepted" id="accepted" />
          <label for="accepted">{{ $t('register.accept') }}</label>
        </div>

        <!-- Email -->
        <div class="form-group">
          <label for="email">{{ $t('register.email') }}</label>
          <input type="email" v-model="email" id="email" required />
        </div>
      </div>

      <div class="form-row">
        <!-- Phone Number (Optional) -->
        <div class="form-group">
          <label for="phone">{{ $t('register.phone') }}</label>
          <input type="text" v-model="phoneNumber" id="phone" />
        </div>

        <!-- Accommodation Type -->
        <div class="form-group">
          <label for="accommodationType">{{ $t('register.accomodation') }}</label>
          <select v-model="accommodationType" id="accommodationType">
            <option v-for="option in accommodationOptions" :key="option" :value="option">
              {{ $t(`register.${option}`) }}
            </option>
          </select>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="mainGuestName">{{ $t('register.name') }}</label>
          <input type="text" v-model="mainGuestName" id="mainGuestName" required />
        </div>
        <div class="form-group">
          <label for="mainGuestNote">{{ $t('register.note') }}</label>
          <input type="text" v-model="mainGuestNote" id="mainGuestNote" />
        </div>
      </div>

      <!-- Additional Guests -->
      <div class="form-group additional-guests">
        <h3>{{ $t('register.additional_guests') }}</h3>
        <div v-for="(guest, index) in guestsList" :key="index" class="guest-item">
          <div class="guest-box">
            <div class="form-group">
              <label>{{ $t('register.name') }}</label>
              <input type="text" v-model="guest.name" placeholder="Guest name" />
            </div>
            <div class="form-group">
              <label>{{ $t('register.note') }}</label>
              <input type="text" v-model="guest.note" placeholder="Note for this guest" />
            </div>
            <div class="form-group">
              <label>{{ $t('register.is_child') }}</label>
              <input type="checkbox" v-model="guest.is_child" />
            </div>
            <button type="button" class="remove-btn" @click="removeGuest(index)">✖</button>
          </div>
        </div>
        <button v-if="guestsList.length < maxGuests" type="button" class="add-btn" @click="addGuest">➕ {{ $t('register.additional_guests') }}</button>
      </div>

      <!-- Error / Success Messages -->
      <div v-if="error" class="error">{{ error }}</div>
      <div v-if="success" class="success">{{ success }}</div>

      <button type="submit" class="submit-btn">{{ $t('register.submit') }}</button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()

const accepted = ref(false)
const email = ref('')
const phoneNumber = ref('')
const accommodationType = ref('camping')
const mainGuestName = ref('')
const mainGuestIsChild = ref(false)
const mainGuestNote = ref('')
const guestsList = ref<Array<{ name: string; is_child: boolean; note: string }>>([])
const error = ref<string | null>(null)
const success = ref<string | null>(null)
const accommodationOptions = ['camping', 'self_hosted', 'family_hosted', 'hotel']
const maxGuests = ref<number>(0)

function addGuest() {
  guestsList.value.push({ name: '', is_child: false, note: '' })
}

function removeGuest(index: number) {
  guestsList.value.splice(index, 1)
}

async function fetchRegistrationData() {
  const apiEndpoint = import.meta.env.VITE_API_HOST
  if (!authStore.code) {
    error.value = 'No code is set; please log in first.'
    return
  }

  try {
    const response = await axios.get(`${apiEndpoint}/verify/${authStore.code}`)
    if (response.data.success) {
      const registration = response.data.obj.registration
      if (registration) {
        accepted.value = registration.accepted
        email.value = registration.email
        phoneNumber.value = registration.phone_number
        accommodationType.value = registration.accomodation_type
        mainGuestName.value = registration.main_guest.name
        mainGuestIsChild.value = registration.main_guest.is_child
        mainGuestNote.value = registration.main_guest.note
        guestsList.value = registration.guests_list
      }
      maxGuests.value = response.data.obj.max_guests
    } else {
      error.value = 'Error fetching registration data.'
    }
  } catch (err: any) {
    error.value = err?.response?.data?.error || 'Failed to fetch registration data.'
  }
}

async function submitForm() {
  const apiEndpoint = import.meta.env.VITE_API_HOST
  error.value = null
  success.value = null

  if (!authStore.code) {
    error.value = 'No code is set; please log in first.'
    return
  }

  try {
    const response = await axios.post(`${apiEndpoint}/register`, {
      code: authStore.code,
      accepted: accepted.value,
      email: email.value,
      accommodation_type: accommodationType.value,
      phone_number: phoneNumber.value,
      main_guest: {
        name: mainGuestName.value,
        is_child: mainGuestIsChild.value,
        note: mainGuestNote.value,
      },
      guests_list: guestsList.value,
    })

    if (response.data.success) {
      success.value = 'Registration successful!'
    } else {
      error.value = 'Error updating registration.'
    }
  } catch (err: any) {
    error.value = err?.response?.data?.error || 'Registration failed.'
  }
}

onMounted(fetchRegistrationData)
</script>

<style scoped>
.register-page {
  margin: 50px auto;
  text-align: left;
  background-color: #f9f9f996;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

form {
  display: flex;
  flex-direction: column;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group {
  flex: 1;
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: 500;
}

input[type='text'],
input[type='email'],
select {
  width: 100%;
  padding: 8px;
  margin-bottom: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.checkbox-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

input[type='checkbox'] {
  width: 30px;
  height: 30px;
}

.main-guest {
  border: 1px solid #ccc;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.additional-guests {
  border: 1px solid #ccc;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.guest-item {
  margin-bottom: 10px;
}

.guest-box {
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid #ccc;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 10px;
}

.delete-label {
  color: red;
  font-size: 0.9rem;
}

.guest-limit {
  margin-bottom: 10px;
  font-weight: bold;
}

.error {
  color: red;
  margin-bottom: 1rem;
}

.success {
  color: green;
  margin-bottom: 1rem;
}

.submit-btn {
  padding: 10px 20px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  align-self: flex-start;
}

.submit-btn:hover {
  background-color: #0056b3;
}

button[type='button'] {
  cursor: pointer;
  padding: 5px 10px;
  background-color: transparent;
  color: black;
  border: none;
  font-size: 1.2rem;
}

button[type='button'].remove-btn {
  color: red;
}

button[type='button'].add-btn {
  color: green;
  font-size: 1.5rem;
  display: block;
  margin: 0 auto;
}
</style>
