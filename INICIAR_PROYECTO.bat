@echo off
title BookHub - Sistema de Gestion de Biblioteca
color 0b
cls

echo =======================================================================
echo          BOOKHUB - SISTEMA DE GESTION DE BIBLIOTECA UNIVERSITARIA
echo =======================================================================
echo.
echo [1/2] Iniciando servidor web local...
echo.

:: Iniciar servidor en segundo plano
start "" /b node server.js

:: Esperar 2 segundos para asegurar inicio
timeout /t 2 /nobreak >nul

echo [2/2] Abriendo BookHub en tu navegador predeterminado...
start http://localhost:8080/

echo.
echo =======================================================================
echo  EL SISTEMA ESTA ACTIVO EN: http://localhost:8080/
echo =======================================================================
echo.
echo  CREDENTIALS DE ACCESO:
echo    - Administrador : admin@bookhub.edu  /  admin123
echo    - Estudiante    : juan.perez@bookhub.edu  /  user123
echo    - Docente       : roberto.fernandez@bookhub.edu  /  doc123
echo.
echo  Presiona cualquier tecla para detener el servidor y cerrar.
echo =======================================================================
pause >nul

:: Detener proceso node al cerrar
taskkill /f /im node.exe >nul 2>&1
exit
