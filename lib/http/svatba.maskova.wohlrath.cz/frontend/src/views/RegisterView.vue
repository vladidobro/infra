<template>
  <div class="register-page">
    <h1>{{ t('register.title') }}</h1>
    <form @submit.prevent="submitForm">
      <!-- Acceptance Question: always visible -->
      <div class="form-group">
        <p>{{ t('register.acceptQuestion') }}</p>
        <label>
          <input type="radio" v-model="accepted" value="accept" @change="markChanged" />
          {{ t('register.accept') }}
        </label>
        <label>
          <input type="radio" v-model="accepted" value="refuse" @change="markChanged" />
          {{ t('register.refuse') }}
        </label>
      </div>

      <!-- Extra details: visible only when accepted -->
      <div v-if="accepted === 'accept'">
        <div class="form-row">
          <!-- Email -->
          <div class="form-group">
            <label for="email">{{ t('register.email') }}</label>
            <input type="email" v-model="email" id="email" required @input="markChanged" />
          </div>
        </div>

        <div class="form-row">
          <!-- Phone Number (Optional) -->
          <div class="form-group">
            <label for="phone">{{ t('register.phone') }}</label>
            <input type="text" v-model="phoneNumber" id="phone" @input="markChanged" />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="mainGuestName">{{ t('register.name') }}</label>
            <input type="text" v-model="mainGuestName" id="mainGuestName" required @input="markChanged" />
          </div>
        </div>
        <!-- New Main Guest Attendance and Accomodation -->
        <div class="form-row">
          <div class="form-group">
            <p>{{ t('register.attendance_days') }}</p>
            <label>
              <input type="checkbox" value="day_13" v-model="mainGuestAttendanceDays" @change="markChanged" />
              {{ t('register.day_13') }}
            </label>
            <label>
              <input type="checkbox" value="day_14" v-model="mainGuestAttendanceDays" @change="markChanged" />
              {{ t('register.day_14') }}
            </label>
            <label>
            <input type="checkbox" value="day_15" v-model="mainGuestAttendanceDays" @change="markChanged" />
              {{ t('register.day_15') }}
            </label>
          </div>
          <div class="form-group">
            <label for="mainGuestAccomodation">{{ t('register.accomodation') }}</label>
            <select v-model="mainGuestAccomodation" id="mainGuestAccomodation" @change="markChanged">
              <option v-for="option in accommodationOptions" :key="option" :value="option">
                {{ t(`register.${option}`) }}
              </option>
            </select>
          </div>
        </div>
        <!-- Time of Arrival for Main Guest -->
        <div class="form-group">
          <label for="mainGuestArrivalTime">{{ t('register.arrival_time') }}</label>
          <input type="time" v-model="mainGuestArrivalTime" id="mainGuestArrivalTime" @change="markChanged" />
        </div>
        <!-- New Main Guest Transportation -->
        <div class="form-group">
          <label for="mainGuestTransportation">{{ t('register.transportation') }}</label>
          <select v-model="mainGuestTransportation" id="mainGuestTransportation" @change="markChanged">
            <option v-for="option in transportationOptions" :key="option" :value="option">
              {{ t(`register.${option}`) }}
            </option>
          </select>
        </div>

        <!-- Additional Guests -->
        <div class="form-group additional-guests">
          <h3>{{ t('register.additional_guests') }}</h3>
          <div v-for="(guest, index) in guestsList" :key="index" class="guest-item">
            <div class="guest-box">
              <div class="form-row">
                <div class="form-group">
                  <label>{{ t('register.name') }}</label>
                  <input type="text" v-model="guest.name" placeholder="Guest name" @input="markChanged" />
                </div>
                <div class="form-group">
                  <label>{{ t('register.is_child') }}</label>
                  <input type="checkbox" v-model="guest.is_child" @change="markChanged" />
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <p>{{ t('register.attendance_days') }}</p>
                  <label>
                    <input type="checkbox" value="day_13" v-model="guest.attendance_days" @change="markChanged" />
                    {{ t('register.day_13') }}
                  </label>
                  <label>
                    <input type="checkbox" value="day_14" v-model="guest.attendance_days" @change="markChanged" />
                    {{ t('register.day_14') }}
                  </label>
                  <label>
                    <input type="checkbox" value="day_15" v-model="guest.attendance_days" @change="markChanged" />
                    {{ t('register.day_15') }}
                  </label>
                </div>
                <div class="form-group">
                  <label>{{ t('register.accomodation') }}</label>
                  <select v-model="guest.accomodation_type" @change="markChanged">
                    <option v-for="option in accommodationOptions" :key="option" :value="option">
                      {{ t(`register.${option}`) }}
                    </option>
                  </select>
                </div>
              </div>
              <button type="button" class="remove-btn" @click="removeGuest(index)">✖</button>
            </div>
          </div>
          <button v-if="guestsList.length < maxGuests" type="button" class="add-btn" @click="addGuest">➕ {{ t('register.additional_guests') }}</button>
        </div>
      </div>

      <!-- Error / Success Messages -->
      <div v-if="error" class="error">{{ error }}</div>
      <div v-if="success" class="success">{{ success }}</div>

      <!-- Submit button: text and disabled state based on state -->
      <button type="submit" class="submit-btn" :disabled="!formChanged">{{ submitButtonText }}</button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { useAuthStore } from '../stores/auth'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const authStore = useAuthStore()

// Reactive form data
const accepted = ref('')
const email = ref('')
const phoneNumber = ref('')
const mainGuestName = ref('')
const mainGuestIsChild = ref(false)
const mainGuestNote = ref('')
// New reactive variable for assumed arrival time (HH:MM)
const mainGuestArrivalTime = ref('')

// New reactive variables for main guest per-person fields:
const mainGuestAccomodation = ref('camping')
const mainGuestAttendanceDays = ref<string[]>([])
// New reactive variable for main guest transportation
const mainGuestTransportation = ref('no_car')
const transportationOptions = ref<string[]>([]); // Remove hardcoded transportationOptions declaration
// Update guestsList with new fields:
const guestsList = ref<Array<{ 
  name: string; 
  is_child: boolean; 
  note: string; 
  accomodation_type: string;
  attendance_days: string[]
}>>([])

const isEditing = ref(false)
const formChanged = ref(false)

const error = ref<string | null>(null)
const success = ref<string | null>(null)
const accommodationOptions = ref<string[]>([]) // removed hardcoded array
const maxGuests = ref<number>(0)

// Helper to mark the form as changed.
function markChanged() {
  formChanged.value = true
}

// Override addGuest and removeGuest as needed.
function addGuest() {
  guestsList.value.push({ 
    name: '', 
    is_child: false, 
    note: '', 
    accomodation_type: 'camping',
    attendance_days: []
  })
  markChanged()
}

function removeGuest(index: number) {
  guestsList.value.splice(index, 1)
  markChanged()
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
        accepted.value = registration.accepted ? 'accept' : 'refuse'
        isEditing.value = true
        email.value = registration.email || ''
        phoneNumber.value = registration.phone_number || ''
        // Load main guest fields if available:
        mainGuestName.value = registration.main_guest?.name || ''
        mainGuestIsChild.value = registration.main_guest?.is_child || false
        mainGuestNote.value = registration.main_guest?.note || ''
        mainGuestAccomodation.value = registration.main_guest?.accomodation_type || 'camping'
        mainGuestAttendanceDays.value = registration.main_guest?.attendance_days || []
        mainGuestArrivalTime.value = registration.main_guest?.arrival_time || '' // new field
        mainGuestTransportation.value = registration.main_guest?.transportation_type || 'no_car' // new field
        guestsList.value = registration.guests_list || []
      }
      maxGuests.value = response.data.obj.max_guests
      formChanged.value = false
    } else {
      error.value = 'Error fetching registration data.'
    }
  } catch (err: any) {
    error.value = err?.response?.data?.error || 'Failed to fetch registration data.'
  }
}

async function fetchAccommodationTypes() {
  const apiEndpoint = import.meta.env.VITE_API_HOST
  try {
    const response = await axios.get(`${apiEndpoint}/accommodation-types`)
    if (response.data.success) {
      accommodationOptions.value = response.data.types
      if (!mainGuestAccomodation.value && accommodationOptions.value.length > 0) {
        mainGuestAccomodation.value = accommodationOptions.value[0]
      }
    }
  } catch (err) {
    console.error('Error fetching accommodation types.')
  }
}

// New function to fetch transportation types from the API
async function fetchTransportationTypes() {
  const apiEndpoint = import.meta.env.VITE_API_HOST;
  try {
    const response = await axios.get(`${apiEndpoint}/transportation-types`);
    if (response.data.success) {
      transportationOptions.value = response.data.types;
      if (!mainGuestTransportation.value && transportationOptions.value.length > 0) {
        mainGuestTransportation.value = transportationOptions.value[0];
      }
    }
  } catch (err) {
    console.error('Error fetching transportation types.');
  }
}

const submitButtonText = computed(() => {
  return isEditing.value ? t('register.submit_edit') : t('register.submit')
})

async function submitForm() {
  const apiEndpoint = import.meta.env.VITE_API_HOST
  error.value = null
  success.value = null

  if (!authStore.code) {
    error.value = 'No code is set; please log in first.'
    return
  }

  // Convert the radio selection to a boolean.
  const acceptedBool = accepted.value === 'accept'

  try {
    const response = await axios.post(`${apiEndpoint}/register`, {
      code: authStore.code,
      accepted: acceptedBool,
      email: email.value,
      phone_number: phoneNumber.value,
      main_guest: {
        name: mainGuestName.value,
        is_child: mainGuestIsChild.value,
        note: mainGuestNote.value,
        accomodation_type: mainGuestAccomodation.value,
        attendance_days: mainGuestAttendanceDays.value,
        arrival_time: mainGuestArrivalTime.value,
        transportation_type: mainGuestTransportation.value  // new field
      },
      guests_list: guestsList.value
    })

    if (response.data.success) {
      // Set the success message depending on editing state.
      if (isEditing.value) {
        success.value = t('register.submitted_edit')
      } else {
        success.value = t('register.submitted_new')
        isEditing.value = true
      }
      // Reset change flag after submission.
      formChanged.value = false
    } else {
      error.value = 'Error updating registration.'
    }
  } catch (err: any) {
    error.value = err?.response?.data?.error || 'Registration failed.'
  }
}

onMounted(() => {
  fetchRegistrationData()
  fetchAccommodationTypes()
  fetchTransportationTypes();
})
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
  flex-direction: column;
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

.submit-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
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
