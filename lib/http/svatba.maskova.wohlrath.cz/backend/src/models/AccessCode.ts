// ~/Dev/WDNG.IO/backend/src/models/AccessCode.ts
import { Schema, model } from 'mongoose';

// const ACCOMODATION_TYPES = ['camping', 'camping_with_someone', 'self_hosted', 'family_hosted', 'hotel', 'no_sleepover'] as const;
const ACCOMODATION_TYPES = ['camping', 'camping_with_someone', 'in_car', 'no_sleepover', 'other'] as const;

const TRANSPORTATION_TYPES = ['own_car', 'with_someones_car', 'no_car'] as const;

interface IPerson {
  name: string;
  is_child: boolean;
  note: string;
  // New per-person fields:
  attendance_days?: string[];
  accomodation_type?: string;
  arrival_time?: string;  // new field for assumed time of arrival
  transportation_type?: string;  // new field for transportation
}

interface IRegistration {
  accepted: boolean;
  email?: string;
  main_guest?: IPerson;
  phone_number?: string;
  guests_list?: IPerson[];
}

interface IAccessCode {
  code: string;         
  max_guests: number;   
  used: boolean;        
  registration?: IRegistration;
}

const PersonSchema = new Schema<IPerson>({
  name: { type: String, required: true },
  is_child: { type: Boolean, default: false },
  note: { type: String, default: '' },
  // New fields:
  attendance_days: { type: [String], default: [] },
  accomodation_type: { 
    type: String, 
    enum: ACCOMODATION_TYPES, 
    default: 'camping' 
  },
  arrival_time: { type: String, default: '' },
  transportation_type: { 
    type: String, 
    enum: TRANSPORTATION_TYPES, 
    default: 'no_car' 
  }
});

// We embed `registration` directly, but use `PersonSchema` for `main_guest` & `guests_list`.
const RegistrationSchema = new Schema<IRegistration>({
  accepted: { type: Boolean, default: false },
  email: { type: String, default: '' },
  // Removed 'required: true' to allow absence of main_guest on refusal.
  main_guest: { type: PersonSchema },
  phone_number: { type: String, default: '' },
  guests_list: { type: [PersonSchema], default: [] },
  // Removed fields: accomodation_type and attendance_days
});

const AccessCodeSchema = new Schema<IAccessCode>({
  code: { type: String, required: true, unique: true },
  max_guests: { type: Number, default: 0 },
  used: { type: Boolean, default: false },
  registration: { type: RegistrationSchema, default: undefined },
});

export default model<IAccessCode>('codes', AccessCodeSchema);
export { ACCOMODATION_TYPES, TRANSPORTATION_TYPES ,IAccessCode, IRegistration, IPerson };