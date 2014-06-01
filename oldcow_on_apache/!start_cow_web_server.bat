:: stop web server
::mysql\bin\pskill.exe cmd
mysql\bin\pskill.exe -t abyssws


call add_message_server_startup.bat

:: wait 10 seconds
:: PING 1.1.1.1 -n 1 -w 3000 >NUL

:: start web server
b:
cd abyss
start abyssws.exe
