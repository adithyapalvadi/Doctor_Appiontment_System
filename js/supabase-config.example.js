import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm'

// ==========================================
// SUPABASE CONFIGURATION
// ==========================================
// IMPORTANT: Replace these with your actual Supabase project URL and anon public key!
// You can find these in your Supabase Dashboard -> Project Settings -> API.

const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
