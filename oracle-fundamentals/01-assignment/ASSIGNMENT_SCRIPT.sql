PROMPT =======================================================
PROMPT 1. List the offerings of all courses. 
PROMPT Include in the listing the course code, title, 
PROMPT section code, semester and year.
PROMPT =======================================================

COLUMN COURSE_CODE FORMAT A11 HEADING "COURSE CODE"
COLUMN COURSE_TITLE FORMAT A25 HEADING "COURSE TITLE"
COLUMN SECTION_CODE FORMAT A7 HEADING "SECTION"
COLUMN SEMESTER FORMAT A8 HEADING "SEMESTER"
COLUMN YEAR FORMAT 9999 HEADING "YEAR"

SELECT DISTINCT c.COURSE_CODE, c.COURSE_TITLE, cs.SECTION_CODE, cs.SEMESTER, cs.YEAR
FROM COURSE c
INNER JOIN CLASS_SECTION cs
ON c.COURSE_CODE = cs.COURSE_CODE
ORDER BY c.COURSE_CODE, cs.SECTION_CODE;

PROMPT =========================================================
PROMPT 2. List all teaching faculty by name and the courses 
PROMPT (code and course title) that they teach. Each instructor 
PROMPT course combination should be listed only once.  
PROMPT =========================================================

COLUMN SURNAME FORMAT A10 HEADING "  SURNAME  "
COLUMN FIRSTNAME FORMAT A15 HEADING "   FIRSTNAME   "
COLUMN COURSE_CODE FORMAT A15 HEADING "   COURSE_CO   "
COLUMN COURSE_TITLE FORMAT A25 WORD_WRAPPED HEADING "     COURSE_TITLE     "

-- I removed SKIP 1 to tighten up the table but its a good thing to know to do

BREAK ON SURNAME ON FIRSTNAME

SELECT DISTINCT f.SURNAME, f.FIRSTNAME, c.COURSE_CODE, c.COURSE_TITLE
FROM FACULTY f
INNER JOIN CLASS_SECTION cs
ON f.EMPLOYEE_ID = cs.INSTRUCTOR_ID
INNER JOIN COURSE c
ON cs.COURSE_CODE = c.COURSE_CODE
ORDER BY f.SURNAME, f.FIRSTNAME, c.COURSE_CODE, c.COURSE_TITLE;

PROMPT =======================================================
PROMPT 3. List the name and id of all students registered in 
PROMPT a course in which no mark has yet been issued.    
PROMPT =======================================================

-- not sure why only COURSE_CODE was not fitting even when increasing the A#.
-- manually formatted the heading to force it
-- have to find the null or '' empty space
-- I looked into the datatables and noticed there is no null
-- WHERE TRIM(GRADE) = ' '; would satisfy the question alone without mention of null.
-- it would be proper to include NULL aswell as ' '

COLUMN STUDENT_ID FORMAT A10
COLUMN SURNAME FORMAT A9
COLUMN FIRSTNAME FORMAT A13
COLUMN COURSE_CODE FORMAT A15

SELECT s.STUDENT_ID, s.SURNAME, s.FIRSTNAME, c.COURSE_CODE
FROM STUDENT s
JOIN COURSE_REGISTRATION c
ON s.STUDENT_ID = c.STUDENT_ID
WHERE GRADE IS NULL OR TRIM(GRADE) = ' '
ORDER BY s.STUDENT_ID;

PROMPT ==========================================================
PROMPT 4. The faculty member whose ID is 002300137 is going 
PROMPT away for a year on sabbatical.  The administration wants 
PROMPT to know who can cover any classes that this individual 
PROMPT has expertise in.  List the employee id, name and subject 
PROMPT code for all employees who are qualified to teach a course
PROMPT that 002300137 can teach.  Do not concern yourself with 
PROMPT comparative expertise levels. 
PROMPT ==========================================================

-- You cannot use "" when using numbers, need to use single quotations

COLUMN EMPLOYEE_ID FORMAT A11 HEADING "Employee ID"
COLUMN SURNAME FORMAT A10 HEADING "Last Name"
COLUMN FIRSTNAME FORMAT A12 HEADING "First Name"
COLUMN COURSE_CODE FORMAT A12 HEADING "Course Code"

BREAK ON EMPLOYEE_ID ON SURNAME ON FIRSTNAME

SELECT f.EMPLOYEE_ID, f.SURNAME, f.FIRSTNAME, e.COURSE_CODE
FROM FACULTY f
JOIN EXPERTISE e
ON e.EMPLOYEE_ID = f.EMPLOYEE_ID
WHERE e.COURSE_CODE IN (SELECT COURSE_CODE FROM EXPERTISE WHERE EMPLOYEE_ID = '002300137')
AND f.EMPLOYEE_ID != '002300137'
ORDER BY f.EMPLOYEE_ID;

PROMPT =======================================================
PROMPT 5. List the names and seniority date (date hired) 
PROMPT of all faculty.
PROMPT =======================================================

-- finding where the truncate can be and not be when using RPAD was a struggle...
-- Had to use a trunk and TO_CHAR for SENORITY_DATE to properly format with the RPAD.
-- Otherwise the leading '.' had a lot of space to the right.
-- RTRIM was not removing the space either, nor LTRIM on the DATE.
-- For such a small script, comparable to the previous questions, this took the longest to figure out. 

COLUMN "Employee" FORMAT A25
COLUMN "Hiring Date" FORMAT A11

SELECT RPAD(FIRSTNAME || ' ' || SURNAME, 25, '.') AS "Employee", TO_CHAR(SENIORITY_DATE) AS "Hiring Date"
FROM FACULTY
ORDER BY SENIORITY_DATE;

PROMPT =======================================================
PROMPT 6. Faculty members, excluding deans, must pay 0.7% of 
PROMPT their salary in union dues. List each faculty member, 
PROMPT id and name, and the amount that must be deducted for 
PROMPT dues each month.  Exclude deans from this listing.  
PROMPT Deans, and only deans, do not belong to any unit. 
PROMPT =======================================================

COLUMN NAME FORMAT A20
COLUMN UNION_DUES FORMAT $99,999.99 HEADING "UNION DUES"

SELECT RPAD(f.FIRSTNAME || ' ' || f.SURNAME, 20, '.') AS NAME, ROUND(f.SALARY * 0.007 / 12, 2) AS UNION_DUES
FROM FACULTY F
JOIN ORGANIZATIONAL_UNIT o
ON o.UNIT_SUPERVISOR = f.EMPLOYEE_ID
WHERE o.UNIT_SUPERVISOR IS NOT NULL
ORDER BY f.SURNAME;

PROMPT =======================================================
PROMPT 7. List each faculty member, id and name, and the 
PROMPT number of days that faculty member has been employed 
PROMPT by ICCC.  List those faculty members with the 
PROMPT most seniority first.  
PROMPT =======================================================

-- copied Q5, removed the truncation and TO_CHAR.
-- added the ROUND and SYSDATE logic

-- EMPLOYEE_ID format is left aligned as ##### where _DAYS wasn't
-- which is why I assigned it as TO_CHAR to Axx format

COLUMN FIRSTNAME FORMAT A11 HEADING "First Name"
COLUMN SURNAME FORMAT A10 HEADING "Last Name"
COLUMN EMPLOEE_ID FORMAT 999999999 HEADING "Employee ID"
COLUMN EMPLOYEMENT_DAYS FORMAT A16 HEADING "Employement Days"

SELECT FIRSTNAME, SURNAME, EMPLOYEE_ID, TO_CHAR(ROUND(SYSDATE - SENIORITY_DATE)) as EMPLOYEMENT_DAYS
FROM FACULTY
ORDER BY EMPLOYEMENT_DAYS DESC;

PROMPT =======================================================
PROMPT 8. List the name of the faculty (person or persons) 
PROMPT having the same birthday (month and day)
PROMPT (not birthdate, month, day, and year) as Harry Hilbert. 
PROMPT =======================================================

-- FACULTY TABLE ( FIRSTNAME, SURNAME, BIRTHDATE)

/* Template to use - Very basic setup
Let's build from this and the WHERE clause after FROM
SELECT FIRSTNAME, SURNAME, BIRTHDATE
FROM FACULTY
WHERE [logic]
ORDER BY BIRTHDATE;
*/

-- USE WHERE INSTEAD OF HAVING. HAVING IS USED FOR GROUPINGS OR AGGREGATES SUCH AS SUM AND AVG

COLUMN FIRSTNAME FORMAT A11 HEADING "First Name"
COLUMN SURNAME FORMAT A11 HEADING "Last Name"
COLUMN BIRTHDATE FORMAT A14 HEADING "Date of Birth"

SELECT FIRSTNAME, SURNAME, BIRTHDATE
FROM FACULTY
WHERE TO_CHAR(BIRTHDATE, 'MMDD') = (
    SELECT TO_CHAR(BIRTHDATE, 'MMDD')
    FROM FACULTY
    WHERE FIRSTNAME = 'Harry' AND SURNAME = 'Hilbert'
) 
AND NOT (FIRSTNAME = 'Harry' AND SURNAME = 'Hilbert')
ORDER BY FIRSTNAME;

PROMPT =======================================================
PROMPT 9. What is the average age of all faculty excluding 
PROMPT deans?  Deans do not belong to any unit although they 
PROMPT may manage one. 
PROMPT =======================================================

-- was trying to use AVG(SYSDATE - BIRTHDATE) but came across some issues
-- more research let me find the FLOOR clause
-- You can use a MONTHS_BETWEEN()/12 to put it in years
-- But that will return a table to ages, I still need to AVG them

-- I can use AVG within the FLOOR Clause and remove SURNAME/FIRSTNAME 
-- since they will not work with an AVG in the same SELECT.

-- COLUMN formatting is producing ##### as a age result and not what I want
-- Had to clear the column with "CLEAR COLUMN" to delete any caches
-- the FORMAT 99 CENTER - specifically CENTER is used for characters not numbers

-- Cannot format with COLUMN AVERAGE_AGE FORMAT A15 HEADING "AVERAGE AGE"
-- it goes back to producing ##### - Need to format within the SELECT
-- this actually makes it look cleaner. To center the number output looks
-- like more trouble than it should be. I'll leave it as is.

-- Added TO_CHAR for formating. Without it the output is right aligned, but
-- with TO_CHAR it is left aligned. I then have to add COLUMN Axx formating
-- to improve the format

COLUMN "Average Age" FORMAT A12

SELECT TO_CHAR(FLOOR(AVG(MONTHS_BETWEEN(SYSDATE, BIRTHDATE)/12))) AS "Average Age"
FROM FACULTY
WHERE UNIT IS NOT NULL;

PROMPT =======================================================
PROMPT 10. List each student, id and name, and the overall 
PROMPT (in other words: normal, regular, typical, mean) 2024 
PROMPT grade for that student where the student has taken 2 
PROMPT or more courses in the year 2024. 
PROMPT =======================================================

-- "overall" suggests to me that I'll be using a SUM for GRADE
-- which means it cannot be used in the SELECT with single-group functions

-- question asks for year 2010 but there is no 2010 data in the datatable.
-- ive changed the result to be 2024 so i can see some sort of result

-- removed the BREAK ON formating as it was interfering with the output
-- GROUP BY is pretty much doing the same thing as BREAK ON but more
-- using GROUP BY and clumping the student into lets me us COUNT on
-- the rows rather than specifying the grades

-- TO_CHAR the AVG so I could format left-aligned

COLUMN SURNAME FORMAT A11 HEADING "Last Name"
COLUMN FIRSTNAME FORMAT A11 HEADING "First Name"
COLUMN STUDENT_ID FORMAT A11 HEADING "Student ID"
COLUMN "GPA" FORMAT A6

SELECT s.SURNAME,
       s.FIRSTNAME,
       s.STUDENT_ID,
       TO_CHAR(ROUND(AVG(c.GRADE), 2)) AS "GPA"
FROM STUDENT s
JOIN COURSE_REGISTRATION c
  ON s.STUDENT_ID = c.STUDENT_ID
WHERE c.YEAR = '2024'
GROUP BY s.SURNAME, s.FIRSTNAME, s.STUDENT_ID
HAVING COUNT(*) >= 2
ORDER BY s.SURNAME, s.FIRSTNAME;

PROMPT =======================================================
PROMPT 11. List all faculty members by name and id, and where 
PROMPT appropriate list the course code and level for all
PROMPT courses in which they have expertise.  The output
PROMPT should be similar in appearance to that shown below.  
PROMPT =======================================================

-- FACULTY TABLE | SURNAME, FIRSTNAME, EMPLOYEE_ID
-- EXPERTISE TABLE | EMPLOEE_ID, EXPERTISE_LEVEL

COLUMN SURNAME FORMAT A10 HEADING "Last Name"
COLUMN FIRSTNAME FORMAT A11 HEADING "First Name"
COLUMN COURSE_CODE FORMAT A11 HEADING "Course Code"
COLUMN "Expertise Level" FORMAT A15

BREAK ON EMPLOYEE_ID ON SURNAME ON FIRSTNAME

SELECT f.EMPLOYEE_ID, f.SURNAME, f.FIRSTNAME, e.COURSE_CODE, TO_CHAR(e.EXPERTISE_LEVEL) AS "Expertise Level"
FROM FACULTY f
JOIN EXPERTISE e
ON f.EMPLOYEE_ID = e.EMPLOYEE_ID
ORDER BY f.SURNAME;