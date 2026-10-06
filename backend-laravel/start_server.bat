@echo off
echo =======================================================
echo   VixionMods Studio API Server - Powered by Laragon
echo =======================================================
echo.
echo Server REST API berjalan di: http://127.0.0.1:8000/api/spareparts
echo Tekan Ctrl+C untuk menghentikan server.
echo.

"D:\Users\Project\laragon\bin\php\php-8.3.33-Win32-vs16-x64\php.exe" -S 127.0.0.1:8000 -t public public/index.php
