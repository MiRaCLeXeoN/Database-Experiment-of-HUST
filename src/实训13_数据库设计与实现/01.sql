-- 请将你实现flight_booking数据库的语句写在下方：

-- drop table if exists prosf;
-- create table prosf(
--     prosf1 smallint primary key,
--     prosf2 smallint
-- );

-- 因为有外键约束, 所以这些得先删掉
drop table if exists ticket;
drop table if exists flight;
drop table if exists flightschedule;
drop table if exists airplane;
drop table if exists airport;
drop table if exists airline;

drop table if exists "user";
create table "user"(
    user_id int primary key,
    -- user_id int auto_increment primary key ,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    dob date not null,
    sex char(1) not null,
    email varchar(50) default '',
    phone varchar(30) default '',
    username varchar(20) not null,
    "password" char(32) not null,
    admin_tag tinyint default(0) not null
    -- 如果default后面那个0不用括号括起来的话, 就只能放在最后, 才不会有语法错误
);
create unique index idx21 on "user"(username);

drop table if exists passenger;
create table passenger (
    passenger_id int primary key ,
    -- passenger_id int auto_increment primary key ,
    id char(18) not null ,
    firstname varchar(50) not null,
    lastname varchar(50) not null,
    mail varchar(50) default '',
    phone varchar(20) not null,
    sex char(1) not null,
    dob timestamp
);
create unique index idx17 on passenger(id);

drop table if exists airport;
create table airport (
    airport_id smallint primary key,
    iata char(3) not null ,
    icao char(4) not null ,
    "name" varchar(50) not null,
    city varchar(50) default '',
    country varchar(50) default '',
    latitude decimal(11, 8) default(0),
    longitude decimal(11, 8) default(0)

    -- constraint con_airport1 unique("name")
);
create unique index idx5 on airport(iata);
create unique index idx6 on airport(icao);
create index idx7 on airport(name);

drop table if exists airline;
create table airline (
    airline_id int primary key,
    "name" varchar(30) not null,
    iata char(2) not null ,

    airport_id smallint not null,

    foreign key(airport_id) references airport(airport_id)
);
create index idx2 on airline(airport_id);
create unique index idx3 on airline(iata);

drop table if exists airplane;
create table airplane (
    airplane_id int primary key,
    type varchar(50) not null,
    capacity smallint not null,
    identifier varchar(50) not null,

    airline_id int not null,

    foreign key(airline_id) references airline(airline_id)
);
create index idx4 on airplane(airline_id);

drop table if exists flightschedule;
create table flightschedule (
    flight_no char(8) primary key,
    departure timestamp not null,
    arrival timestamp not null,
    duration smallint not null,
    monday tinyint default 0,
    tuesday tinyint default 0,
    wednesday tinyint default 0,
    thursday tinyint default 0,
    friday tinyint default 0,
    saturday tinyint default 0,
    sunday tinyint default 0,

    airline_id int not null,
    "from" smallint not null,
    "to" smallint not null,

    foreign key(airline_id) references airline(airline_id),
    foreign key("from") references airport(airport_id),
    foreign key("to") references airport(airport_id)
);
create index idx14 on flightschedule(airline_id);
create index idx15 on flightschedule("from");
create index idx16 on flightschedule("to");

drop table if exists flight;
create table flight (
    flight_id int primary key,
    departure timestamp not null,
    arrivals timestamp not null,
    duration smallint not null,

    airline_id int not null,
    airplane_id int not null,
    flight_no char(8) not null,
    "from" smallint not null,
    "to" smallint not null,

    foreign key(airline_id) references airline(airline_id),
    foreign key(airplane_id) references airplane(airplane_id),
    foreign key(flight_no) references flightschedule(flight_no),
    foreign key("from") references airport(airport_id),
    foreign key("to") references airport(airport_id)
);
create index idx8 on flight(airline_id);
create index idx9 on flight(arrivals);
create index idx10 on flight(departure);
create index idx11 on flight(flight_no);
create index idx12 on flight("from");
create index idx13 on flight("to");

drop table if exists ticket;
create table ticket (
    ticket_id int primary key,
    seat char(4) default '',
    price decimal(10, 2) not null,

    flight_id int not null,
    passenger_id int not null,
    user_id int not null,

    foreign key(flight_id) references flight(flight_id),
    foreign key(passenger_id) references passenger(passenger_id),
    foreign key(user_id) references "user"(user_id)
);
create  index idx18 on ticket(flight_id);
create  index idx19 on ticket(passenger_id);
create  index idx20 on ticket(user_id);
 