# 🏥 MedConnect: Symptom-Based Doctor Appointment System

[![Supabase](https://img.shields.io/badge/Supabase-3EC48C?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/CSS)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)

MedConnect is a premium, full-stack Vanilla JavaScript web application designed to streamline the healthcare experience. It features an intelligent symptom-based routing system that connects patients with the right medical specialists, coupled with a robust appointment management system.

---

## ✨ Key Features

### 🔐 Multi-Role Access Control
- **Patients**: Explore symptoms, find doctors, book appointments, and manage their health journey.
- **Doctors**: Manage their professional profile, track upcoming appointments, and update patient status.
- **Admins**: Comprehensive oversight of the entire ecosystem including user management and system configuration.

### 🧠 Intelligent Symptom Routing
- Advanced mapping of symptoms to medical specialties.
- Helps patients find the right care without prior medical knowledge.

### 📅 Seamless Appointment Management
- Real-time booking flow with date and time slot selection.
- Automated status updates (Pending, Confirmed, Completed, Cancelled).
- Appointment history for both patients and doctors.

### 🌟 Premium UI/UX
- **Glassmorphism Design**: A modern, sleek aesthetic with subtle transparencies.
- **Fully Responsive**: Optimized for desktops, tablets, and mobile devices.
- **Micro-animations**: Smooth transitions and interactive elements for a premium feel.

### ⭐ Patient Feedback System
- Integrated rating and review system for appointments.
- Helps maintain high service standards through community feedback.

---

## 🛠️ Tech Stack

- **Frontend**: Vanilla JavaScript (ES6+), HTML5, CSS3 (Custom Variables, Grid, Flexbox).
- **Backend-as-a-Service**: [Supabase](https://supabase.com/)
  - **Authentication**: Secure Email/Password auth.
  - **Database**: PostgreSQL with Row Level Security (RLS).
  - **Storage**: (Optional) For profile images.
- **Icons**: Lucide Icons / Custom SVG.

---

## 📂 Project Structure

```text
appointment-system/
├── css/
│   └── style.css            # Premium custom styles (Glassmorphism, Animations)
├── js/
│   ├── supabase-config.js   # Supabase client initialization
│   ├── app.js               # Common utilities & Auth state management
│   ├── auth.js              # Authentication logic
│   ├── symptoms.js          # Symptom-specialty mapping logic
│   ├── doctors.js           # Directory & filtering logic
│   ├── booking.js           # Real-time booking system
│   ├── dashboard-patient.js # Patient-centric features
│   ├── dashboard-doctor.js  # Doctor-centric management
│   └── dashboard-admin.js   # Administrative controls
├── supabase/
│   ├── schema.sql           # Database schema & RLS policies
│   └── seed.sql             # Mapping rules & dummy data
├── index.html               # Landing page & Disclaimer
├── auth.html                # Unified Login/Signup
├── symptoms.html            # Symptom selection interface
├── doctors.html             # Smart doctor directory
├── booking.html             # Slot-based booking system
├── patient-dashboard.html   # Patient dashboard view
├── doctor-dashboard.html    # Doctor dashboard view
└── admin-dashboard.html     # Admin dashboard view
```

---

## 🚀 Getting Started

### 1. Supabase Setup
1. Create a project at [Supabase.com](https://supabase.com/).
2. Run `supabase/schema.sql` in the **SQL Editor** to set up tables and RLS policies.
3. Run `supabase/seed.sql` to populate initial symptoms and doctor data.
4. Enable **Email Provider** in Authentication settings.

### 2. Configuration
1. Obtain your **Project URL** and **Anon Key** from Project Settings -> API.
2. Rename `js/supabase-config.example.js` to `js/supabase-config.js`.
3. Fill in your credentials:
   ```javascript
   const SUPABASE_URL = 'https://your-project-id.supabase.co';
   const SUPABASE_ANON_KEY = 'your-public-anon-key';
   ```

### 3. Launch
Serve the project using any local web server:
```bash
# Using Python
python -m http.server 3000

# Using Node.js (if installed)
npx serve .
```

---

## ⚖️ Disclaimer

> **Important**: This application is for demonstrative and educational purposes only. The symptom routing is based on static mapping and does not constitute professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified health provider with any questions regarding a medical condition.
