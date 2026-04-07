-- Seed comprehensive symptoms -> specialty mappings
-- Delete existing symptoms first to avoid duplicates
DELETE FROM public.symptoms;

INSERT INTO public.symptoms (symptom_name, mapped_specialty) VALUES 
    -- General Physician
    ('Fever', 'General Physician'),
    ('Cold', 'General Physician'),
    ('Cough', 'General Physician'),
    ('Body Pain', 'General Physician'),
    ('Fatigue', 'General Physician'),

    -- Family Medicine Doctor
    ('General Illness', 'Family Medicine Doctor'),
    ('Chronic Care', 'Family Medicine Doctor'),
    ('Preventive Checkup', 'Family Medicine Doctor'),

    -- Internal Medicine Specialist
    ('Diabetes', 'Internal Medicine Specialist'),
    ('High Blood Pressure', 'Internal Medicine Specialist'),
    ('Infections', 'Internal Medicine Specialist'),
    ('Organ-related Issues', 'Internal Medicine Specialist'),

    -- Cardiologist
    ('Chest Pain', 'Cardiologist'),
    ('Shortness of Breath', 'Cardiologist'),
    ('Palpitations', 'Cardiologist'),

    -- Neurologist
    ('Headache', 'Neurologist'),
    ('Migraine', 'Neurologist'),
    ('Seizures', 'Neurologist'),
    ('Dizziness', 'Neurologist'),
    ('Numbness', 'Neurologist'),

    -- Dermatologist
    ('Acne', 'Dermatologist'),
    ('Skin Rash', 'Dermatologist'),
    ('Itching', 'Dermatologist'),
    ('Hair Loss', 'Dermatologist'),

    -- Endocrinologist
    ('Weight Changes', 'Endocrinologist'),
    ('Thyroid Issues', 'Endocrinologist'),
    ('Hormonal Imbalance', 'Endocrinologist'),

    -- Gastroenterologist
    ('Stomach Pain', 'Gastroenterologist'),
    ('Acidity', 'Gastroenterologist'),
    ('Vomiting', 'Gastroenterologist'),
    ('Constipation', 'Gastroenterologist'),

    -- Pulmonologist
    ('Persistent Cough', 'Pulmonologist'),
    ('Breathing Difficulty', 'Pulmonologist'),
    ('Asthma', 'Pulmonologist'),

    -- Nephrologist
    ('Swelling', 'Nephrologist'),
    ('Kidney Pain', 'Nephrologist'),
    ('Urine Problems', 'Nephrologist'),

    -- Rheumatologist
    ('Joint Pain', 'Rheumatologist'),
    ('Joint Stiffness', 'Rheumatologist'),
    ('Joint Swelling', 'Rheumatologist'),

    -- Psychiatrist
    ('Depression', 'Psychiatrist'),
    ('Anxiety', 'Psychiatrist'),
    ('Mood Disorders', 'Psychiatrist'),

    -- General Surgeon
    ('Lumps', 'General Surgeon'),
    ('Hernia', 'General Surgeon'),
    ('Abdominal Pain', 'General Surgeon'),

    -- Orthopedic Surgeon
    ('Bone Pain', 'Orthopedic Surgeon'),
    ('Fractures', 'Orthopedic Surgeon'),
    ('Joint Issues', 'Orthopedic Surgeon'),
    ('Back Pain', 'Orthopedic Surgeon'),

    -- Neurosurgeon
    ('Brain Injury', 'Neurosurgeon'),
    ('Spine Injury', 'Neurosurgeon'),
    ('Severe Headaches', 'Neurosurgeon'),

    -- Cardiothoracic Surgeon
    ('Heart Surgery Conditions', 'Cardiothoracic Surgeon'),
    ('Lung Surgery Conditions', 'Cardiothoracic Surgeon'),

    -- Plastic Surgeon
    ('Burns', 'Plastic Surgeon'),
    ('Injuries', 'Plastic Surgeon'),
    ('Cosmetic Concerns', 'Plastic Surgeon'),

    -- Urologist
    ('Urinary Issues', 'Urologist'),
    ('Kidney Stones', 'Urologist'),
    ('Prostate Problems', 'Urologist'),

    -- Pediatrician
    ('Fever in Children', 'Pediatrician'),
    ('Child Infections', 'Pediatrician'),
    ('Growth Issues', 'Pediatrician'),

    -- Neonatologist
    ('Premature Birth', 'Neonatologist'),
    ('Newborn Complications', 'Neonatologist'),

    -- Pediatric Surgeon
    ('Congenital Defects', 'Pediatric Surgeon'),
    ('Child Surgeries', 'Pediatric Surgeon'),

    -- Gynecologist
    ('Menstrual Problems', 'Gynecologist'),
    ('Pelvic Pain', 'Gynecologist'),

    -- Obstetrician
    ('Pregnancy Care', 'Obstetrician'),
    ('Delivery', 'Obstetrician'),

    -- Ophthalmologist
    ('Vision Problems', 'Ophthalmologist'),
    ('Eye Pain', 'Ophthalmologist'),
    ('Eye Redness', 'Ophthalmologist'),

    -- ENT Specialist
    ('Ear Pain', 'ENT Specialist'),
    ('Throat Pain', 'ENT Specialist'),
    ('Sinus Issues', 'ENT Specialist'),

    -- Dentist
    ('Tooth Pain', 'Dentist'),
    ('Cavities', 'Dentist'),
    ('Gum Problems', 'Dentist'),

    -- Oral & Maxillofacial Surgeon
    ('Jaw Issues', 'Oral & Maxillofacial Surgeon'),
    ('Facial Injuries', 'Oral & Maxillofacial Surgeon'),

    -- Oncologist
    ('Unusual Lumps', 'Oncologist'),
    ('Unexplained Weight Loss', 'Oncologist'),
    ('Cancer Symptoms', 'Oncologist'),

    -- Radiologist
    ('Imaging Diagnosis', 'Radiologist'),

    -- Anesthesiologist
    ('Pain Control', 'Anesthesiologist'),
    ('Surgery Support', 'Anesthesiologist'),

    -- Pathologist
    ('Disease Diagnosis', 'Pathologist'),
    ('Lab Tests', 'Pathologist'),

    -- Emergency Medicine Specialist
    ('Trauma', 'Emergency Medicine Specialist'),
    ('Accidents', 'Emergency Medicine Specialist'),
    ('Sudden Illness', 'Emergency Medicine Specialist'),

    -- Critical Care Specialist
    ('Severe Illness', 'Critical Care Specialist'),
    ('ICU Care', 'Critical Care Specialist'),

    -- Sports Medicine Specialist
    ('Sports Injuries', 'Sports Medicine Specialist'),
    ('Muscle Strain', 'Sports Medicine Specialist'),

    -- Geriatrician
    ('Age-related Problems', 'Geriatrician'),
    ('Memory Loss', 'Geriatrician'),

    -- Immunologist
    ('Immune Disorders', 'Immunologist'),
    ('Frequent Infections', 'Immunologist'),

    -- Infectious Disease Specialist
    ('Unusual Diseases', 'Infectious Disease Specialist'),
    ('Persistent Fever', 'Infectious Disease Specialist'),

    -- Hematologist
    ('Blood Disorders', 'Hematologist'),
    ('Anemia', 'Hematologist'),

    -- Allergist
    ('Allergies', 'Allergist'),
    ('Sneezing', 'Allergist'),
    ('Allergic Asthma', 'Allergist')

ON CONFLICT (symptom_name) DO NOTHING;

-- Seed some sample doctors (these don't have auth accounts, just for listing)
INSERT INTO public.doctors (name, specialty, experience_years, about, available_days, email, phone, address) VALUES 
    ('Dr. John Smith', 'General Physician', 15, 'Experienced family doctor specializing in comprehensive care.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dr.johnsmith@medconnect.com', '+91 9876543210', '123 Anna Salai, Chennai'),
    ('Dr. Emily Chen', 'Cardiologist', 12, 'Board-certified cardiologist focusing on preventive heart care.', ARRAY['Tuesday', 'Thursday', 'Saturday'], 'dr.emilychen@medconnect.com', '+91 8765432109', '45 Mount Road, Chennai'),
    ('Dr. Robert Johnson', 'Dermatologist', 8, 'Expert in cosmetic and medical dermatology.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], 'dr.robertj@medconnect.com', '+91 7654321098', '78 T Nagar, Chennai'),
    ('Dr. Sarah Williams', 'Gastroenterologist', 20, 'Specialist in digestive health and endoscopic procedures.', ARRAY['Monday', 'Thursday', 'Friday'], 'dr.sarahw@medconnect.com', '+91 6543210987', '12 OMR, Chennai'),
    ('Dr. Michael Brown', 'Orthopedic Surgeon', 18, 'Orthopedic surgeon focusing on joint replacements and sports injuries.', ARRAY['Wednesday', 'Friday'], 'dr.michaelb@medconnect.com', '+91 9123456780', '34 Velachery, Chennai'),
    ('Dr. Jessica Davis', 'Neurologist', 10, 'Dedicated to treating neurological disorders and migraines.', ARRAY['Tuesday', 'Wednesday'], 'dr.jessicad@medconnect.com', '+91 9988776655', '56 Adyar, Chennai'),
    ('Dr. David Miller', 'Ophthalmologist', 25, 'Comprehensive eye physician and surgeon.', ARRAY['Monday', 'Thursday'], 'dr.davidm@medconnect.com', '+91 9876501234', '89 Mylapore, Chennai'),
    ('Dr. Lisa Wilson', 'Dentist', 14, 'General and pediatric dentistry professional.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], 'dr.lisaw@medconnect.com', '+91 8765012345', '112 Nungambakkam, Chennai'),
    ('Dr. James Taylor', 'Psychiatrist', 22, 'Adult and adolescent mental health specialist.', ARRAY['Tuesday', 'Thursday'], 'dr.jamest@medconnect.com', '+91 7650123456', '134 Besant Nagar, Chennai')
ON CONFLICT DO NOTHING;
