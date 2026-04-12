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


-- Extended Practo Seed Data
INSERT INTO public.doctors (name, specialty, experience_years, about, available_days, email, phone, address) VALUES 
    ('Dr. A Gunasekaran', 'Neurologist', 27, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dragunasekaran@medconnect.com', '+91 987600001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. D R Shankar', 'Neurologist', 13, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdrshankar@medconnect.com', '+91 987601001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Natesan Damodaran', 'Neurologist', 21, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drnatesandamodaran@medconnect.com', '+91 987602001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sankara Subramani Kumarauru', 'Neurologist', 13, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsankarasubramanikumarauru@medconnect.com', '+91 987603001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Shankar Balakrishnan', 'Neurologist', 15, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drshankarbalakrishnan@medconnect.com', '+91 987604001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Thanga Thirupathirajan', 'Neurologist', 14, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drthangathirupathirajan@medconnect.com', '+91 987605001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Deva Prasad', 'Neurologist', 11, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdevaprasad@medconnect.com', '+91 987606001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. L Sindhuja', 'Neurologist', 27, 'Experienced neurologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drlsindhuja@medconnect.com', '+91 987607001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Senthil Sivaprakasam', 'Dermatologist', 19, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsenthilsivaprakasam@medconnect.com', '+91 987610001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Divya Vijayaraghavan', 'Dermatologist', 8, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdivyavijayaraghavan@medconnect.com', '+91 987611001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Aftab Matheen', 'Dermatologist', 6, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'draftabmatheen@medconnect.com', '+91 987612001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajeshwari', 'Dermatologist', 11, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajeshwari@medconnect.com', '+91 987613001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. K Uma Maheswari', 'Dermatologist', 25, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drkumamaheswari@medconnect.com', '+91 987614001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sai Preethi', 'Dermatologist', 25, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsaipreethi@medconnect.com', '+91 987615001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Divya K R', 'Dermatologist', 9, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdivyakr@medconnect.com', '+91 987616001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. S Deepika', 'Dermatologist', 9, 'Experienced dermatologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsdeepika@medconnect.com', '+91 987617001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajkumar Rathinasamy', 'Gastroenterologist', 7, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajkumarrathinasamy@medconnect.com', '+91 987620001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajan Babu', 'Gastroenterologist', 23, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajanbabu@medconnect.com', '+91 987621001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Livin Jose', 'Gastroenterologist', 24, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drlivinjose@medconnect.com', '+91 987622001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Kolandasami', 'Gastroenterologist', 26, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drkolandasami@medconnect.com', '+91 987623001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. C.Sugumar', 'Gastroenterologist', 28, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drcsugumar@medconnect.com', '+91 987624001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. R Kannan', 'Gastroenterologist', 29, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrkannan@medconnect.com', '+91 987625001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Mohammed Ali', 'Gastroenterologist', 21, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmohammedali@medconnect.com', '+91 987626001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Manimaran', 'Gastroenterologist', 12, 'Experienced gastroenterologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmanimaran@medconnect.com', '+91 987627001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. G Sudhir', 'Orthopedic Surgeon', 20, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drgsudhir@medconnect.com', '+91 987630001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Omer Sheriff', 'Orthopedic Surgeon', 11, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dromersheriff@medconnect.com', '+91 987631001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Agni Raj R', 'Orthopedic Surgeon', 16, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dragnirajr@medconnect.com', '+91 987632001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Barani Rathinavelu', 'Orthopedic Surgeon', 19, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drbaranirathinavelu@medconnect.com', '+91 987633001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. S.S. Kumar', 'Orthopedic Surgeon', 21, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsskumar@medconnect.com', '+91 987634001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Giriraj J K', 'Orthopedic Surgeon', 23, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drgirirajjk@medconnect.com', '+91 987635001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Prof. S Sundar', 'Orthopedic Surgeon', 9, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drprofssundar@medconnect.com', '+91 987636001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Narayanan V L', 'Orthopedic Surgeon', 27, 'Experienced orthopedic surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drnarayananvl@medconnect.com', '+91 987637001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sadhana Vezhaventhan', 'Gynecologist', 17, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsadhanavezhaventhan@medconnect.com', '+91 987640001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. S.Samundi Sankari', 'Gynecologist', 18, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drssamundisankari@medconnect.com', '+91 987641001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Padma Priya B', 'Gynecologist', 29, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drpadmapriyab@medconnect.com', '+91 987642001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. P. Varalakshmi Srinivasan', 'Gynecologist', 10, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drpvaralakshmisrinivasan@medconnect.com', '+91 987643001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Chithra', 'Gynecologist', 6, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drchithra@medconnect.com', '+91 987644001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. P Krishnamma', 'Gynecologist', 14, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drpkrishnamma@medconnect.com', '+91 987645001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Lakshmi Devarajan', 'Gynecologist', 13, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drlakshmidevarajan@medconnect.com', '+91 987646001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajiv Sreekumar', 'Gynecologist', 22, 'Experienced gynecologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajivsreekumar@medconnect.com', '+91 987647001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Deepak Kumar', 'Pediatrician', 19, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdeepakkumar@medconnect.com', '+91 987650001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Mohamed Yaseen', 'Pediatrician', 18, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmohamedyaseen@medconnect.com', '+91 987651001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Arun Kumar', 'Pediatrician', 5, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drarunkumar@medconnect.com', '+91 987652001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Margaret Chellaraj', 'Pediatrician', 24, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmargaretchellaraj@medconnect.com', '+91 987653001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Meena S', 'Pediatrician', 29, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmeenas@medconnect.com', '+91 987654001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajesh K', 'Pediatrician', 21, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajeshk@medconnect.com', '+91 987655001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. M.S Ranjith', 'Pediatrician', 7, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmsranjith@medconnect.com', '+91 987656001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Adalarasan Natesan', 'Pediatrician', 17, 'Experienced pediatrician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dradalarasannatesan@medconnect.com', '+91 987657001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Preethi.G', 'Ophthalmologist', 27, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drpreethig@medconnect.com', '+91 987670001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Lakshmy S', 'Ophthalmologist', 17, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drlakshmys@medconnect.com', '+91 987671001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Purnima Raman Srivatsa', 'Ophthalmologist', 13, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drpurnimaramansrivatsa@medconnect.com', '+91 987672001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Deepika Devi', 'Ophthalmologist', 14, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drdeepikadevi@medconnect.com', '+91 987673001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sandip Dattatray Patil', 'Ophthalmologist', 23, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsandipdattatraypatil@medconnect.com', '+91 987674001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Srikanth R', 'Ophthalmologist', 24, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsrikanthr@medconnect.com', '+91 987675001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Asokan P', 'Ophthalmologist', 15, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drasokanp@medconnect.com', '+91 987676001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Kaushik', 'Ophthalmologist', 17, 'Experienced ophthalmologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drkaushik@medconnect.com', '+91 987677001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sivabalan Elangovan', 'Psychiatrist', 15, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsivabalanelangovan@medconnect.com', '+91 987680001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Saritha', 'Psychiatrist', 17, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsaritha@medconnect.com', '+91 987681001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Maria Annita', 'Psychiatrist', 13, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmariaannita@medconnect.com', '+91 987682001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sivabackiya C', 'Psychiatrist', 27, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsivabackiyac@medconnect.com', '+91 987683001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Bharathi Visveswaran', 'Psychiatrist', 15, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drbharathivisveswaran@medconnect.com', '+91 987684001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Karthik.M.S', 'Psychiatrist', 15, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drkarthikms@medconnect.com', '+91 987685001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Srinivas Rajkumar T', 'Psychiatrist', 17, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsrinivasrajkumart@medconnect.com', '+91 987686001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Madhumitha Venkatesh', 'Psychiatrist', 24, 'Experienced psychiatrist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmadhumithavenkatesh@medconnect.com', '+91 987687001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. G. Vezhaventhan', 'Urologist', 26, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drgvezhaventhan@medconnect.com', '+91 987690001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. C Dev Krishna Bharathi', 'Urologist', 28, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drcdevkrishnabharathi@medconnect.com', '+91 987691001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Ilamparuthi', 'Urologist', 11, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drilamparuthi@medconnect.com', '+91 987692001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Neelakandan', 'Urologist', 20, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drneelakandan@medconnect.com', '+91 987693001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Yogeshwaran', 'Urologist', 25, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dryogeshwaran@medconnect.com', '+91 987694001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. R Jayaganesh', 'Urologist', 18, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrjayaganesh@medconnect.com', '+91 987695001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. A C Mani', 'Urologist', 24, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dracmani@medconnect.com', '+91 987696001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. A R Balaji', 'Urologist', 17, 'Experienced urologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drarbalaji@medconnect.com', '+91 987697001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sundararajaperumal Anandhakrishnan', 'Pulmonologist', 29, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsundararajaperumalanandhakrishnan@medconnect.com', '+91 9876100001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Venugopal', 'Pulmonologist', 24, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drvenugopal@medconnect.com', '+91 9876101001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Suresh Anantharaj', 'Pulmonologist', 7, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsureshanantharaj@medconnect.com', '+91 9876102001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Aishwarya Rajkumar', 'Pulmonologist', 29, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'draishwaryarajkumar@medconnect.com', '+91 9876103001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Bindu', 'Pulmonologist', 25, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drbindu@medconnect.com', '+91 9876104001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Mohan Venkataraman', 'Pulmonologist', 16, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmohanvenkataraman@medconnect.com', '+91 9876105001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. N Sekar', 'Pulmonologist', 26, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drnsekar@medconnect.com', '+91 9876106001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Nancy Glory', 'Pulmonologist', 6, 'Experienced pulmonologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drnancyglory@medconnect.com', '+91 9876107001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sundararaman P G', 'Endocrinologist', 13, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsundararamanpg@medconnect.com', '+91 9876110001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Ramkumar S', 'Endocrinologist', 18, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drramkumars@medconnect.com', '+91 9876111001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Sivagnana Sundaram Devanayagam', 'Endocrinologist', 8, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsivagnanasundaramdevanayagam@medconnect.com', '+91 9876112001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. V. Mohan', 'Endocrinologist', 16, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drvmohan@medconnect.com', '+91 9876113001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Vijay Viswanathan', 'Endocrinologist', 14, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drvijayviswanathan@medconnect.com', '+91 9876114001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Geethalakshmi', 'Endocrinologist', 14, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drgeethalakshmi@medconnect.com', '+91 9876115001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. M.S.Prem Kumar', 'Endocrinologist', 29, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmspremkumar@medconnect.com', '+91 9876116001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Bharath R', 'Endocrinologist', 14, 'Experienced endocrinologist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drbharathr@medconnect.com', '+91 9876117001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Selva Seetha Raman', 'General Surgeon', 25, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drselvaseetharaman@medconnect.com', '+91 9876120001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Rajkumar Rathinasamy', 'General Surgeon', 12, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drrajkumarrathinasamy@medconnect.com', '+91 9876121001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. M.S.Kalyan Kumar', 'General Surgeon', 22, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmskalyankumar@medconnect.com', '+91 9876122001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. S R Subrammaniyan', 'General Surgeon', 20, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsrsubrammaniyan@medconnect.com', '+91 9876123001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Gobalakichenin M', 'General Surgeon', 16, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drgobalakicheninm@medconnect.com', '+91 9876124001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. B. Padam Kumar', 'General Surgeon', 14, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drbpadamkumar@medconnect.com', '+91 9876125001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Prabhu', 'General Surgeon', 14, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drprabhu@medconnect.com', '+91 9876126001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Mathu Soothanan', 'General Surgeon', 25, 'Experienced general surgeon in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmathusoothanan@medconnect.com', '+91 9876127001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. A Gunasekaran', 'General Physician', 5, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dragunasekaran@medconnect.com', '+91 9876130001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Jeysel Suraj', 'General Physician', 19, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drjeyselsuraj@medconnect.com', '+91 9876131001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Mathu Soothanan', 'General Physician', 6, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drmathusoothanan@medconnect.com', '+91 9876132001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Hari Prasad', 'General Physician', 12, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drhariprasad@medconnect.com', '+91 9876133001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Senthil Kumar', 'General Physician', 13, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drsenthilkumar@medconnect.com', '+91 9876134001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Thirumanikandan', 'General Physician', 12, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drthirumanikandan@medconnect.com', '+91 9876135001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Natesan C', 'General Physician', 16, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drnatesanc@medconnect.com', '+91 9876136001', 'Specialty Clinic, Chennai, Chennai'),
    ('Dr. Venkatraman S', 'General Physician', 8, 'Experienced general physician in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'drvenkatramans@medconnect.com', '+91 9876137001', 'Specialty Clinic, Chennai, Chennai')
ON CONFLICT DO NOTHING;

-- Original Practo Dentists
INSERT INTO public.doctors (name, specialty, experience_years, about, available_days, email, phone, address) VALUES
('Dr. K. Senthil Kumar', 'Dentist', 31, 'Highly experienced dentist with 31 years of practice.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], 'dr.senthilkumar@medconnect.com', '+91 9876501001', 'Tooth N Care Dental Clinic, Kodambakkam, Chennai'),
('Dr. Poornima Srikanth', 'Dentist', 21, 'Experienced family dentist with 21 years of practice.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.poornimasrikanth@medconnect.com', '+91 9876501002', 'Smile Solutions Family Dentistry, Perungudi, Chennai'),
('Dr. M. Srikanth', 'Dentist', 25, 'Senior dentist with 25 years of practice.', ARRAY['Monday', 'Tuesday', 'Thursday', 'Saturday'], 'dr.msrikanth@medconnect.com', '+91 9876501003', 'Smile Solutions Family Dentistry, Chromepet, Chennai'),
('Dr. B J Barun', 'Dentist', 22, 'Multispeciality dental expert with 22 years of practice.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], 'dr.bjbarun@medconnect.com', '+91 9876501004', 'Dr. Baruns Multispeciality Dental Centre, Velachery, Chennai'),
('Dr. Kiruthika Asokan', 'Dentist', 22, 'Family dentist with 22 years of practice.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dr.kiruthika@medconnect.com', '+91 9876501005', 'Family Clinic, Porur, Chennai'),
('Dr. Vesta Enid Lydia', 'Dentist', 14, 'Cosmetic and general dentist with 14 years of practice.', ARRAY['Tuesday', 'Thursday', 'Saturday'], 'dr.vestalydia@medconnect.com', '+91 9876501006', 'Stunning Smiles Dental, Anna Nagar West, Chennai'),
('Dr. Haritha U', 'Dentist', 8, 'Young dental professional with 8 years of practice.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], 'dr.haritha@medconnect.com', '+91 9876501007', 'Vishnu Dental Clinic, Villivakkam, Chennai'),
('Dr. Amruth Ganesh', 'Dentist', 10, 'Precision dental care specialist with 10 years of practice.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.amruthganesh@medconnect.com', '+91 9876501008', 'Dr Amruths Precision Dental Care, Anna Nagar, Chennai'),
('Dr. Shobana Thevi', 'Dentist', 10, 'Dental care specialist with 10 years of experience.', ARRAY['Monday', 'Tuesday', 'Thursday', 'Saturday'], 'dr.shobanathevi@medconnect.com', '+91 9876501009', 'Elite Dental Care, Kelambakkam, Chennai'),
('Dr. T. Sivasankari', 'Dentist', 23, 'Senior dentist with 23 years of practice.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dr.sivasankari@medconnect.com', '+91 9876501010', 'Harsinis Dental Clinic, Mogappair, Chennai'),
('Dr. Deepak Raj', 'Dentist', 17, 'Implant and orthodontic specialist with 17 years of practice.', ARRAY['Tuesday', 'Thursday', 'Saturday'], 'dr.deepakraj@medconnect.com', '+91 9876501011', 'Raj Implant And Orthodontic Center, Kolathur, Chennai'),
('Dr. E. Sarath Chandar', 'Dentist', 31, 'Veteran dental surgeon with 31 years of practice.', ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'], 'dr.sarathchandar@medconnect.com', '+91 9876501012', 'Sarath Dental Clinic, Thiruvanmiyur, Chennai'),
('Dr. Rachna Balaji', 'Dentist', 31, 'Orthodontic and implant specialist with 31 years of experience.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.rachnab@medconnect.com', '+91 9876501013', 'KB Dental Clinic, Anna Nagar, Chennai'),
('Dr. Soosi Christopher', 'Dentist', 34, 'Veteran dental professional with 34 years of practice.', ARRAY['Monday', 'Tuesday', 'Thursday'], 'dr.soosic@medconnect.com', '+91 9876501014', 'Oyster Dental Care, Anna Nagar, Chennai'),
('Dr. Subramoniam S', 'Dentist', 23, 'Experienced dental surgeon with 23 years of practice.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.subramoniam@medconnect.com', '+91 9876501015', 'Lakshmi Dental Care, Porur, Chennai')
ON CONFLICT DO NOTHING;

-- ENT Specialists
INSERT INTO public.doctors (name, specialty, experience_years, about, available_days, email, phone, address) VALUES
('Dr. Ravi Ramalingam', 'ENT Specialist', 30, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.raviramalingam@medconnect.com', '+91 9876530101', 'Kkrt Ent Hospital, MRC Nagar, Chennai'),
('Dr. Sanjeev Mohanty', 'ENT Specialist', 20, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Tuesday', 'Thursday'], 'dr.sanjeevmohanty@medconnect.com', '+91 9876530102', 'MGM Healthcare, Aminjikarai, Chennai'),
('Dr. M. K. Rajasekar', 'ENT Specialist', 25, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dr.mkrajasekar@medconnect.com', '+91 9876530103', 'Madras ENT Research Foundation, R.A. Puram, Chennai'),
('Dr. A. Ravi', 'ENT Specialist', 18, 'Experienced ENT Specialist in Chennai.', ARRAY['Tuesday', 'Thursday', 'Saturday'], 'dr.aravi@medconnect.com', '+91 9876530104', 'Apollo Spectra Hospitals, MRC Nagar, Chennai'),
('Dr. Kumaresan', 'ENT Specialist', 15, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday'], 'dr.kumaresan@medconnect.com', '+91 9876530105', 'Sri Ramachandra Medical Centre, Porur, Chennai'),
('Dr. S. K. E. Apparao', 'ENT Specialist', 22, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Tuesday', 'Thursday'], 'dr.skeapparao@medconnect.com', '+91 9876530106', 'Vijaya Hospital, Vadapalani, Chennai'),
('Dr. K. J. Senthil Kumar', 'ENT Specialist', 12, 'Experienced ENT Specialist in Chennai.', ARRAY['Monday', 'Wednesday', 'Friday', 'Saturday'], 'dr.kjsenthilkumar@medconnect.com', '+91 9876530107', 'Gleneagles Global Health City, Perumbakkam, Chennai'),
('Dr. R. Kannan', 'ENT Specialist', 10, 'Experienced ENT Specialist in Chennai.', ARRAY['Tuesday', 'Thursday', 'Saturday'], 'dr.rkannan@medconnect.com', '+91 9876530108', 'Dr. Kamakshi Memorial Hospital, Pallikaranai, Chennai')
ON CONFLICT DO NOTHING;
