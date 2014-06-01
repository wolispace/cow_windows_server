

cd ..\..\cow_backups\daily

if exist *_01.* del *_01.*
if exist *_02.* ren *_02.* *_01.*
if exist *_03.* ren *_03.* *_02.*
if exist *_04.* ren *_04.* *_03.*
if exist *_05.* ren *_05.* *_04.*
if exist *_06.* ren *_06.* *_05.*
if exist *_07.* ren *_07.* *_06.*
if exist *_08.* ren *_08.* *_07.*
if exist *_09.* ren *_09.* *_08.*
if exist *_10.* ren *_10.* *_09.*

copy ..\*_10.* .\*_10.*

ftp.exe -s:D:\Data\Sticks\cow_on_apache\tool_cow_backup_to_ftp.txt

exit