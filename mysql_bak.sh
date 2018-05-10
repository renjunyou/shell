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
#备份包 形成压缩包
$BIN_DIR/mysqldump $DB_NAME $DISPOSE_TABLE > $BAK_DIR/$DISPOSE_TABLE.dump_$DATE.sql
$BIN_DIR/mysqldump $DB_NAME $DISPOSE_TABLE | gzip > $BAK_DIR/$DISPOSE_TABLE.dump_$DATE.sql.gz

$BIN_DIR/mysqldump $DB_NAME $RST_TABLE > $BAK_DIR/$RST_TABLE.dump_$DATE.sql
$BIN_DIR/mysqldump $DB_NAME $RST_TABLE | gzip > $BAK_DIR/$RST_TABLE.dump_$DATE.sql.gz

#定期删除60天的备份包
find $BAK_DIR -name "name_*.sql.gz" -type f -mtime +60 -exec rm {} \; > /dev/null 2>&1

#30天前的指定库表数据删除操作 (当前时间减去30天）
delete_date=`date --date='30 day ago' +%Y-%m-%d`
echo "delete_date=$delete_date"

#删除rst表信息
rst_sql="delete from  $RST_TABLE where update_time <= $delete_date order by update_time;";

echo "rst_sql=$rst_sql"
#ret=$(mysql -u $DB_USER -h ${DB_IP} -p${DB_PASS} $DB_NAME -e "$sql");
ret=$(mysql -h${DB_IP} $DB_NAME -e "$rst_sql");
echo $ret

#删除dispose表信息
dispose_sql="delete from $DISPOSE_TABLE where judge_time <= $delete_date order by judge_time;";
echo "dispose_sql=$dispose_sql"
ret=$(mysql -h${DB_IP} $DB_NAME -e "$dispose_sql");
echo $ret


#1.备份步骤
步骤1：备份Mysql指定数据库中的制定库表。
使用 mysqldump，设定周期30天。

步骤2：对于日期60天前的已备份的文件及压缩包做删除处理。
步骤3：删除库表中在当前日期前30天的数据。（步骤1已经做了备份）。
步骤4：设定定时。
crontab设定。

#2.定时设置：每隔30天的1点进行备份。
[root@mysql_bak]# crontab -e
0 1 */30 * * /home/mysql_bak/mysql_bak.sh > /dev/null 2>&1

重启crontab服务 
service crond restart











