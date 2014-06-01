d:\utilities\wget\wget.exe localhost/cgi-bin/cow.pl?m=cleanup --tries=1 --spider --timeout=5

cd \data\cow_backups

if exist cow_b_backup_01.zip del cow_b_backup_01.zip
if exist cow_b_backup_02.zip ren cow_b_backup_02.zip cow_b_backup_01.zip
if exist cow_b_backup_03.zip ren cow_b_backup_03.zip cow_b_backup_02.zip
if exist cow_b_backup_04.zip ren cow_b_backup_04.zip cow_b_backup_03.zip
if exist cow_b_backup_05.zip ren cow_b_backup_05.zip cow_b_backup_04.zip
if exist cow_b_backup_06.zip ren cow_b_backup_06.zip cow_b_backup_05.zip
if exist cow_b_backup_07.zip ren cow_b_backup_07.zip cow_b_backup_06.zip
if exist cow_b_backup_08.zip ren cow_b_backup_08.zip cow_b_backup_07.zip
if exist cow_b_backup_09.zip ren cow_b_backup_09.zip cow_b_backup_08.zip
if exist cow_b_backup_10.zip ren cow_b_backup_10.zip cow_b_backup_09.zip

D:\Data\Sticks\cow_on_apache\IZArc\IZARCC.exe -a -r -P .\cow_b_backup_10.zip b:\data\sticks\cow_on_apache

if exist cow_sql_01.zip del cow_sql_01.zip
if exist cow_sql_02.zip ren cow_sql_02.zip cow_sql_01.zip
if exist cow_sql_03.zip ren cow_sql_03.zip cow_sql_02.zip
if exist cow_sql_04.zip ren cow_sql_04.zip cow_sql_03.zip
if exist cow_sql_05.zip ren cow_sql_05.zip cow_sql_04.zip
if exist cow_sql_06.zip ren cow_sql_06.zip cow_sql_05.zip
if exist cow_sql_07.zip ren cow_sql_07.zip cow_sql_06.zip
if exist cow_sql_08.zip ren cow_sql_08.zip cow_sql_07.zip
if exist cow_sql_09.zip ren cow_sql_09.zip cow_sql_08.zip
if exist cow_sql_10.zip ren cow_sql_10.zip cow_sql_09.zip

D:\Data\Sticks\cow_on_apache\IZArc\IZARCC.exe -a .\cow_sql_10.zip .\localhost_wolispac_cow_10.SQL


