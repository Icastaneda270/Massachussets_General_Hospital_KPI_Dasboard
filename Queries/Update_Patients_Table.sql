-- Test Table
SELECT * FROM hospital_db.patients;

-- Results Example: First = Lavonia8, Last = Wunsch504, Maiden = Will178

-- Updating table to remove numbers from 
SELECT 
    FIRST AS original_first,
    REGEXP_REPLACE(FIRST, '[0-9]', '') AS cleaned_first,
    LAST AS original_last,
    REGEXP_REPLACE(LAST, '[0-9]', '') AS cleaned_last,
    MAIDEN AS original_maiden,
    REGEXP_REPLACE(MAIDEN, '[0-9]', '') AS cleaned_maiden
FROM 
    hospital_db.patients
WHERE 
    FIRST REGEXP '[0-9]' 
    OR LAST REGEXP '[0-9]'
    OR MAIDEN REGEXP '[0-9]';

-- Once verified, run the update
UPDATE hospital_db.patients
SET 
    FIRST = REGEXP_REPLACE(FIRST, '[0-9]', ''),
    LAST = REGEXP_REPLACE(LAST, '[0-9]', ''),
    MAIDEN = REGEXP_REPLACE(MAIDEN, '[0-9]', '')
WHERE 
    FIRST REGEXP '[0-9]' 
    OR LAST REGEXP '[0-9]'
    OR MAIDEN REGEXP '[0-9]';
   
-- Test Updated Table 
SELECT * FROM hospital_db.patients;
