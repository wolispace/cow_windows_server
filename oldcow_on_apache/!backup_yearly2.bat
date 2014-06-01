cd \data\cow_backups\yearly

if exist *_01.zip del *_01.zip
if exist *_02.zip ren *_02.zip *_01.zip
if exist *_03.zip ren *_03.zip *_02.zip
if exist *_04.zip ren *_04.zip *_03.zip
if exist *_05.zip ren *_05.zip *_04.zip
if exist *_06.zip ren *_06.zip *_05.zip
if exist *_07.zip ren *_07.zip *_06.zip
if exist *_08.zip ren *_08.zip *_07.zip
if exist *_09.zip ren *_09.zip *_08.zip
if exist *_10.zip ren *_10.zip *_09.zip

copy ..\*_10.zip .\*_10.zip

exit