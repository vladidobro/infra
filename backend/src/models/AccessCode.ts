// ~/Dev/WDNG.IO/backend/src/models/AccessCode.ts
import { Schema, model } from 'mongoose';

const ACCOMODATION_TYPES = ['camping', 'camping_with_someone', 'self_hosted', 'family_hosted', 'hotel'] as const;

interface IPerson {
  name: string;
  is_child: boolean;
  note: string;
}

interface IRegistration {
  accepted: boolean;
  email: string;
  main_guest: IPerson;
  accomodation_type: string; // We'll store it as a string matching ACCOMODATION_TYPES
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
});

// We embed `registration` directly, but use `PersonSchema` for `main_guest` & `guests_list`.
const RegistrationSchema = new Schema<IRegistration>({
  accepted: { type: Boolean, default: false },
  email: { type: String, default: '' },
  main_guest: { type: PersonSchema, required: true },
  accomodation_type: {
    type: String,
    enum: ACCOMODATION_TYPES,
    default: 'camping',
  },
  phone_number: { type: String, default: '' },
  guests_list: { type: [PersonSchema], default: [] },
});

const AccessCodeSchema = new Schema<IAccessCode>({
  code: { type: String, required: true, unique: true },
  max_guests: { type: Number, default: 0 },
  used: { type: Boolean, default: false },
  registration: { type: RegistrationSchema, default: undefined },
});

export default model<IAccessCode>('codes', AccessCodeSchema);
export { ACCOMODATION_TYPES, IAccessCode, IRegistration, IPerson };