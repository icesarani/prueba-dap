SELECT
    c.CourseName,
    c.Credits,
    c.Capacity,
    COUNT(e.EnrollmentID) AS CurrentEnrollment,
    ROUND(COUNT(e.EnrollmentID) * 100.0 / c.Capacity, 2) AS EnrollmentPercentage
FROM Courses c
INNER JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName, c.Credits, c.Capacity
HAVING COUNT(e.EnrollmentID) * 100.0 / c.Capacity > 50
ORDER BY EnrollmentPercentage DESC;
