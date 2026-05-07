# Jenkins2_Task4_sqldumpONappserver_CopytoStorageServer
1. Configure SSH credential on Jenkins UI by installing plugins 
2. Configure SSH Host from system-> SSH Remote Host 
3. As we are executing command from Appserver1 ,In build Step choose Execute shell script on remote host using ssh,choose site as Appserver1
4. We have to copy sql dump from appserver to storage server hence do passwordless ssh from appserver to storage server 
5. Add below lines 
```bash
mysqldump -u kodekloud_roy -pasdfgdsd kodekloud_db01 > db_$(date +%F).sql
scp -o StrictHostKeyChecking=no db_$(date +%F).sql natasha@ststor01:/home/natasha/db_backups
```
# Jenkins2_Task5_Copy_httpd_logs
same as task4 
```bash
scp /var/log/httpd/* natasha@ststor01:/usr/src/sysops
```
