@echo off
REM ============================================
REM Quick Deploy - Frontend files only
REM Use this after changing JSP, CSS, or JS files
REM NO server restart needed!
REM ============================================

set WEBAPPS=d:\VIT - PROJECT\CompusConnect\apache-tomcat-9.0.96\webapps\CampusConnect
set SRC=d:\VIT - PROJECT\CompusConnect\CampusConnect\src\main\webapp

echo Deploying static files...

xcopy /y /q "%SRC%\*.jsp" "%WEBAPPS%\"
xcopy /s /y /q "%SRC%\css\*" "%WEBAPPS%\css\"
xcopy /s /y /q "%SRC%\js\*" "%WEBAPPS%\js\"

echo Done! Changes are live at http://localhost:8081/CampusConnect/
