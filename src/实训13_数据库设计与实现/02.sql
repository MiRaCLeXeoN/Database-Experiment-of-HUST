请给出ER图文件存放的URL:
https://raw.githubusercontent.com/MiRaCLeXeoN/Database-Experiment-of-HUST/main/Challenge_13/ersolution.jpg

以下给出关系模式：
电影:
movie(movie_ID, title, type, runtime, release_date, director, starring),primary key:(movie_ID);

顾客:
customer(c_ID, name, phone),primary key:(c_ID);

放映厅:
hall(hall_ID, mode, capacity, location),primary key:(hall_ID);

排场:
schedule(schedule_ID, date, time, price, number, movie_ID, hall_ID),primary key:(schedule_ID),foreign key:(movie_ID, hall_ID);

电影票:
ticket(ticket_ID, seat_num, c_ID, schedule_ID),primary key:(ticket_ID),foreign key:(c_ID, schedule_ID);






