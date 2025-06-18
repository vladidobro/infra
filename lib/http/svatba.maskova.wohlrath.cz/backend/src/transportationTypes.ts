import { Router } from 'express';
import { TRANSPORTATION_TYPES } from './models/AccessCode';

const router = Router();

router.get('/', (req, res) => {
  res.json({
    success: true,
    types: TRANSPORTATION_TYPES
  });
});

export default router;
