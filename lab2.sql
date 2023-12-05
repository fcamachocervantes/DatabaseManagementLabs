/*
    CSCI 403 Lab 2: Schedule
    
    Name: Francisco Camacho
*/

-- do not put SET SEARCH_PATH in this file
-- add your statements after the appropriate Step item
-- it's fine to add additional comments as well

/* Step 1: Create the table */
CREATE TABLE schedule
(
    department TEXT, 
    course TEXT, 
    title TEXT NOT NULL, 
    credits NUMERIC(3,1) NOT NULL, 
    semester TEXT, 
    year INTEGER DEFAULT EXTRACT(YEAR FROM CURRENT_DATE),
    CONSTRAINT semester_check CHECK(semester IN ('Fall','Summer','Spring')),
    PRIMARY KEY(department, course)
);
/* Step 2: Insert the data */
INSERT INTO schedule
SELECT department, course_number, course_title, semester_hours,
    CASE
        WHEN fall = 't'
        THEN 'Fall'
    END
FROM public.cs_courses
WHERE course_number = '403' OR course_number = '370' OR course_number = '358';

INSERT INTO schedule VALUES
('MATH', '332', 'LINEAR ALGEBRA', 3.0, 'Fall'),
('EEGN', '281', 'INTRODUCTION TO ELECTRICAL CIRCUITS, ELECTRONICS AND POWER', '3.0', 'Fall'),
('PAGN', '222', 'ADVANCED WEIGHT TRAINING', '0.5', 'Fall');
/* Step 3: Fix errors */
UPDATE schedule
SET semester = 'Fall'
WHERE semester IS NULL;

UPDATE schedule
SET title = 'DATABASE MANAGEMENT'
WHERE course = '403' AND department = 'CSCI';
/* Step 4: Add more constraints */
ALTER TABLE schedule
ADD CONSTRAINT title_unique UNIQUE(title),
ADD CONSTRAINT credit_range CHECK(credits BETWEEN 0.5 AND 15);
/* Step 5: Create another table */
CREATE TABLE assumed_grades (
    term TEXT,
    year INTEGER,
    department TEXT,
    course TEXT,
    title TEXT,
    grade CHAR(3),
    credits NUMERIC(3,1)
);

ALTER TABLE assumed_grades
ADD FOREIGN KEY (title) REFERENCES schedule(title);
/* Step 6: Add the data */
INSERT INTO assumed_grades (department, course, title, credits, term, year)
SELECT department, course, title, credits, semester, year
FROM schedule;
/* Step 7: Enter grades */
UPDATE assumed_grades
SET grade = 'A'
WHERE course IN ('370','332','222','403');

UPDATE assumed_grades
SET grade = 'B'
WHERE course IN ('358','281');
/* Step 8: cleaning up the table */
ALTER TABLE assumed_grades
RENAME COLUMN term TO semester;
/* Step 9 (Extra Credit): Play */

/* Step 10: Make a new table by copying */
CREATE TABLE transcript AS
SELECT * FROM assumed_grades;

ALTER TABLE transcript
ADD FOREIGN KEY (title) REFERENCES schedule(title);

UPDATE transcript
SET grade = 'A+'
WHERE course = '281';
/* Step 11 (Extra Credit): Re-examining the schema */
