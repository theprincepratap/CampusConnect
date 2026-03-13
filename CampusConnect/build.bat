@echo off
REM ============================================
REM CampusConnect Build Script for Windows
REM ============================================

echo.
echo ========================================
echo   CampusConnect Build Script
echo ========================================
echo.

REM Set paths (modify these according to your setup)
set JAVA_HOME=C:\Program Files\Java\jdk-25.0.2
set TOMCAT_HOME=d:\VIT - PROJECT\CompusConnect\apache-tomcat-9.0.96
set PROJECT_HOME=%~dp0

set WEBAPPS=%TOMCAT_HOME%\webapps\CampusConnect

REM Create output directories
echo Creating output directories...
if not exist "%PROJECT_HOME%build\classes" mkdir "%PROJECT_HOME%build\classes"
if not exist "%WEBAPPS%\WEB-INF\classes" mkdir "%WEBAPPS%\WEB-INF\classes"
if not exist "%WEBAPPS%\WEB-INF\lib" mkdir "%WEBAPPS%\WEB-INF\lib"

REM Check for required JAR files
echo.
echo Checking for required JAR files in lib folder...
if not exist "%PROJECT_HOME%lib" (
    echo ERROR: lib folder not found!
    goto :error
)

REM Compile Java files
echo.
echo Compiling Java source files...
cd /d "%PROJECT_HOME%src\main\java"

"%JAVA_HOME%\bin\javac" -cp "%PROJECT_HOME%lib\*" -d "%PROJECT_HOME%build\classes" ^
    model\User.java ^
    model\Message.java ^
    model\UserProfile.java ^
    model\UserPhoto.java ^
    model\Conversation.java ^
    dao\DBConnection.java ^
    dao\UserDAO.java ^
    dao\MessageDAO.java ^
    dao\ProfileDAO.java ^
    dao\PhotoDAO.java ^
    controller\LoginServlet.java ^
    controller\RegisterServlet.java ^
    controller\DashboardServlet.java ^
    controller\ProfileServlet.java ^
    controller\LogoutServlet.java ^
    controller\SendMessageServlet.java ^
    controller\GetMessagesServlet.java ^
    controller\ConversationsServlet.java ^
    controller\UnreadCountServlet.java ^
    controller\ViewProfileServlet.java ^
    controller\UploadPhotoServlet.java

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Compilation failed!
    goto :error
)

echo Compilation successful!

REM Deploy directly to Tomcat webapps
echo.
echo Deploying to Tomcat webapps...

REM Copy compiled classes
xcopy /s /y /q "%PROJECT_HOME%build\classes\*" "%WEBAPPS%\WEB-INF\classes\"

REM Copy JSP files
xcopy /y /q "%PROJECT_HOME%src\main\webapp\*.jsp" "%WEBAPPS%\"

REM Copy CSS folder
xcopy /s /y /i /q "%PROJECT_HOME%src\main\webapp\css" "%WEBAPPS%\css"

REM Copy JS folder
xcopy /s /y /i /q "%PROJECT_HOME%src\main\webapp\js" "%WEBAPPS%\js"

REM Copy images/uploads if they exist
if exist "%PROJECT_HOME%src\main\webapp\images" xcopy /s /y /i /q "%PROJECT_HOME%src\main\webapp\images" "%WEBAPPS%\images"

REM Copy web.xml
copy /y "%PROJECT_HOME%src\main\webapp\WEB-INF\web.xml" "%WEBAPPS%\WEB-INF\" >nul

REM Copy required JARs
copy /y "%PROJECT_HOME%lib\jstl*.jar" "%WEBAPPS%\WEB-INF\lib\" >nul
copy /y "%PROJECT_HOME%lib\postgresql*.jar" "%WEBAPPS%\WEB-INF\lib\" >nul
copy /y "%PROJECT_HOME%lib\mysql-connector*.jar" "%WEBAPPS%\WEB-INF\lib\" >nul 2>nul

echo.
echo ========================================
echo   Build + Deploy completed successfully!
echo ========================================
echo.
echo App running at: http://localhost:8081/CampusConnect/
echo.

goto :end

:error
echo.
echo ========================================
echo   Build failed with errors!
echo ========================================
echo.

:end
cd /d "%PROJECT_HOME%"
pause
