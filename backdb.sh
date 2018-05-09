#!/bin/bash
#备注：主要实现每天凌晨1点开始备份2个月内的数据

PATH=$PATH:$HOME/bin
#备份目录
BackupPath="/home/mysql/backup"
#备份文件名
BackupFile="dbBackup"$(date +%y%m%d_%H)".sql"

#数据库的用户名、密码
user="root"
passwd="root"

#检查备份目录是否存在
if !(test -d $BackupPath)
   then
      mkdir $BackupPath	
fi

#使用mysql提供的mysqldump备份脚本
/usr/local/mysql/bin/mysqldump -u$user -p$passwd --allow-keywords --default-character-set=utf8 --set-charset -R -A --master-data=2 > "$BackupPath"/"$BackupFile"

#删除2个月前的备份文件
find "$BackupPath" -name "dbBackup*[log,sql]" -type f -mtime +2 -exec rm -rf {} \;

find /home/mysql/backup/ -mtime +7 -name '*[1-9].sql' -exec rm -rf {} \;
find /home/mysql/backup/ -mtime +92 -name '*.sql' -exec rm -rf {} \;

#创建定时任务
crontab -e
0 1 * * * /data/dbdata/backup_mysql.sh





