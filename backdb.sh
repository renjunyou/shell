#!/bin/bash
#��ע����Ҫʵ��ÿ���賿1�㿪ʼ����2�����ڵ�����

PATH=$PATH:$HOME/bin
#����Ŀ¼
BackupPath="/home/mysql/backup"
#�����ļ���
BackupFile="dbBackup"$(date +%y%m%d_%H)".sql"

#���ݿ���û���������
user="root"
passwd="root"

#��鱸��Ŀ¼�Ƿ����
if !(test -d $BackupPath)
   then
      mkdir $BackupPath	
fi

#ʹ��mysql�ṩ��mysqldump���ݽű�
/usr/local/mysql/bin/mysqldump -u$user -p$passwd --allow-keywords --default-character-set=utf8 --set-charset -R -A --master-data=2 > "$BackupPath"/"$BackupFile"

#ɾ��2����ǰ�ı����ļ�
find "$BackupPath" -name "dbBackup*[log,sql]" -type f -mtime +2 -exec rm -rf {} \;

find /home/mysql/backup/ -mtime +7 -name '*[1-9].sql' -exec rm -rf {} \;
find /home/mysql/backup/ -mtime +92 -name '*.sql' -exec rm -rf {} \;

#������ʱ����
crontab -e
0 1 * * * /data/dbdata/backup_mysql.sh





