DROP DATABASE IF EXISTS tourism_travel;
CREATE DATABASE tourism_travel;
USE tourism_travel;

-- Crear tablas
CREATE TABLE Destinations (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    MainAttractions TEXT
);

CREATE TABLE TravelPackages (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DestinationID INT,
    Price DECIMAL(10, 2) NOT NULL,
    DurationDays INT NOT NULL,
    Description TEXT,
    Includes VARCHAR(255),
    FOREIGN KEY (DestinationID) REFERENCES Destinations(Id) on delete cascade
);

CREATE TABLE Clients (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);


-- Relación one to many entre alojamientos y destinos

CREATE TABLE Accommodations (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    DestinationID INT,
    Type_accomodation VARCHAR(50) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    PricePerNight DECIMAL(10, 2) NOT NULL,
    Capacity INT NOT NULL,
    Description TEXT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(Id) on delete cascade
);



-- Relación one to one en alojamiento y reservas

CREATE TABLE Reservations (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    PackageID INT,
    AccommodationID INT,
    ReservationDate DATE NOT NULL,
    NumberOfPeople INT NOT NULL,
    NumberOfNights INT not null,
    YearsOfExperience INT not null,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    Paid boolean not null default false,
    FOREIGN KEY (ClientID) REFERENCES Clients(Id) on delete cascade,
    FOREIGN KEY (PackageID) REFERENCES TravelPackages(Id) on delete cascade,
    FOREIGN KEY (AccommodationID) REFERENCES Accommodations(Id) on delete cascade
);

ALTER TABLE Accommodations
ADD ReservationID INT,
ADD CONSTRAINT fk_reservation
FOREIGN KEY (ReservationID) REFERENCES Reservations(Id) on delete cascade;

alter table accommodations 
drop foreign key fk_reservation;

-- Relación one to many entre reservas y guias

CREATE TABLE TourGuides (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Languages VARCHAR(255),
    ReservationID INT,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(Id) on delete cascade
);

-- Relacion many to many en reservas y guias
CREATE TABLE reservations_guides (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    GuideID INT,
    ReservationID INT,
    FOREIGN KEY (GuideID) REFERENCES TourGuides(Id) on delete cascade,
    FOREIGN KEY (ReservationID) REFERENCES Reservations(Id) on delete cascade
);

INSERT INTO Destinations (Name, Country, MainAttractions) VALUES 
('Paris', 'France', 'Eiffel Tower, Louvre Museum, Notre Dame Cathedral'),
('New York', 'USA', 'Statue of Liberty, Central Park, Times Square'),
('Tokyo', 'Japan', 'Mount Fuji, Tokyo Tower, Sensoji Temple'),
('Rome', 'Italy', 'Colosseum, Vatican City, Trevi Fountain'),
('Sydney', 'Australia', 'Sydney Opera House, Bondi Beach, Harbour Bridge'),
('Cairo', 'Egypt', 'Pyramids of Giza, Sphinx, Egyptian Museum'),
('Rio de Janeiro', 'Brazil', 'Christ the Redeemer, Copacabana Beach, Sugarloaf Mountain'),
('Cape Town', 'South Africa', 'Table Mountain, Robben Island, Cape Point'),
('Bangkok', 'Thailand', 'Grand Palace, Wat Arun, Chatuchak Market'),
('London', 'UK', 'Big Ben, London Eye, Buckingham Palace');

-- Insertar datos en TravelPackages
INSERT INTO TravelPackages (Name, DestinationID, Price, DurationDays, Description, Includes) VALUES 
('Paris Highlights', 1, 1200.00, 7, 'Explore the main attractions of Paris', 'Hotel, Breakfast, Tours'),
('New York Explorer', 2, 1500.00, 5, 'Discover the best of New York City', 'Hotel, Breakfast, Tickets'),
('Tokyo Adventure', 3, 1800.00, 10, 'Experience the culture and beauty of Tokyo', 'Hotel, Breakfast, Guide'),
('Rome Historical Tour', 4, 1100.00, 6, 'Visit the ancient landmarks of Rome', 'Hotel, Breakfast, Tours'),
('Sydney Beaches and Sights', 5, 1400.00, 8, 'Enjoy the best of Sydney', 'Hotel, Breakfast, Transfers'),
('Cairo Ancient Wonders', 6, 1000.00, 7, 'See the ancient wonders of Cairo', 'Hotel, Breakfast, Guide'),
('Rio Carnival Special', 7, 2000.00, 7, 'Experience the Rio Carnival', 'Hotel, Breakfast, Event Tickets'),
('Cape Town Adventure', 8, 1300.00, 7, 'Explore the natural beauty of Cape Town', 'Hotel, Breakfast, Tours'),
('Bangkok Cultural Experience', 9, 900.00, 5, 'Immerse in the culture of Bangkok', 'Hotel, Breakfast, Guide'),
('London City Tour', 10, 1100.00, 6, 'Discover the iconic landmarks of London', 'Hotel, Breakfast, Tours');

-- Insertar datos en Clients
INSERT INTO Clients (FirstName, LastName, Email, Phone, Address) VALUES 
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St'),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901', '456 Oak St'),
('Alice', 'Johnson', 'alice.johnson@example.com', '3456789012', '789 Pine St'),
('Bob', 'Brown', 'bob.brown@example.com', '4567890123', '101 Maple St'),
('Charlie', 'Davis', 'charlie.davis@example.com', '5678901234', '202 Birch St'),
('David', 'Wilson', 'david.wilson@example.com', '6789012345', '303 Cedar St'),
('Emily', 'Miller', 'emily.miller@example.com', '7890123456', '404 Spruce St'),
('Frank', 'Taylor', 'frank.taylor@example.com', '8901234567', '505 Elm St'),
('Grace', 'Anderson', 'grace.anderson@example.com', '9012345678', '606 Ash St'),
('Hank', 'Thomas', 'hank.thomas@example.com', '0123456789', '707 Willow St');


INSERT INTO Accommodations (Name, DestinationID, Type_accomodation, Address, PricePerNight, Capacity, Description) VALUES 
('Eiffel Tower Hotel', 1, 'Hotel', '123 Paris St', 150.00, 2, 'Comfortable hotel near the Eiffel Tower'),
('Central Park Hostel', 2, 'Hostel', '456 NY St', 50.00, 4, 'Affordable hostel near Central Park'),
('Mount Fuji Inn', 3, 'Hotel', '789 Tokyo St', 100.00, 2, 'Charming inn with views of Mount Fuji'),
('Colosseum Apartments', 4, 'Apartment', '101 Rome St', 200.00, 4, 'Spacious apartments near the Colosseum'),
('Bondi Beach House', 5, 'Airbnb', '202 Sydney St', 180.00, 6, 'Beautiful house near Bondi Beach'),
('Pyramids Resort', 6, 'Resort', '303 Cairo St', 120.00, 3, 'Luxurious resort near the Pyramids'),
('Copacabana Palace', 7, 'Hotel', '404 Rio St', 160.00, 2, 'Elegant hotel on Copacabana Beach'),
('Table Mountain Lodge', 8, 'Lodge', '505 Cape Town St', 140.00, 4, 'Cozy lodge with views of Table Mountain'),
('Grand Palace Hostel', 9, 'Hostel', '606 Bangkok St', 40.00, 6, 'Budget hostel near the Grand Palace'),
('Big Ben B&B', 10, 'B&B', '707 London St', 130.00, 2, 'Charming bed and breakfast near Big Ben');


-- Insertar datos en Reservations
INSERT INTO Reservations (ClientID, PackageID, AccommodationID, ReservationDate, NumberOfPeople, NumberOfNights, YearsOfExperience, TotalPrice, Status, Paid) VALUES 
(1, 1, 1, '2024-01-01', 2, 5, 5, 2400.00, 'Confirmed', TRUE),
(2, 2, 2, '2024-02-01', 1, 3, 3, 1500.00, 'Confirmed', TRUE),
(3, 3, 3, '2024-03-01', 2, 7, 7, 3600.00, 'Pending', FALSE),
(4, 4, 4, '2024-04-01', 3, 2, 2, 3300.00, 'Cancelled', FALSE),
(5, 5, 5, '2024-05-01', 4, 8, 8, 7200.00, 'Confirmed', TRUE),
(6, 6, 6, '2024-06-01', 1, 6, 6, 1000.00, 'Pending', FALSE),
(7, 7, 7, '2024-07-01', 2, 10, 10, 4000.00, 'Confirmed', TRUE),
(8, 8, 8, '2024-08-01', 2, 4, 4, 2600.00, 'Confirmed', TRUE),
(9, 9, 9, '2024-09-01', 3, 9, 9, 2700.00, 'Pending', FALSE),
(10, 10, 10, '2024-10-01', 1, 5, 5, 1300.00, 'Confirmed', TRUE);

UPDATE Accommodations
SET ReservationID = 1
WHERE Name = 'Eiffel Tower Hotel';

UPDATE Accommodations
SET ReservationID = 2
WHERE Name = 'Central Park Hostel';

UPDATE Accommodations
SET ReservationID = 3
WHERE Name = 'Mount Fuji Inn';

UPDATE Accommodations
SET ReservationID = 4
WHERE Name = 'Colosseum Apartments';

UPDATE Accommodations
SET ReservationID = 5
WHERE Name = 'Bondi Beach House';

UPDATE Accommodations
SET ReservationID = 6
WHERE Name = 'Pyramids Resort';

UPDATE Accommodations
SET ReservationID = 7
WHERE Name = 'Copacabana Palace';

UPDATE Accommodations
SET ReservationID = 8
WHERE Name = 'Table Mountain Lodge';

UPDATE Accommodations
SET ReservationID = 9
WHERE Name = 'Grand Palace Hostel';

UPDATE Accommodations
SET ReservationID = 10
WHERE Name = 'Big Ben B&B';


-- Insertar datos en TourGuides
INSERT INTO TourGuides (FirstName, LastName, Email, Phone, Languages, ReservationID) VALUES 
('Michael', 'Scott', 'michael.scott@example.com', '1231231234', 'English, Spanish', 1),
('Dwight', 'Schrute', 'dwight.schrute@example.com', '2342342345', 'German, English', 2),
('Jim', 'Halpert', 'jim.halpert@example.com', '3453453456', 'English', 3),
('Pam', 'Beesly', 'pam.beesly@example.com', '4564564567', 'English', 4),
('Ryan', 'Howard', 'ryan.howard@example.com', '5675675678', 'English, French', 5),
('Oscar', 'Martinez', 'oscar.martinez@example.com', '6786786789', 'Spanish, English', 6),
('Angela', 'Martin', 'angela.martin@example.com', '7897897890', 'English', 7),
('Kevin', 'Malone', 'kevin.malone@example.com', '8908908901', 'English', 8),
('Toby', 'Flenderson', 'toby.flenderson@example.com', '9019019012', 'English', 9),
('Stanley', 'Hudson', 'stanley.hudson@example.com', '0120120123', 'English', 10);

UPDATE TourGuides
SET Phone = null
WHERE FirstName = 'Oscar';

UPDATE TourGuides
SET Phone = null
WHERE FirstName = 'Stanley';


-- Insertar datos en reservations_guides
INSERT INTO reservations_guides (GuideID, ReservationID) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- BUSQUEDAS NORMALES
-- Seleccionar todos los elementos de una tabla. - Seleccioname todos los clientes

select * from clients;

-- Seleccionar elementos de una tabla con una condición específica. Por ejemplo, que tengan un id = 1 o un id par.Seleccionar elementos de una tabla con una condición específica. Por ejemplo, que tengan un id = 1 o un id par.
-- Seleccioname esos alojamientos que tengan capacidad para más de 4 personas
select * from accommodations a where Capacity > 4;

-- Ordename las reservas por fecha de reserva

select * from reservations r order by ReservationDate asc; 

-- Limitame el numero de buscas de alojamientos, muestrame los 4 más caros

select * from accommodations a order by PricePerNight desc limit 4;

-- Buscar elementos que cumplan con múltiples condiciones usando operadores lógicos.
-- Listame las reservas confirmadas entre el 2024-01-01 y 2024-05-01

select * from reservations r where Status = 'Confirmed' and ReservationDate between '2024-01-01' and '2024-05-01';

-- Buscar elementos que cumplan con condiciones de rango. - Listame las reservas de más de 2 personas

select * from reservations r where NumberOfPeople > 2;

-- Buscar elementos usando patrones (LIKE). -Seleccioname todos los guias que hablen español

select * from tourguides t where Languages like "%Spanish%";

-- Buscar elementos con valores nulos. Listame los guias que tengan el telefono null

select * from tourguides t where Phone is null;

-- Contar el número de elementos que cumplen con una condición. 

select count(*) from accommodations a where Type_accomodation = "hostel"; 


-- BUSQUEDAS COMPLEJAS
-- 1.Realizar consultas con subconsultas. - Sacame el paquete más caro y el nombre del cliente que lo reservó
SELECT 
    t.name AS TravelPackage,
    CONCAT(c.FirstName, ' ', c.LastName) AS Client,
    r.TotalPrice AS ReservationPrice
FROM 
    reservations r
JOIN 
    travelpackages t ON r.PackageID = t.Id
JOIN 
    clients c ON r.ClientID = c.Id
       
WHERE 
    r.TotalPrice = (
        SELECT MAX(r2.TotalPrice)
        FROM reservations r2
    );
   
   
-- 2.Realizar consultas con subconsultas. - Listame las reservas en el hotel Grand Palace Hostel que tengan un guia que hable ingles 
select
r.id as reserva, CONCAT(c.FirstName, ' ', c.LastName) as client, t.name as travelPackage, a.name as accommodation, CONCAT(tg.FirstName, ' ', tg.LastName) as guia, tg.Languages
from reservations r 
join clients c on r.ClientID = c.Id 
join travelpackages t on r.PackageID = t.id
join tourguides tg on r.id = tg.ReservationID
join accommodations a ON r.AccommodationID = a.Id

where 
	a.name = 'Grand Palace Hostel'
	-- a continuación dice y seleccioname los guias que su id este dentro(in) de los resultados de la subconsulta que determinan que hablan ingles
	and tg.id in (
		select tg2.id
		from tourguides tg2
		where tg2.languages like '%english%'
	);


-- 3.Realizar consultas con JOINs entre varias tablas. - Sacame los clientes que tienen contratado el travelpackage en bangokok
select d.name , d.MainAttractions, t.name as name_travelpackage, CONCAT(c.FirstName, ' ', c.LastName) as client_buy_package
from destinations d
join travelpackages t on d.Id = t.DestinationID
join reservations r on r.PackageID = t.Id 
join clients c on r.ClientID = c.Id 
where d.name = 'Bangkok';


-- 4.Realizar consultas con agregaciones (SUM, AVG, MIN, MAX). - Suma todos los precios de las reservas confirmadas hechas entre enero y mayo
select
	t.name as travelpackage, 
	CONCAT(c.FirstName, ' ', c.LastName) as client, 
	r.totalPrice as price, 
	SUM(r.totalPrice) over () as totalPrice_allReservations
from 
	reservations r 
join 
	travelpackages t on t.Id = r.PackageID 
join 
	clients c on c.Id = r.ClientID 
where 
	r.ReservationDate between '2024-01-01' and '2024-05-01' 
and 
	r.Status = 'confirmed';


-- 5.Realizar consultas con agregaciones (SUM, AVG, MIN, MAX). - Calculame la media de los precios de los packages
select price from travelpackages t;
select AVG(t.price) as average_price_packages
from travelpackages t ;


-- 6.Filtrar resultados de grupos (HAVING). - Sacame las reservas ordenadas por la fecha más reciente que tengan un coste más económico que la media de precios de las reservas
select 
	CONCAT(c.FirstName, ' ', c.LastName),
	r.reservationDate as reservation_date,
	r.totalPrice as price
from
	reservations r 
join
	clients c on r.ClientID = c.id
	
group by
	r.id, c.FirstName, c.LastName, r.totalPrice

having
	r.totalPrice < (
		select AVG(r2.totalPrice)
		from reservations r2 
	)
order by
	r.reservationDate;


-- 7.Filtrar resultados de grupos (HAVING). - Sacame el alojamiento que tenga un precio por debajo de la media y tenga más de 3 años de experiencia
select 
	a.name as accommodations,
	a.PricePerNight as price_for_night,
	r.YearsOfExperience 
from 
	accommodations a 
join 
	reservations r on r.Id = a.ReservationID 
	
group by
	a.name, a.PricePerNight, r.YearsOfExperience
having
	a.PricePerNight < (
		select AVG(a2.PricePerNight)
		from accommodations a2 
	)
	and
	r.YearsOfExperience > 3

order by
	a.pricePerNight;


-- 8.Sacame la información de los alojamientos con una media mayor de la capacidad que tienen la mayoria y que tengan reserva confirmadas

select 
	a.name as accommodations,
	a.capacity,
	r.numberOfPeople
from
	accommodations a 
join
	reservations r on a.ReservationID = r.Id 
where a.Capacity >(
	select avg(a2.Capacity)
	from accommodations a2 
) 
and 
	r.Status = 'Confirmed'
order by
	a.Capacity desc;

-- 9.Sacame los destinos más visitados y el precio medio de las resevas

SELECT 
    d.name AS destination,
    COUNT(r.Id) AS visit_count,
    AVG(r.TotalPrice) AS average_price
FROM 
    destinations d
JOIN 
    travelpackages t ON d.Id = t.DestinationID
JOIN 
    reservations r ON t.Id = r.PackageID
GROUP BY 
    d.name
ORDER BY 
    visit_count desc;

-- 10.Sacame el nombre de los alojamientos que son hostel y tengan reservas completadas.

select count(*), 
a.name AS accommodation
from accommodations a 
join reservations r on r.Id = a.ReservationID 
where Type_accomodation = "hostel"
and r.Status = 'Confirmed'
group by a.name;

-- CREACIÓN DE TRIGGERS
-- 1. Creo un trigger para que me calcule el precio total del alojamiento basado en el numero de personas, el precio por noche del alojamiento y el paquete de viaje
-- al hacerse una reserva nueva
DELIMITER //
create trigger calculate_total_price
before insert on reservations
for each row 
begin
	declare price_package DECIMAL (10, 2);
	declare price_accomodation_night DECIMAL (10, 2);
	declare price_accomodation_total DECIMAL (10, 2);
	declare total_price_reservation DECIMAL (10,2);
	select 
		price into price_package
		from travelpackages 
		where id = new.packageID;
	
	select 
		pricePerNight into price_accomodation_night
		from accommodations
		where id = new.AccommodationID;
		
		
	set price_accomodation_total = price_accomodation_night * new.numberofnights;
	
	set total_price_reservation = price_accomodation_total + price_package;

	set new.totalprice = total_price_reservation;		
	
end //

DELIMITER ;



-- 2. Creo un trigger que me cambie el estado de las reservas de pendientes a confirmadas una vez esten pagadas 
DELIMITER //
create trigger change_status_reservations
before insert on reservations
for each row 
begin
	
if 	new.paid = true then
	set new.status = 'Confirmed';
else 
	set new.status = 'Pending';
	
end if;
	
end //

DELIMITER ;

INSERT INTO Reservations (ClientID, PackageID, AccommodationID, ReservationDate, NumberOfPeople, NumberOfNights, YearsOfExperience, TotalPrice, Status, Paid)
VALUES (2, 4, 5, '2024-11-15', 2, 5, 5, 0.00, 'Pending', true);

-- 3 Evento que actualize cada mes las reservas que esten expiradas
-- ver que tengo activado los eventos
SHOW VARIABLES LIKE 'event_scheduler';
-- ver los eventos activos 
show events;

set global event_scheduler = on;

delimiter //

create event change_expired_reservations
on schedule every 1 month 
do
begin
    update reservations 
    set status = 'expired'
    where status <> 'expired'
    and date_add(reservationdate, interval numberofnights day) < curdate(); 	
end //

delimiter ;

-- TRANSACCIÓN 
-- Inserto una nueva reserva, le añado un guia turistico, despues actualizo el precio total con los gastos y cambio el estado a confirmado y pagado

start transaction;

INSERT INTO reservations (clientid, packageid, accommodationid, reservationdate, numberofpeople, numberofnights, yearsofexperience, totalprice, status, paid)
VALUES (1, 1, 1, '2024-08-01', 2, 5, 5, 0.00, 'Pending', FALSE);


set @reservation_id = last_insert_id();

set @price_total = (
	(select a.pricePerNight from accommodations a join reservations r on a.id = r.accommodationid where r.id = @reservation_id)) * 
	(select numberofnights from reservations where id = @reservation_id) + 
	(select t.price from travelpackages t join reservations r on t.id = r.packageid where r.id = @reservation_id);

insert into reservations_guides (guideid, reservationid)
values (2, @reservation_id);

update reservations 
set totalprice = @price_total
where id = @reservation_id;

update reservations 
set status = 'Confirmed'
where id = @reservation_id;

update reservations 
set paid = true 
where id = @reservation_id;

commit;

rollback;

-- FUNCIONES
-- 1.Funcion para calcular cuantas reservas tengo en estado confirmado y cuantas tengo en pendiente
delimiter //

create function calculate_reservation_confirmed() returns int
reads sql data
begin
	declare num_reservation_confirmed int;
	
	select count(*) from reservations where Status = 'Confirmed' into num_reservation_confirmed;
	return num_reservation_confirmed;
end //
delimiter ; 

delimiter //

create function calculate_reservation_pending() returns int
reads sql data
begin
	declare num_reservation_pending int;
	
	select count(*) from reservations where Status = 'Pending' into num_reservation_pending;
	return num_reservation_pending;
end //
delimiter ;

-- 2.Funcion para saber cuantos guias tengo sin clientes a fecha de hoy, ha tenido que ser procedure porque me daba error al devover mas de un dato
delimiter //

create procedure tourguide_without_clients()
begin
    select concat(t.FirstName, ' ', t.LastName) as FullName
    from tourguides t
    left join reservations_guides rg on t.id = rg.guideid
    left join reservations r on rg.reservationid = r.id
    where r.id is null or date(r.reservationdate) < curdate();
end //

delimiter ;

-- call tourguide_without_clients(); Para llamar al procedure

-- 3.Funcion para contar las reservas por un cliente especifico
delimiter //

create function count_client_reservations(client_id int) returns int
reads sql data
begin
	declare reservation_count int;
	
	select count(*) into reservation_count 
	from reservations r 
	where r.ClientID = client_id;

	return reservation_count;
end //
delimiter ;

-- 4.Funcion para saber el alojamiento con más reservas
delimiter //

create function get_accommodation_with_most_reservations() returns int
reads sql data
begin
    declare accommodation_id int;

    select a.id
    into accommodation_id
    from accommodations a
    join reservations r on a.id = r.accommodationid
    group by a.id
    order by count(r.id) desc
    limit 1;

    return accommodation_id;
end //

delimiter ;
		
