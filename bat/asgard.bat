@echo off

echo.
echo Starting Coffee (x)-model.coffee
echo.

coffee -cwo ..\.\ ..\gen\

if errorlevel 1 goto error
goto end

:error
pause

:end