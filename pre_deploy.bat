@echo off
REM Pre-deployment script for Windows to ensure all files are properly set up before building the Docker image

echo Starting pre-deployment setup...

REM Create necessary directories if they don't exist
if not exist app\templates mkdir app\templates
if not exist app\static mkdir app\static

REM Check if templates directory exists and has files
if exist templates (
    echo Copying templates to app\templates...
    xcopy /E /Y templates\* app\templates\ 2>nul
) else (
    echo Warning: templates directory doesn't exist
)

REM Check if static directory exists and has files
if exist static (
    echo Copying static files to app\static...
    xcopy /E /Y static\* app\static\ 2>nul
) else (
    echo Warning: static directory doesn't exist
)

REM Create a simple index.html in app\templates if it doesn't exist
if not exist app\templates\index.html (
    echo Creating a default index.html in app\templates...
    (
        echo ^{%% extends "base.html" %%^}

        echo ^{%% block title %%^}Home - My Application^{%% endblock %%^}

        echo ^{%% block content %%^}
        echo     ^<h1^>Hello, FastAPI!^</h1^>
        echo     ^<p^>Welcome to your new FastAPI application, built using our world-class template foundation!^</p^>
        echo     ^<p^>Current time: ^{^{ current_time ^}^}^</p^>
        echo ^{%% endblock %%^}
    ) > app\templates\index.html
)

REM Create a simple base.html in app\templates if it doesn't exist
if not exist app\templates\base.html (
    echo Creating a default base.html in app\templates...
    if not exist app\templates\partials mkdir app\templates\partials
    
    REM Create base.html
    (
        echo ^<!DOCTYPE html^>
        echo ^<html lang="en"^>
        echo ^<head^>
        echo     ^<meta charset="UTF-8"^>
        echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
        echo     ^<title^>^{%% block title %%^}My Application^{%% endblock %%^}^</title^>
        echo     ^<link rel="stylesheet" href="^{^{ url_for^('static', path='style.css'^) ^}^}"^>
        echo     ^{%% block head_extra %%^}^{%% endblock %%^}
        echo ^</head^>
        echo ^<body^>
        echo     ^<header^>
        echo         ^{%% block header %%^}
        echo         ^{%% include 'partials/header.html' %%^}
        echo         ^{%% endblock %%^}
        echo     ^</header^>
        echo.
        echo     ^<main^>
        echo         ^{%% block content %%^}
        echo         ^<p^>Welcome to the application!^</p^>
        echo         ^{%% endblock %%^}
        echo     ^</main^>
        echo.
        echo     ^<footer^>
        echo         ^{%% block footer %%^}
        echo         ^{%% include 'partials/footer.html' %%^}
        echo         ^{%% endblock %%^}
        echo     ^</footer^>
        echo.
        echo     ^{%% block scripts_extra %%^}^{%% endblock %%^}
        echo ^</body^>
        echo ^</html^>
    ) > app\templates\base.html
    
    REM Create header.html
    (
        echo ^<nav^>
        echo     ^<ul^>
        echo         ^<li^>^<a href="/"^>Home^</a^>^</li^>
        echo         ^<li^>^<a href="/about"^>About^</a^>^</li^>
        echo         ^<li^>^<a href="/contact"^>Contact^</a^>^</li^>
        echo     ^</ul^>
        echo ^</nav^>
        echo ^<hr^>
    ) > app\templates\partials\header.html
    
    REM Create footer.html
    (
        echo ^<hr^>
        echo ^<p^>^&copy; ^{^{ current_year ^}^} My Application. All rights reserved.^</p^>
    ) > app\templates\partials\footer.html
)

REM Create a simple style.css in app\static if it doesn't exist
if not exist app\static\style.css (
    echo Creating a default style.css in app\static...
    (
        echo /* General Body Styles */
        echo body {
        echo     font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        echo     line-height: 1.6;
        echo     margin: 0;
        echo     padding: 0;
        echo     background-color: #f4f4f4;
        echo     color: #333;
        echo     display: flex;
        echo     flex-direction: column;
        echo     min-height: 100vh;
        echo }
        echo.
        echo /* Container for main content */
        echo .container {
        echo     width: 80%%;
        echo     margin: auto;
        echo     overflow: hidden;
        echo     padding: 0 20px;
        echo }
        echo.
        echo /* Header Styles */
        echo header {
        echo     background: #333;
        echo     color: #fff;
        echo     padding: 1rem 0;
        echo     border-bottom: #0779e4 3px solid;
        echo }
    ) > app\static\style.css
)

echo Pre-deployment setup completed successfully!