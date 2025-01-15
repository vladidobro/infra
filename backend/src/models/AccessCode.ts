// ~/Dev/WDNG.IO/backend/src/models/AccessCode.ts
import { Schema, model } from 'mongoose';

// TypeScript interface
interface IAccessCode {
  code: string;      // The actual access code, e.g. "abc-123"
  category: string;  // e.g. "guest", "guest_with_plusone", "family", etc.
  used: boolean;     // True if the code has been used/registered
  name?: string;     // Optional: The name of the guest who used the code
  email?: string;    // Optional: The email of the guest who used the code
  companion?: number; // Optional: The number of companions the guest is bringing
}

// Mongoose Schema
const AccessCodeSchema = new Schema<IAccessCode>({
  code: { type: String, required: true },
  category: { type: String, default: 'guest' },
  used: { type: Boolean, default: false },
  name: { type: String },
  email: { type: String },
  companion: { type: Number, default: 0 },

});

// Export the Mongoose Model
// First argument: The collection name will be "accesscodes" in MongoDB
// Second argument: The schema
export default model<IAccessCode>('AccessCode', AccessCodeSchema);
