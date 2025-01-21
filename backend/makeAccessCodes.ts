// ~/Dev/WDNG.IO/backend/makeAccessCodes.ts
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import { v4 as uuidv4 } from 'uuid';
import AccessCode from './src/models/AccessCode';  // Adjust path if needed


// udelat podminku ze databaze se smaze jenom explicitne 
// s flagem --force nebo -f
dotenv.config();

const mongoURI = process.env.MONGO_URI || 'mongodb://localhost:27017/wedding';

/**
 * Example config: each item has:
 *  - max_guests: how many people allowed on this code
 *  - howMany: how many codes to generate with that max_guests
 */
const SEED_CONFIG = [
  { max_guests: 0, howMany: 3 },  // e.g. single invites
  { max_guests: 1, howMany: 5 },  // e.g. plus-one invites
  { max_guests: 999, howMany: 4 },  // e.g. family invites
];

async function seedDatabase() {
  try {
    // 1. Connect to MongoDB
    await mongoose.connect(mongoURI);
    console.log('Connected to MongoDB');

    // 2. Drop the entire "wedding" database (all collections!)
    console.log('Dropping the entire database...');
    if (mongoose.connection.db) {
      await mongoose.connection.db.dropDatabase();
    } else {
      throw new Error('Database connection is not established.');
    }
    console.log('Database dropped successfully.');

    // 3. Generate and insert AccessCode docs
    for (const { max_guests, howMany } of SEED_CONFIG) {
      for (let i = 0; i < howMany; i++) {
        const code = uuidv4();
        await AccessCode.create({ code, max_guests, used: false });
        console.log(`Inserted code: ${code} with max_guests: ${max_guests}`);
      }
    }

    console.log('Seeding completed successfully.');
  } catch (err) {
    console.error('Error during seeding:', err);
  } finally {
    // 4. Close the DB connection
    await mongoose.connection.close();
    console.log('DB connection closed.');
  }
}

// Run the seeding script
seedDatabase();