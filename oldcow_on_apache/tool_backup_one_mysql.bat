::@echo off
:: Created 20040129 by Wallace Mcgee

echo Rolling off 11th backup - we only keep current 10

if !%3==! goto SYNTAX

:: change into the backup folder to do the rolling off..
cd \data\cow_backups
echo Creating %1_%2_10.SQL

if exist %1_%2_01.SQL del %1_%2_01.SQL
if exist %1_%2_02.SQL ren %1_%2_02.SQL %1_%2_01.SQL
if exist %1_%2_03.SQL ren %1_%2_03.SQL %1_%2_02.SQL
if exist %1_%2_04.SQL ren %1_%2_04.SQL %1_%2_03.SQL
if exist %1_%2_05.SQL ren %1_%2_05.SQL %1_%2_04.SQL
if exist %1_%2_06.SQL ren %1_%2_06.SQL %1_%2_05.SQL
if exist %1_%2_07.SQL ren %1_%2_07.SQL %1_%2_06.SQL
if exist %1_%2_08.SQL ren %1_%2_08.SQL %1_%2_07.SQL
if exist %1_%2_09.SQL ren %1_%2_09.SQL %1_%2_08.SQL
if exist %1_%2_10.SQL ren %1_%2_10.SQL %1_%2_09.SQL
cd ..

echo Performing backup..
if !%4==! goto NOPW
D:\data\sticks\cow_on_apache\mysql\bin\mySQLdump -h %1 -u %3 -p%4 --opt %2 >d:\data\cow_backups\%1_%2_10.SQL

goto END
:NOPW
::mySQLdump -h %1 -u %3 --opt %2 >backup_data\%1_%2_10.SQL
::mySQLdump -h %1 -u %3 --add-drop-table --opt %2 >backup_data\%1_%2_10.SQL
D:\data\sticks\cow_on_apache\mysql\bin\mySQLdump -h %1 -u %3 --add-drop-table %2 >d:\data\cow_backups\%1_%2_10.SQL

goto END

:SYNTAX
echo 1 = server    dev1      or mysql01.internode.on.net
echo 2 = database  dev_yacsa or F153207
echo 3 = user      root      or F153207
echo 4 = password (optional)

:END
echo Finished.


