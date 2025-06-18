import { Router } from 'express'
import { ACCOMODATION_TYPES } from './models/AccessCode'

const router = Router()

router.get('/', (req, res) => {
  res.json({ success: true, 'types': ACCOMODATION_TYPES })
})

export default router
