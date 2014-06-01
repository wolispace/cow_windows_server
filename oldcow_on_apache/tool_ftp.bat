:: nationalegend.com nationb3 essex28 \data\cow_backups\cow_b_backup_10.zip public_html/creativeobjectworld/backups/cow_b_backup_10.zip
:: NOT FUNCTIONAL - problem with passing a password.

echo open %1>flipit.ftp        
echo %2>>flipit.ftp            
echo %3>>flipit.ftp 
echo hash>>flipit.ftp           
echo put %4 %5>>flipit.ftp     
echo bye>>flipit.ftp
ftp.exe -s:flipit.ftp 
pause