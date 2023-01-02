-------------------------------------------------------------------------------
--
--    Derived Data
--
--    Usage: 
--    $ sqlite3 < $CMM_SOURCE/repertoire.sql
--
--    Output:
--    repertoire.tsv
--
-------------------------------------------------------------------------------

.headers on
.mode tabs

.import categories.tsv category
.import concerts.tsv concert
.import patrons.tsv patron
.import programs.tsv program
.import reservations.tsv reservation
.import compositions.tsv composition

CREATE TABLE repertoire AS
SELECT 
   category.name AS category, 
   composition.key, 
   composition.composer, 
   composition.title,
   composition.catalog,
   concert.date,
   concert.path
FROM 
   category,
   concert,
   program,
   composition
WHERE 
   concert.concert = program.concert
   AND program.key = composition.key
   AND composition.category = category.name
ORDER BY 
   category.sequence,
   composition.key
;

.once repertoire.tsv

SELECT * FROM repertoire;

.exit
