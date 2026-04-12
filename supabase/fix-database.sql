-- ============================================
-- FIX DB ERRORS (INFINITE RECURSION)
-- Run this in your Supabase SQL Editor
-- ============================================

-- 1. Drop the recursive policy from the users table that is causing the 500 errors
DROP POLICY IF EXISTS "Admins can read all users" ON public.users;

-- 2. Ensure basic view access is granted so counts work
DROP POLICY IF EXISTS "Authenticated can read profiles" ON public.users;
CREATE POLICY "Authenticated can read profiles" ON public.users FOR SELECT USING (auth.role() = 'authenticated');

-- 3. (Optional) Re-apply the valid admin policies for the other tables safely
DROP POLICY IF EXISTS "Admins can manage appointments" ON public.appointments;
CREATE POLICY "Admins can manage appointments" ON public.appointments FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins can manage doctors" ON public.doctors;
CREATE POLICY "Admins can manage doctors" ON public.doctors FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins can manage symptoms" ON public.symptoms;
CREATE POLICY "Admins can manage symptoms" ON public.symptoms FOR ALL 
    USING (EXISTS (SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'));
