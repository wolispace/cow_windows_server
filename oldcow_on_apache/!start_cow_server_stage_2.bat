:: wait 10 seconds
::PING 1.1.1.1 -n 1 -w 100000 >NUL

::call add_message_server_startup.bat

::call !start_cow_web_server.bat