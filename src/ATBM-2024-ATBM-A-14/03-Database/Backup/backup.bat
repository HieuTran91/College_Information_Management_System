@echo off 
echo Automatic Backup Oracle 
cd /d "D:\backup" 
SET ORACLE_HOME=D:\21c\dbhomeXE
SET ORACLE_SID=XE
echo ---------------------------------------------------- 
echo ORACLE_HOME : %ORACLE_HOME%
echo ORACLE_SID  : %ORACLE_SID%
echo ---------------------------------------------------- 
%ORACLE_HOME%\BIN\RMAN TARGET / @backup.rman log=backup.log 
