@echo off
echo ת������Ŀ¼

e:
cd E:\WWW\work\riatest\framework\build
echo ɾ����־Ŀ¼
del /s /q log.txt error.txt
echo ��������ant����
ant 1>log.txt 2>error.txt
echo.& pause