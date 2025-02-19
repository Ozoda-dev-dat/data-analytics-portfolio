-- PostgreSQL'da ma'lumotlarni chiqarish (extraction) va manipulyatsiya qilish loyihasi

-- 1. Talabalar ma'lumotlarini o'z ichiga olgan jadval yaratamiz
drop table if exists students;
create table students (
    id serial primary key,
    full_name varchar(100),
    gpa numeric(3,2),
    attendance_percent numeric(5,2),
    startup_project boolean
);

-- 2. Test ma'lumotlarni kiritamiz
insert into students (full_name, gpa, attendance_percent, startup_project) values
('Ali Valiyev', 3.8, 95.5, true),
('Dilnoza Karimova', 3.2, 88.0, false),
('Bahrom Ergashev', 3.9, 97.0, true),
('Shahzoda Nazarova', 2.8, 75.4, false),
('Javohir Rahmonov', 3.5, 92.3, true);

-- 3. GPA, davomat va startup loyihalariga asoslanib grantga loyiq talabalarni aniqlash
select * from students
where gpa >= 3.5 and attendance_percent >= 90 and startup_project = true;

-- 4. Talabalar o'rtacha GPA ni hisoblash
select avg(gpa) as average_gpa from students;

-- 5. Har bir talabaning grant olish ehtimolini foizda hisoblash
select full_name,
       gpa,
       attendance_percent,
       case 
           when gpa >= 3.5 and attendance_percent >= 90 and startup_project = true then 'High'
           when gpa >= 3.0 and attendance_percent >= 85 then 'Medium'
           else 'Low'
       end as grant_probability
from students;

-- 6. Talabalarning grant olish ehtimolini yuqori darajadan pastgacha saralash
select full_name, gpa, attendance_percent, startup_project,
       case 
           when gpa >= 3.5 and attendance_percent >= 90 and startup_project = true then 'High'
           when gpa >= 3.0 and attendance_percent >= 85 then 'Medium'
           else 'Low'
       end as grant_probability
from students
order by grant_probability desc, gpa desc, attendance_percent desc;
