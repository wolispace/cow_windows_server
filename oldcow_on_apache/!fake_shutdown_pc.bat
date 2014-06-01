xcopy b:\data\webtools\mysql\data\wolispac_cow\*.*  d:\data\webtools\mysql\data\wolispac_cow /y
xcopy b:\data\webtools\mysql\data\wolispac_cow\*.*  D:\Data\cow_on_a_stick\backup_data\last_known_good /y
call tool_backup_one_mysql.bat localhost wolispac_cow root
copy D:\Data\cow_on_a_stick\backup_data\localhost_wolispac_cow_10.SQL D:\Data\cow_on_a_stick\backup_data\last_known_good\

echo I pretended to shut down because of power failure > D:\shutdown.txt
pause
