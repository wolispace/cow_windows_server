subst d: c:\drive_d

if exist d:\shutdown.txt del d:\shutdown.txt

call D:\Data\sticks\cow_on_a_ram\!roll_abyss_logs.bat

:: if exist d:\roll_abyss.flg call Q:\Data\sticks\cow_on_a_ram\!roll_abyss_logs.bat

d:
cd \data\sticks\cow_on_a_ram

xcopy *.* b: /y/s/e

:: start mysql
start b:\mysql\bin\mysqld-nt.exe --skip-innodb

call add_message_server_startup.bat

call !start_cow_web_server.bat

call D:\Games\Minecraft\Start_Minecraft_server.bat



