-- (1)

SELECT starttime FROM cd.bookings b
JOIN cd.members m
ON m.memid = b.memid
WHERE m.firstname = 'David'
AND m.surname = 'Farrell'


-- (2) How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT b.starttime, f.name
FROM cd.bookings b
JOIN cd.facilities f
ON b.facid = f.facid
WHERE b.starttime >= '2012-09-21' AND b.starttime<'2012-09-22'
AND f.name LIKE 'Tennis Court%'
ORDER BY b.starttime

-- (3) How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

SELECT DISTINCT m2.firstname, m2.surname
FROM cd.members m1 
JOIN cd.members m2
ON m1.recommendedby = m2.memid
ORDER BY m2.surname, m2.firstname

-- (4) How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

SELECT m1.firstname AS memfname, m1.surname AS memsname, 
		m2.firstname AS recfname, m2.surname AS recsname
FROM cd.members m1 
LEFT JOIN cd.members m2
ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname

-- (5) How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name followed by the facility name.

SELECT DISTINCT CONCAT (m.firstname, ' ', m.surname) AS member, f.name AS facility
FROM cd.members m 
JOIN cd.bookings b
ON m.memid = b.memid
JOIN cd.facilities f
ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
ORDER BY member, f.name

-- (5) Alternate Solution

select distinct mems.firstname || ' ' || mems.surname as member, facs.name as facility
	from 
		cd.members mems
		inner join cd.bookings bks
			on mems.memid = bks.memid
		inner join cd.facilities facs
			on bks.facid = facs.facid
	where
		facs.name in ('Tennis Court 2','Tennis Court 1')
order by member, facility 

-- (6) How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.

SELECT CONCAT(m.firstname, ' ', m.surname) AS member,
		f.name AS facility,
		CASE
			WHEN m.memid = 0 THEN f.guestcost*b.slots
			ELSE f.membercost*b.slots
		END as cost
FROM cd.members m 
JOIN cd.bookings b
ON m.memid = b.memid
JOIN cd.facilities f
ON b.facid = f.facid
WHERE 
((m.memid = 0 and b.slots*f.guestcost > 30) or
			(m.memid != 0 and b.slots*f.membercost > 30))
AND b.starttime >= '2012-09-14' AND b.starttime < '2012-09-15'
ORDER BY cost DESC
