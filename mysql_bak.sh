#!/bin/sh
#DATABASE INFO
DB_NAME="ppdb"
DB_USER="root"
DB_PASS="password"
DISPOSE_TABLE="dispose_ticles"
RST_TABLE="match_rst"
DB_IP=100.55.1.129

BIN_DIR="/usr/bin"
BAK_DIR="/home/mysql_bak/data"
DATE=`date +%Y%m%d_%H%M%S`

#mkdir -p $BAK_DIR
#���ݰ� �γ�ѹ����
$BIN_DIR/mysqldump $DB_NAME $DISPOSE_TABLE > $BAK_DIR/$DISPOSE_TABLE.dump_$DATE.sql
$BIN_DIR/mysqldump $DB_NAME $DISPOSE_TABLE | gzip > $BAK_DIR/$DISPOSE_TABLE.dump_$DATE.sql.gz

$BIN_DIR/mysqldump $DB_NAME $RST_TABLE > $BAK_DIR/$RST_TABLE.dump_$DATE.sql
$BIN_DIR/mysqldump $DB_NAME $RST_TABLE | gzip > $BAK_DIR/$RST_TABLE.dump_$DATE.sql.gz

#����ɾ��60��ı��ݰ�
find $BAK_DIR -name "name_*.sql.gz" -type f -mtime +60 -exec rm {} \; > /dev/null 2>&1

#30��ǰ��ָ���������ɾ������ (��ǰʱ���ȥ30�죩
delete_date=`date --date='30 day ago' +%Y-%m-%d`
echo "delete_date=$delete_date"

#ɾ��rst����Ϣ
rst_sql="delete from  $RST_TABLE where update_time <= $delete_date order by update_time;";

echo "rst_sql=$rst_sql"
#ret=$(mysql -u $DB_USER -h ${DB_IP} -p${DB_PASS} $DB_NAME -e "$sql");
ret=$(mysql -h${DB_IP} $DB_NAME -e "$rst_sql");
echo $ret

#ɾ��dispose����Ϣ
dispose_sql="delete from $DISPOSE_TABLE where judge_time <= $delete_date order by judge_time;";
echo "dispose_sql=$dispose_sql"
ret=$(mysql -h${DB_IP} $DB_NAME -e "$dispose_sql");
echo $ret


#1.���ݲ���
����1������Mysqlָ�����ݿ��е��ƶ����
ʹ�� mysqldump���趨����30�졣

����2����������60��ǰ���ѱ��ݵ��ļ���ѹ������ɾ������
����3��ɾ��������ڵ�ǰ����ǰ30������ݡ�������1�Ѿ����˱��ݣ���
����4���趨��ʱ��
crontab�趨��

#2.��ʱ���ã�ÿ��30���1����б��ݡ�
[root@mysql_bak]# crontab -e
0 1 */30 * * /home/mysql_bak/mysql_bak.sh > /dev/null 2>&1

����crontab���� 
service crond restart











