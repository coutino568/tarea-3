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