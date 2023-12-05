--set operations
--UNION, INTERSECT, EXCEPT

--who is both in a band and a solo artist
SELECT name
FROM artist
WHERE type = 'Person'
INTERSECT
SELECT name
FROM group_member;

SELECT name
FROM artist
WHERE type = 'Person'
INTERSECT
SELECT title
FROM album;

SELECT name
FROM artist JOIN album ON name = title;

--EXCEPT, who's just a solo artist ( not in a band also)
SELECT name
FROM artist
WHERE type = 'Person'
EXCEPT
SELECT name
FROM group_member;

SELECT name
FROM group_member
EXCEPT
SELECT name
FROM artist
WHERE type = 'Person';

-- with
WITH atwood_books AS 
(SELECT *
    FROM bookstore_inventory
    WHERE author = 'Margaret Atwood')
SELECT COUNT (*)
FROM atwood_books;