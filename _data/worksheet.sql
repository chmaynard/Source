-------------------------------------------------------------------------------
--
--    Derived Data
--
--    Usage: 
--    $ sqlite3 < $CMM_SOURCE/workflow.sql
--
--    Output:
--    worksheet.tsv
--
-------------------------------------------------------------------------------

.headers on
.mode tabs

.import patrons.tsv patron
.import reservations.tsv reservation

CREATE TABLE attendance AS
SELECT 
   reservation.name as name,
   COUNT(*) as count
FROM 
   reservation
WHERE
   reservation.date <= (SELECT MIN(date) FROM reservation WHERE date >= date('now'))
GROUP BY 
   reservation.name
;

.once attendance.tsv
SELECT * FROM attendance;

--

CREATE TABLE worksheet AS
SELECT
   reservation.date,
   reservation.name,
   reservation.role,
   "" as email,
   attendance.count
FROM 
   reservation,
   attendance
WHERE 
   -- reservation.date = (SELECT MIN(date) FROM reservation WHERE date >= date('now'))
   reservation.date >= date('now')
AND
   reservation.name = attendance.name
;

UPDATE worksheet
SET
   email = patron.email
FROM 
   patron
WHERE 
   worksheet.name = patron.name
;

.once worksheet.tsv

SELECT * FROM worksheet ORDER BY date, name;

.exit
