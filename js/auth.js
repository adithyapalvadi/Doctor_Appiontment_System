import { supabase } from './supabase-config.js';
import { AppUtils, AuthManager } from './app.js';

// Flag to prevent auth observer from running during signup
let isSigningUp = false;

// If user is already logged in, redirect them
window.addEventListener('authStateChanged', (e) => {
    if (e.detail.user && !isSigningUp) {
        if (e.detail.user.role === 'patient') window.location.href = 'patient-dashboard.html';
        else if (e.detail.user.role === 'doctor') window.location.href = 'doctor-dashboard.html';
        else if (e.detail.user.role === 'admin') window.location.href = 'admin-dashboard.html';
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('login-form');
    const signupForm = document.getElementById('signup-form');

    // Handle Login
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = document.getElementById('login-email').value;
            const password = document.getElementById('login-password').value;

            AppUtils.showLoading("Signing in...");
            const { data, error } = await supabase.auth.signInWithPassword({ email, password });
            AppUtils.hideLoading();

            if (error) {
                AppUtils.showToast(error.message, "error");
            } else {
                AppUtils.showToast("Login successful!", "success");
                // The authStateChanged listener will handle redirection
            }
        });
    }

    // Handle Signup
    if (signupForm) {
        signupForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const name = document.getElementById('signup-name').value;
            const email = document.getElementById('signup-email').value;
            const password = document.getElementById('signup-password').value;
            const role = document.getElementById('signup-role').value;

            // Block the auth observer from running while we set up the profile
            isSigningUp = true;

            AppUtils.showLoading("Creating account...");

            // 1. Sign up with Supabase Auth
            const { data: authData, error: authError } = await supabase.auth.signUp({
                email,
                password
            });

            if (authError) {
                isSigningUp = false;
                AppUtils.hideLoading();
                AppUtils.showToast(authError.message, "error");
                return;
            }

            const userId = authData.user.id;

            // 2. Insert into public.users (profile)
            const { error: userError } = await supabase
                .from('users')
                .insert([{ id: userId, name, email, role }]);

            if (userError) {
                console.error("Profile creation error:", userError);
                isSigningUp = false;
                AppUtils.hideLoading();
                AppUtils.showToast("Failed to create profile: " + userError.message, "error");
                return;
            }

            // 3. If doctor, insert into public.doctors
            if (role === 'doctor') {
                const specialty = document.getElementById('signup-specialty').value;
                const experience = parseInt(document.getElementById('signup-experience').value) || 0;
                const regNumber = document.getElementById('signup-reg-number').value;
                const address = document.getElementById('signup-address').value;
                const phone = document.getElementById('signup-phone').value;
                
                const { error: doctorError } = await supabase
                    .from('doctors')
                    .insert([{
                        user_id: userId,
                        name: name,
                        email: email,
                        phone: phone,
                        address: address,
                        specialty: specialty,
                        experience_years: experience,
                        reg_number: regNumber,
                        available_days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    }]);
                    
                if (doctorError) {
                    console.error("Doctor profile error:", doctorError);
                }
            }

            // 4. Done — now let auth observer take over
            isSigningUp = false;
            AppUtils.hideLoading();
            AppUtils.showToast("Account created! Redirecting...", "success");

            // Manually trigger profile fetch now that profile exists
            await AuthManager.handleUserSignIn(authData.user);

            // Redirect based on role
            setTimeout(() => {
                if (role === 'patient') window.location.href = 'patient-dashboard.html';
                else if (role === 'doctor') window.location.href = 'doctor-dashboard.html';
            }, 1000);
        });
    }
});
