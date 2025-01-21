import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import cors from 'cors';

import accessCodeRouter from './accessCodeCheck';
import registerGuest from './registerGuest';

const app = express();
const address = process.env.ADDRESS;
const port = process.env.PORT ? parseInt(process.env.PORT) : undefined
const mongoURI = process.env.MONGO_URI;

if (!address) {
  console.error('No address specified');
  process.exit(1);
}

if (!port) {
  console.error('No port specified');
  process.exit(1);
}

if (!mongoURI) {
  console.error('No MongoDB URI specified');
  process.exit(1);
}

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(mongoURI)
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((err) => {
    console.error('Could not connect to MongoDB', err);
    process.exit(1);
  });

// Test route
app.get('/', (req: Request, res: Response) => {
  res.send('Hello from Wedding App Backend!');
});

// Verify code route
app.get('/verify/:code', accessCodeRouter);

// Register guest route
app.post('/register', registerGuest);

// Start server
app.listen(port, address, () => {
  console.log(`Server running at ${address}:${port}`);
});