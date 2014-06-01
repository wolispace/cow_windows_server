call add_message_server_shutdown.bat

xcopy b:\mysql\data\wolispac_cow\*.*  d:\data\sticks\cow_on_a_ram\mysql\data\wolispac_cow /y
echo I had to shut down > D:\shutdown.txt

D:\Utilities\wizmo.exe quiet shutdown

"D:\Utilities\wizmo\wizmo.exe" quiet shutdown