# Backend Patient Portal Service

## Security & Authorization
- Passwords hashed with Node `crypto.scryptSync` + per-user 16-byte random salt and verified with `crypto.timingSafeEqual`.
- Authenticated sessions use an `HttpOnly`, `SameSite=Lax` cookie (`healix_patient_session`) mapped to hashed server-side session tokens.
- Every sensitive endpoint (`/api/patient/profile`, `/api/patient/appointments`, `/api/patient/records`, `/api/patient/invoices/[invoiceId]/download`) requires a valid session (`401 Unauthorized` otherwise) and strictly scopes data to the authenticated `patientId`.

## Endpoints
- `POST /api/patient/auth/register` — Register a new patient account and start an authenticated session.
- `POST /api/patient/auth/login` — Authenticate an existing patient.
- `POST /api/patient/auth/logout` — Revoke the current session and clear the cookie.
- `GET /api/patient/auth/me` — Verify active session and return sanitized patient profile.
- `GET /api/patient/profile` & `PATCH /api/patient/profile` — View and update personal information.
- `GET /api/patient/appointments` — Returns `upcoming` and `history` appointments scoped to the authenticated patient.
- `GET /api/patient/records` — Returns `medicalHistory`, `prescriptions`, `labReports`, `radiologyReports`, and `billingHistory`.
- `GET /api/patient/invoices/[invoiceId]/download` — Authorized invoice download (`Content-Disposition: attachment`).
