-- Patient Portal Schema (Authenticated & Patient-Scoped)
CREATE TABLE IF NOT EXISTS patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mrn VARCHAR(32) NOT NULL UNIQUE,
  full_name VARCHAR(160) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  phone VARCHAR(40) NOT NULL,
  date_of_birth DATE,
  gender VARCHAR(32),
  blood_group VARCHAR(10),
  address TEXT,
  emergency_contact_name VARCHAR(160),
  emergency_contact_phone VARCHAR(40),
  allergies TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS patient_sessions (
  token_hash VARCHAR(128) PRIMARY KEY,
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS medical_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  condition_name VARCHAR(200) NOT NULL,
  diagnosed_date DATE,
  status VARCHAR(32),
  doctor_name VARCHAR(160),
  notes TEXT
);

CREATE TABLE IF NOT EXISTS prescriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  medication_name VARCHAR(200) NOT NULL,
  dosage VARCHAR(120) NOT NULL,
  frequency VARCHAR(120),
  duration VARCHAR(120),
  prescribed_by VARCHAR(160),
  prescribed_date DATE,
  instructions TEXT
);

CREATE TABLE IF NOT EXISTS lab_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  test_name VARCHAR(200) NOT NULL,
  report_date DATE,
  status VARCHAR(32) NOT NULL,
  summary TEXT,
  ordered_by VARCHAR(160),
  file_url TEXT
);

CREATE TABLE IF NOT EXISTS radiology_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  modality VARCHAR(120) NOT NULL,
  study_name VARCHAR(200) NOT NULL,
  report_date DATE,
  radiologist VARCHAR(160),
  findings TEXT,
  file_url TEXT
);

CREATE TABLE IF NOT EXISTS billing_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  invoice_number VARCHAR(64) NOT NULL UNIQUE,
  billing_date DATE NOT NULL,
  description TEXT NOT NULL,
  amount NUMERIC(10, 2) NOT NULL,
  currency VARCHAR(8) NOT NULL DEFAULT 'USD',
  status VARCHAR(24) NOT NULL CHECK (status IN ('paid', 'pending', 'overdue'))
);
