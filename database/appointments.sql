-- Appointments table with strict double-booking prevention
CREATE TABLE IF NOT EXISTS appointments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reference_number VARCHAR(32) NOT NULL UNIQUE,
  department VARCHAR(120) NOT NULL,
  doctor_id VARCHAR(120) NOT NULL,
  doctor_name VARCHAR(160) NOT NULL,
  appointment_date DATE NOT NULL,
  time_slot VARCHAR(32) NOT NULL,
  appointment_type VARCHAR(16) NOT NULL CHECK (appointment_type IN ('online', 'offline')),
  patient_name VARCHAR(160) NOT NULL,
  patient_phone VARCHAR(40) NOT NULL,
  patient_email VARCHAR(160) NOT NULL,
  patient_age INTEGER,
  patient_gender VARCHAR(32),
  reason TEXT,
  status VARCHAR(24) NOT NULL DEFAULT 'confirmed'
    CHECK (status IN ('pending', 'confirmed', 'rescheduled', 'cancelled', 'completed')),
  cancellation_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Prevent double booking for the same doctor, date, and time slot while active
CREATE UNIQUE INDEX IF NOT EXISTS idx_appointments_no_double_booking
  ON appointments (doctor_id, appointment_date, time_slot)
  WHERE status <> 'cancelled';

CREATE INDEX IF NOT EXISTS idx_appointments_reference
  ON appointments (reference_number);

CREATE INDEX IF NOT EXISTS idx_appointments_doctor_date
  ON appointments (doctor_id, appointment_date);
