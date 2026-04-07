-- Create custom enums for our standard roles and statuses
CREATE TYPE user_role AS ENUM ('patient', 'doctor', 'admin');
CREATE TYPE appointment_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');

-- Drop existing tables if re-running
DROP TABLE IF EXISTS public.appointments CASCADE;
DROP TABLE IF EXISTS public.symptoms CASCADE;
DROP TABLE IF EXISTS public.doctors CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;

-- Users Table (Extended profiles for Supabase Auth users)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role user_role DEFAULT 'patient'::user_role NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Doctors Table
CREATE TABLE public.doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    experience_years INTEGER DEFAULT 0,
    reg_number TEXT, -- Medical Registration Number e.g. "TNMC 12345"
    about TEXT,
    address TEXT DEFAULT 'Chennai',
    email TEXT,
    phone TEXT,
    available_days TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Symptoms Table (Used for routing logic)
CREATE TABLE public.symptoms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    symptom_name TEXT NOT NULL UNIQUE,
    mapped_specialty TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Appointments Table
CREATE TABLE public.appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES public.doctors(id) ON DELETE CASCADE NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status appointment_status DEFAULT 'pending'::appointment_status NOT NULL,
    symptoms_described TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-----------------------------------------
-- ROW LEVEL SECURITY (RLS) POLICIES --
-----------------------------------------

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.symptoms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Users: Authenticated users can read profiles (needed for doctor-patient joins).
CREATE POLICY "Users can read own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Authenticated can read profiles" ON public.users FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users can insert own profile" ON public.users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);

-- Doctors: Anyone can read doctor profiles to book appointments.
CREATE POLICY "Anyone can read doctors" ON public.doctors FOR SELECT USING (true);
CREATE POLICY "Doctors can insert own profile" ON public.doctors FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Doctors can update their profile" ON public.doctors FOR UPDATE USING (auth.uid() = user_id);

-- Symptoms: Anyone can read the symptom mapping
CREATE POLICY "Anyone can read symptoms" ON public.symptoms FOR SELECT USING (true);

-- Appointments:
-- Patients can see their own
-- Doctors can see their assigned appointments
-- Admins can see all
CREATE POLICY "Patients read own appointments" ON public.appointments FOR SELECT USING (auth.uid() = patient_id);
CREATE POLICY "Patients can insert appointments" ON public.appointments FOR INSERT WITH CHECK (auth.uid() = patient_id);
CREATE POLICY "Patients can update own appointments" ON public.appointments FOR UPDATE USING (auth.uid() = patient_id);
-- Assuming doctors are doing SELECT based on the joined user ID, but we map simple access here for doctors
CREATE POLICY "Doctors read assigned appointments" ON public.appointments FOR SELECT 
    USING (doctor_id IN (SELECT id FROM public.doctors WHERE user_id = auth.uid()));
CREATE POLICY "Doctors update assigned appointments" ON public.appointments FOR UPDATE
    USING (doctor_id IN (SELECT id FROM public.doctors WHERE user_id = auth.uid()));

-- Ratings Table
CREATE TABLE public.ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    doctor_id UUID REFERENCES public.doctors(id) ON DELETE CASCADE NOT NULL,
    appointment_id UUID REFERENCES public.appointments(id) ON DELETE CASCADE NOT NULL UNIQUE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;

-- Anyone can read ratings (needed for avg calculation on doctor cards)
CREATE POLICY "Anyone can read ratings" ON public.ratings FOR SELECT USING (true);
-- Patients can insert their own ratings
CREATE POLICY "Patients can insert ratings" ON public.ratings FOR INSERT WITH CHECK (auth.uid() = patient_id);
