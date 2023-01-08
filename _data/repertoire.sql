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
.import compositions.tsv composition
.import concerts.tsv concert
.import programs.tsv program

CREATE TABLE repertoire AS
SELECT 
   category.name AS category, 
   composition.key, 
   composition.composer, 
   composition.title,
   composition.catalog,
   concert.iso_date,
   concert.path
FROM 
   category,
   composition,
   concert,
   program
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
