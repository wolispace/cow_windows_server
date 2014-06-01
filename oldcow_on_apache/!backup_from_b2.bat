
:: stop any previous cmds..
:: mysql\bin\pskill.exe -t cmd

wget\wget.exe --spider -t1 http://localhost/cgi-bin/cow.pl?m=cleanup

wget\wget.exe --spider -t1 http://localhost/cgi-bin/mysql_check_tables.pl


call tool_flush_tables.bat
xcopy b:\Data\sticks\cow_on_apache\mysql\data\wolispac_cow\*.*  d:\data\sticks\cow_on_apache\mysql\data\wolispac_cow /y
:: xcopy b:\website\josh\*.* d:\data\sticks\cow_on_a_ram\website\josh /y/S/E

call tool_backup_one_mysql.bat localhost wolispac_cow root

cd \data\sticks\cow_on_apache\

call !update_ip_address.bat

del cow.pl@*
wget\wget.exe -t1 http://localhost/cgi-bin/cow.pl?m=cmdr

::PING 1.1.1.1 -n 1 -w 6000 >NUL
if not exist "cow.pl@m=cmdr" call !start_cow_web_server.bat
del cow.pl@*

exit


