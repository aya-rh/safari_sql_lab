DROP TABLE IF EXISTS assignment;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS animal;
DROP TABLE IF EXISTS enclosure;

CREATE TABLE enclosure (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    capacity INT, 
    closedForMaintenance BOOLEAN
);

CREATE TABLE animal (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(30),
    type VARCHAR(30),
    age INT, 
    enclosure_id INT REFERENCES enclosure(id)
);


INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('birds', 50, false);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('fish', 100, false);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('reptiles', 10, true);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('insects', 150, true);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('large mammals', 5, false);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('wildcats', 10, false);
INSERT INTO enclosure (name, capacity, closedForMaintenance) VALUES ('dinosaurs', 5, true);

INSERT INTO animal (name, type, age, enclosure_id) VALUES ('polly', 'parrot', 7, 1);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('ollie', 'owl', 3, 1);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('simon', 'shark', 13, 2);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('nemo', 'clownfish', 6, 2);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('lizzy', 'lizard', 30, 3);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('colin', 'crocodile', 60, 3);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('ben', 'beetle', 4, 4);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('sally', 'spider', 8, 4);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('ellie', 'elephant', 45, 5);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('winston', 'whale', 100, 5);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('tony', 'tiger', 17, 6);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('lucy', 'lion', 24, 6);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('sarah', 'stegosaurus', 23, 7);
INSERT INTO animal (name, type, age, enclosure_id) VALUES ('tom', 'tyrannosaurus', 23, 7);



CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    employeeNumber INT
);

INSERT INTO employee (name, employeeNumber) VALUES ('Colin', 3876);
INSERT INTO employee (name, employeeNumber) VALUES ('Ed', 8329);
INSERT INTO employee (name, employeeNumber) VALUES ('Richard', 1236);
INSERT INTO employee (name, employeeNumber) VALUES ('Zsolt', 9732);
INSERT INTO employee (name, employeeNumber) VALUES ('Iain', 6937);
INSERT INTO employee (name, employeeNumber) VALUES ('Phil', 2498);
INSERT INTO employee (name, employeeNumber) VALUES ('Eoan', 2347);



CREATE TABLE assignment(
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employee(id),
    enclosure_id INT REFERENCES enclosure(id),
    day VARCHAR(10)
);

INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (4, 7, 'Monday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (6, 6, 'Tuesday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (1, 5, 'Wednesday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (7, 4, 'Thursday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (3, 3, 'Friday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (5, 2, 'Saturday');
INSERT INTO assignment (employee_id, enclosure_id, day) VALUES (2, 1, 'Sunday');




--SOLUTIONS--

---------- MVP -----------

----> 1. The names of animals in a given enclosure ---->
SELECT enclosure.name as enclosure, animal.name from enclosure
inner join animal
on enclosure.id = animal.enclosure_id
where enclosure.name = 'birds';


----> 2. The names of employee working in a given enclosure ---->
SELECT enclosure.name as enclosure, employee.name as employee from enclosure
inner join assignment
on enclosure.id = assignment.enclosure_id
inner join employee
on assignment.employee_id = employee.id
where enclosure.name = 'insects';



--------- EXTENSIONS ------------
----> 3. The names of staff working in enclosures that are closed for maintenance ---->
SELECT enclosure.name as enclosure, enclosure.closedForMaintenance as maintenance, employee.name as employee from enclosure
inner join assignment
on enclosure.id = assignment.enclosure_id
inner join employee
on assignment.employee_id = employee.id
where enclosure.closedForMaintenance = true;


----> 4. The name of the enclosure where the oldest animal lives. If there are two animals who are the same age choose the first one alphabetically ---->
SELECT enclosure.name as enclosure, animal.name, animal.age from enclosure
inner join animal
on enclosure.id = enclosure_id
order by animal.age desc, animal.name limit 1; 


-----> 5. The number of different animal types a given keeper has been assigned to work with ----->
SELECT COUNT(DISTINCT animal.type) 
from employee
inner join assignment 
on employee.id = assignment.employee_id
inner join enclosure 
on assignment.enclosure_id = enclosure.id
inner join animal 
on enclosure.id = animal.enclosure_id
where employee.name = 'Ed'; 


-----> 6. The number of different keepers who have been assigned to work in a given enclosure ------>
SELECT enclosure.name as enclosure, COUNT(DISTINCT employee.name) 
from enclosure
inner join assignment 
on enclosure.id = assignment.enclosure_id
inner join employee 
on assignment.employee_id = employee.id
where enclosure.name = 'birds'
group by enclosure.name; 


------> 7. The names of the other animals sharing an enclosure with a given animal (eg. find the names of all the animals sharing the big cat field with Tony) ------>
SELECT enclosure.name as enclosure, animal.name from enclosure
inner join animal
on enclosure.id = animal.enclosure_id
where enclosure.id IN (SELECT animal.enclosure_id from animal 
where animal.name = 'polly');