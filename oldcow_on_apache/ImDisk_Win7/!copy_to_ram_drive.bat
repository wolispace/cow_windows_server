mkdir b:\Data
mkdir b:\Data\sticks
mkdir b:\Data\sticks\cow_on_apache

xcopy cow_on_apache b:\Data\sticks\cow_on_apache\  /y/s/e
xcopy d:\Data\sticks\cow_on_apache b:\Data\sticks\cow_on_apache\  /y/s/e 

start B:\Data\sticks\cow_on_apache\apache2\bin\httpd1.exe

start B:\Data\sticks\cow_on_apache\mysql\bin\mysqld-nt.exe --skip-innodb
pause
