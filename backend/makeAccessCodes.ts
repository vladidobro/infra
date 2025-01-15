// ~/Dev/WDNG.IO/backend/src/seedAccessCodes.ts

import mongoose from 'mongoose';
import dotenv from 'dotenv';
import { v4 as uuidv4 } from 'uuid';

// Import your AccessCode model
import AccessCode from './src/models/AccessCode';

dotenv.config();

const mongoURI = process.env.MONGO_URI || 'mongodb://localhost:27017/wedding';

// Array of categories you want to seed
const categories = ['guest_no_plusone', 'guest_with_plusone', 'family'];

// Decide how many codes to generate per category
const NUM_CODES_PER_CATEGORY = 3;

async function seedDatabase() {
  try {
    // 1. Connect to MongoDB
    await mongoose.connect(mongoURI);
    console.log('Connected to MongoDB');

    // 2. Generate and insert codes
    for (const category of categories) {
      for (let i = 0; i < NUM_CODES_PER_CATEGORY; i++) {
        const code = uuidv4(); 
        await AccessCode.create({ code, category, used: false });
        console.log(`Inserted code: ${code} for category: ${category}`);
      }
    }
    console.log('Seeding completed successfully.');
  } catch (err) {
    console.error('Error during seeding:', err);
  } finally {
    // 3. Close the DB connection
    await mongoose.connection.close();
    console.log('DB connection closed.');
  }
}

// Run the seeding script
seedDatabase();