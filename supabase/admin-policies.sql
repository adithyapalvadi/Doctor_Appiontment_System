-- ============================================
-- ADMIN RLS POLICIES
-- Run this in Supabase SQL Editor to grant
-- admin users full access to manage data.
-- ============================================

-- Allow admins to read ALL appointments (needed for charts)
CREATE POLICY "Admins can manage appointments" ON public.appointments FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- Allow admins to manage doctors
CREATE POLICY "Admins can manage doctors" ON public.doctors FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- Allow admins to manage symptoms
CREATE POLICY "Admins can manage symptoms" ON public.symptoms FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

-- Allow admins to read all user profiles
CREATE POLICY "Admins can read all users" ON public.users FOR SELECT 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));
