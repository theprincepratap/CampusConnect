@echo off
REM ============================================
REM Quick Deploy - Java files (recompile + deploy)
REM Use this after changing .java files
REM Tomcat auto-reloads - no full restart!
REM ============================================

set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
set TOMCAT_HOME=d:\VIT - PROJECT\CompusConnect\apache-tomcat-9.0.96
set PROJECT_HOME=%~dp0
set WEBAPPS=%TOMCAT_HOME%\webapps\CampusConnect

echo Compiling Java files...

cd /d "%PROJECT_HOME%src\main\java"
"%JAVA_HOME%\bin\javac" -cp "%PROJECT_HOME%lib\*" -d "%PROJECT_HOME%build\classes" ^
    model\User.java ^
    dao\DBConnection.java ^
    dao\UserDAO.java ^
    controller\LoginServlet.java ^
    controller\RegisterServlet.java ^
    controller\DashboardServlet.java ^
    controller\ProfileServlet.java ^
    controller\LogoutServlet.java

if %ERRORLEVEL% neq 0 (
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo Deploying classes...
xcopy /s /y /q "%PROJECT_HOME%build\classes\*" "%WEBAPPS%\WEB-INF\classes\"

echo Deploying static files...
xcopy /y /q "%PROJECT_HOME%src\main\webapp\*.jsp" "%WEBAPPS%\"
xcopy /s /y /q "%PROJECT_HOME%src\main\webapp\css\*" "%WEBAPPS%\css\"
xcopy /s /y /q "%PROJECT_HOME%src\main\webapp\js\*" "%WEBAPPS%\js\"

echo.
echo Done! Tomcat is auto-reloading the app...
echo Visit: http://localhost:8081/CampusConnect/
