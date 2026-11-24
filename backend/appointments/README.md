# Backend Appointment Booking Service

## Endpoints Implemented
- `GET /api/appointments/availability?doctorId={id}&date={YYYY-MM-DD}` — Returns validated time slots with live availability flags.
- `POST /api/appointments` — Validates required fields, date, and slot; enforces atomic double-booking prevention (`409 Conflict` on duplicate active slot); generates a unique `HLX-YYYYMMDD-XXXX` booking reference.
- `GET /api/appointments/{reference}` — Tracks appointment status and booking details.
- `PATCH /api/appointments/{reference}/reschedule` — Validates new date/slot, prevents double booking, and updates status to `rescheduled`.
- `PATCH /api/appointments/{reference}/cancel` — Cancels an active appointment and frees the slot for future bookings.

## Database Persistence
- Schema: `database/appointments.sql` (includes partial unique index `idx_appointments_no_double_booking` on `(doctor_id, appointment_date, time_slot) WHERE status <> 'cancelled'`).
- Local development store: `database/appointments.json` (protected by an in-process write lock in `frontend/my-app/app/api/appointments/store.ts`).
