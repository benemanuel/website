@echo off
REM Script to create a new blog post (Windows)

if "%~1"=="" (
    echo Usage: new_post.bat "Your Post Title"
    echo Example: new_post.bat "The Architect of the Cage"
    exit /b 1
)

set "TITLE=%~1"

REM Get today's date in YYYY-MM-DD format
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "DATE=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%"

REM Create slug (simple version - lowercase and replace spaces)
set "SLUG=%TITLE: =-%"
set "SLUG=%SLUG:,=%"
set "SLUG=%SLUG:.=%"
set "SLUG=%SLUG:'=%"

REM Convert to lowercase (approximate)
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
    call set "SLUG=%%SLUG:%%L=%%L%%"
)

set "FILENAME=_posts\blog\%DATE%-%SLUG%.md"

if exist "%FILENAME%" (
    echo Error: Post already exists at %FILENAME%
    exit /b 1
)

REM Create the post file
(
echo ---
echo title: %TITLE%
echo created: %DATE%
echo authors:
echo   - avrahambenemanuel
echo ---
echo.
echo # %TITLE%
echo.
echo Write your content here...
echo.
) > "%FILENAME%"

echo ✓ Created new post: %FILENAME%
echo.
echo Next steps:
echo 1. Edit the post: %FILENAME%
echo 2. Rebuild the site: docker-compose down ^&^& docker-compose up -d
echo 3. View at: http://127.0.0.1:4007/%SLUG%
echo.

REM Try to open in editor
if exist "C:\Program Files\Microsoft VS Code\Code.exe" (
    echo Opening in VS Code...
    start "" "C:\Program Files\Microsoft VS Code\Code.exe" "%FILENAME%"
) else if exist "C:\Program Files\Notepad++\notepad++.exe" (
    echo Opening in Notepad++...
    start "" "C:\Program Files\Notepad++\notepad++.exe" "%FILENAME%"
) else (
    echo Open the file manually to start writing.
    start notepad "%FILENAME%"
)
