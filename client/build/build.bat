@echo off
echo 转到编译目录

e:
cd E:\WWW\work\riatest\framework\build
echo 删除日志目录
del /s /q log.txt error.txt
echo 正在启动ant编译
ant 1>log.txt 2>error.txt
echo.& pause