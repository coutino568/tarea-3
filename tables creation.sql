create table MovieStar (
	id int primary key,
	name varchar(50),
	address varchar (100),
	female boolean,
	birthdate date

);


create table MovieExec (
	executive_id int primary key,
	name varchar(50),
	address varchar(100),
	networth float
) ;

create table Studio (
	id int primary key,
	name varchar(50),
	address varchar(100),
	president_executive_id int,
	constraint ref_Studio_MovieExec foreign key (president_executive_id) references MovieExec(executive_id)
);


------------
insert into movieStar values (1,'Alice', 'Generic address',true,'01-08-1995'),
(2,'Sally', 'Generic address',true,'01-08-1995'),
(3,'Monica', 'Generic address ',true,'01-08-1994'),
(4,'Bruce', 'Generic address ',false,'01-08-1995'),
(5,'Sam', 'Generic address ',true,'01-08-1995');



insert into movieexec values (1,'Sam','Generic addess',100050),
(2,'Monica','Generic addess',1000),
(3,'Raul','Generic addess',10005550),
(4,'Peter','Generic addess',10050550),
(5,'Sally','Generic addess',10555050),
(6,'Alice','Generic addess',1000660);


insert into studio values (1,'Studio 1','Generic address',3),
(2,'Studio 2','Generic address',2),
(3,'Studio 3','Generic address',1),
(4,'Studio 4','Generic address',4)







---- vista 1

create view RichExec as 
select * from movieExec
where networth > 10000000



---vista 2

create view StudioPress as 
select executive_id, e.name, e.address,e.networth
from movieExec e
join Studio s
on s.president_executive_id = e.executive_id


-- vista 3

create view ExecutiveStar as 
select executive_id, id as movieStar_ID, m.name , m.address, networth,birthdate, female from (
	select executive_id, e.name, e.address,e.networth
	from movieExec e
	join Studio s
	on s.president_executive_id = e.executive_id ) sub1
join movieStar m
on m.name = sub1.name

-------------
----parte ii

--pregunta 1 :
select sub1.name from (
	select * from movieexec e 
	where networth>10000) sub1
join ExecutiveStar s
on s.executive_id = sub1.executive_id

-- pregunta 2 :

select p.name from StudioPress p
join executiveStar s
on s.executive_id = p.executive_id
where p.networth > 50000

-------------EJERCICIO 2


create table product (
	id int primary key,
	model varchar(50),
	maker varchar(50),
	type varchar(50)
) ;
create table pc (
	id int primary key,
	model varchar(50),
	speed float,
	ram float,
	hd float,
	price float

) ;


insert into pc values
(1,'Model 1',3000,8000,1024,3000),
(2,'Model 2',3000,8000,516,1600),
(3,'Model 3',3000,8000,516,1800),
(4,'Model 4',2500,16000,1024,2500),
(5,'Model 5',2500,8000,1024,2500),
(6,'Model 6',2500,8000,1024,4000) ;

insert into product values
(1,'Model 1','Maker 1' , 'PC'),
(2,'Model 2','Maker 3','PRINTER'),
(3,'Model 3','Maker 3','LAPTOP'),
(4,'Model 4','Maker 4','LAPTOP'),
(5,'Model 5','Maker 2','PC'),
(6,'Model 6','Maker 2','PC') ;

create view newpc as select maker, pc.model, speed, ram, hd, price
	from product, pc
	where product.model = pc.model and type = 'pc';


------PREGUNTA 1:
--- No, cambios en esta vista no resultarian en cambios en las tbalas base.



--PREGUNTA 2: 
drop trigger t_insert_into_pc_too on newpc ;

CREATE OR REPLACE FUNCTION insert_into_pc_too()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
declare latest numeric;
BEGIN
	select id into latest from pc order by id desc limit 1;
    insert into pc values (latest+1,new.model,new.speed,new.ram,new.hd,new.price);
	insert into product values (latest+1, new.model , new.maker, 'pc');
    RETURN NEW;
END;
$$
;


CREATE TRIGGER t_insert_into_pc_too
INSTEAD OF INSERT ON newpc
FOR EACH ROW
EXECUTE PROCEDURE insert_into_pc_too();


insert into newpc (maker,model,speed,ram,hd,price)values('maker 1','new model',3500,8000,1024,1555) ;

----pregunta 3:



drop trigger t_update_into_pc_too on newpc ;

CREATE OR REPLACE FUNCTION update_into_pc_too()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$

BEGIN
	UPDATE pc SET price = new.price WHERE model= new.model;
	RETURN NEW;
END;
$$
;


CREATE TRIGGER t_update_into_pc_too
INSTEAD OF update ON newpc
FOR EACH ROW
EXECUTE PROCEDURE update_into_pc_too();



------ pregunta 4


drop trigger t_delete_from_pc_too on newpc ;

CREATE OR REPLACE FUNCTION t_delete_from_pc_too()
RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$

BEGIN
	delete from pc WHERE model=old.model;
	delete from product WHERE model=old.model;
	RETURN NEW;
END;
$$
;


CREATE TRIGGER t_delete_from_pc_too
INSTEAD OF delete ON newpc
FOR EACH ROW
EXECUTE PROCEDURE t_delete_from_pc_too();