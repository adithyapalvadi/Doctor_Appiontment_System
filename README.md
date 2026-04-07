# Symptom-Based Doctor Appointment System

A full-stack, Vanilla JavaScript web application that helps route patients to appropriate doctor specialties based on selected symptoms, and allows for booking appointments. It uses Supabase for authentication and database management.

## Project Structure

```text
appointment-system/
├── css/
│   └── style.css            # Premium custom styles (CSS Grid, Variables, Glassmorphism)
├── js/
│   ├── supabase-config.js   # Supabase client initialization
│   ├── app.js               # Common utilities, Auth state listener
│   ├── auth.js              # Login/Signup logic
│   ├── symptoms.js          # Symptom checklist logic
│   ├── doctors.js           # Directory and filtering logic
│   ├── booking.js           # Appointment booking logic
│   ├── dashboard-patient.js # Patient dashboard logic
│   ├── dashboard-doctor.js  # Doctor dashboard logic
│   └── dashboard-admin.js   # Admin dashboard logic
├── supabase/
│   ├── schema.sql           # Database schema & RLS policies
│   └── seed.sql             # Dummy data (symptoms to specialties mapping, doctors)
├── index.html               # Landing page with disclaimer
├── auth.html                # Login / Registration
├── symptoms.html            # Core symptom selection feature
├── doctors.html             # List and filter available doctors
├── booking.html             # Make an appointment
├── patient-dashboard.html   # Patient view
├── doctor-dashboard.html    # Doctor view
└── admin-dashboard.html     # Admin view
```

## Setup Instructions

### 1. Supabase Initialization
1. Create a free account and project on [Supabase.com](https://supabase.com/).
2. In your Supabase Dashboard, navigate to the **SQL Editor**.
3. Create a new query, paste the contents of `supabase/schema.sql`, and run it. This creates the necessary tables, enables Row Level Security (RLS), and sets up the policies.
4. Create another new query in the **SQL Editor**, paste the contents of `supabase/seed.sql`, and run it. This seeds your database with default symptoms and dummy doctors for testing.
5. In your Supabase project settings, go to **Authentication** -> **Providers** and ensure Email provider is enabled.
6. (Optional) Check the Triggers section in your SQL editor if you'd like to customize the function that syncs Supabase Auth user creation with the `public.users` table.

### 2. Frontend Configuration
1. Back in your Supabase Dashboard, go to **Project Settings** -> **API**.
2. Copy the **Project URL** and the **anon public API key**.
3. In your code editor, duplicate `js/supabase-config.example.js` and rename the copy to `js/supabase-config.js`.
4. Paste the URL into `const SUPABASE_URL = 'YOUR_SUPABASE_URL';`
5. Paste the anon key into `const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';`

### 3. Running Locally
Simply serve the files using a local web server (e.g., Live Server extension in VSCode, or Python's `http.server`).
```bash
python -m http.server 3000
```
Then navigate to `http://localhost:3000`.

## Architecture Note
This app uses a CDN import for `@supabase/supabase-js` so no build step (Webpack/Vite) is strictly required. Modern browser support for ES Modules makes this seamless for vanilla JS applications.

## Disclaimer
> This project is for demonstrative purposes and does not replace professional medical diagnosis or consultation. Patients are routed based on static logical mapping rules.
