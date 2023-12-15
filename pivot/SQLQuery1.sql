--use master
--drop database MusicCollection
--go

create database MusicCollection
go

use MusicCollection;

create table Discs(
    disc_id int primary key identity(1,1),
    disc_title nvarchar(max) not null,
    artist int not null,
    release_date date not null,
    style nvarchar(max) not null,
    publisher nvarchar(max) not null
);

create table Styles(
    style_id int primary key identity(1,1),
    style_name nvarchar(max) not null
);

create table Artists(
    artist_id int primary key identity(1,1),
    artist_name nvarchar(max) not null
);

create table Publishers(
    publisher_id int primary key identity(1,1),
    publisher_name nvarchar(max) not null,
    country nvarchar(max) not null
);

create table Songs(
    song_id int primary key identity(1,1),
    song_title nvarchar(max) not null,
    disc_title int not null foreign key references Discs(disc_id),
    duration time not null,
    song_style int not null foreign key references Styles(style_id),
    artist int not null foreign key references Artists(artist_id),
);

alter table Discs
add constraint FK_Artist_Disc
foreign key (artist) references Artists(artist_id);

insert into Styles(style_name)
values
    ('Rock'),
    ('Pop'),
    ('Jazz'),
    ('Country');

insert into Artists(artist_name)
values
    ('Artist1'),
    ('Artist2'),
    ('Artist3');

insert into Publishers(publisher_name, country)
values
    ('Publisher1', 'Country1'),
    ('Publisher2', 'Country2'),
    ('Publisher3', 'Country3');

insert into Discs(disc_title, artist, release_date, style, publisher)
values
    ('Album1', 1, '2022-01-01',  'Rock', 'Publisher1'),
    ('Album2', 2, '2022-02-01',  'Pop', 'Publisher2'),
    ('Album3', 1, '2022-03-01',  'Jazz', 'Publisher3'),
    ('Album4', 3, '2022-04-01',  'Country', 'Publisher3');

insert into Songs(song_title, disc_title, duration, song_style, artist)
values
    ('Song1', 1, '00:03:30', 1, 1),
    ('Song2', 1, '00:04:15', 1, 1),
    ('Song3', 2, '00:03:45', 2, 2),
    ('Song4', 2, '00:05:00', 2, 3),
    ('Song5', 3, '00:02:45', 3, 3);



select *
from (
    select style as S
    from Discs
) as src
pivot (
    count(S) for S in ([Rock], [Pop], [Jazz], [Country])
) as pvt;


select *
from (
    select publisher as P
    from Discs
) as src
pivot (
    count(P) for P in ([Publisher1], [Publisher2], [Publisher3])
) as pvt;
