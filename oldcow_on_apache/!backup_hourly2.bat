cd \data\sticks\cow_on_apache
call !backup_from_b_as_zip.bat

cd \data\sticks\cow_on_apache

call !backup_zip_to_other.bat

cd \data\cow_backups\hourly

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


exit

