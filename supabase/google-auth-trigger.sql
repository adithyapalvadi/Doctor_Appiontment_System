-- ============================================
-- GOOGLE OAUTH SYNC TRIGGER
-- Run this in your Supabase SQL Editor
-- ============================================

-- Create a function that handles new user signups from Supabase Auth (e.g., Google OAuth)
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS trigger AS $$
BEGIN
  -- Insert the new user into the public.users table.
  -- We extract the email and name from the auth.users metadata if it exists (Google provides this).
  -- We default the role to 'patient'. People who want to be doctors/admins should use the standard form or be upgraded manually.
  INSERT INTO public.users (id, email, name, role)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    'patient'
  )
  -- If the user already exists (e.g. they signed up via email then logged in with Google), ignore the insert error
  ON CONFLICT (id) DO NOTHING;

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop the trigger if it already exists so we can safely re-run this script
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create the trigger so it fires immediately after a new row is inserted into auth.users
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
