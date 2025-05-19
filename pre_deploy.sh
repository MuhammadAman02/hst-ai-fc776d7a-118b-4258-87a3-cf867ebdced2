#!/bin/bash

# Pre-deployment script to ensure all files are properly set up before building the Docker image
set -e

echo "Starting pre-deployment setup..."

# Create necessary directories if they don't exist
mkdir -p app/templates app/static

# Check if templates directory exists and has files
if [ -d "templates" ] && [ "$(ls -A templates 2>/dev/null)" ]; then
    echo "Copying templates to app/templates..."
    cp -r templates/* app/templates/ 2>/dev/null || true
else
    echo "Warning: templates directory is empty or doesn't exist"
fi

# Check if static directory exists and has files
if [ -d "static" ] && [ "$(ls -A static 2>/dev/null)" ]; then
    echo "Copying static files to app/static..."
    cp -r static/* app/static/ 2>/dev/null || true
else
    echo "Warning: static directory is empty or doesn't exist"
fi

# Create a simple index.html in app/templates if it doesn't exist
if [ ! -f "app/templates/index.html" ]; then
    echo "Creating a default index.html in app/templates..."
    cat > app/templates/index.html << 'EOF'
{% extends "base.html" %}

{% block title %}Home - My Application{% endblock %}

{% block content %}
    <h1>Hello, FastAPI!</h1>
    <p>Welcome to your new FastAPI application, built using our world-class template foundation!</p>
    <p>Current time: {{ current_time }}</p>
{% endblock %}
EOF
fi

# Create a simple base.html in app/templates if it doesn't exist
if [ ! -f "app/templates/base.html" ]; then
    echo "Creating a default base.html in app/templates..."
    mkdir -p app/templates/partials
    
    # Create base.html
    cat > app/templates/base.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}My Application{% endblock %}</title>
    <link rel="stylesheet" href="{{ url_for('static', path='style.css') }}">
    {% block head_extra %}{% endblock %}
</head>
<body>
    <header>
        {% block header %}
        {% include 'partials/header.html' %}
        {% endblock %}
    </header>

    <main>
        {% block content %}
        <p>Welcome to the application!</p>
        {% endblock %}
    </main>

    <footer>
        {% block footer %}
        {% include 'partials/footer.html' %}
        {% endblock %}
    </footer>

    {% block scripts_extra %}{% endblock %}
</body>
</html>
EOF
    
    # Create header.html
    cat > app/templates/partials/header.html << 'EOF'
<nav>
    <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
</nav>
<hr>
EOF
    
    # Create footer.html
    cat > app/templates/partials/footer.html << 'EOF'
<hr>
<p>&copy; {{ current_year }} My Application. All rights reserved.</p>
EOF
fi

# Create a simple style.css in app/static if it doesn't exist
if [ ! -f "app/static/style.css" ]; then
    echo "Creating a default style.css in app/static..."
    cat > app/static/style.css << 'EOF'
/* General Body Styles */
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
    color: #333;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

/* Container for main content */
.container {
    width: 80%;
    margin: auto;
    overflow: hidden;
    padding: 0 20px;
}

/* Header Styles */
header {
    background: #333;
    color: #fff;
    padding: 1rem 0;
    border-bottom: #0779e4 3px solid;
}

header a {
    color: #fff;
    text-decoration: none;
    text-transform: uppercase;
    font-size: 16px;
}

header ul {
    padding: 0;
    list-style: none;
    text-align: center;
}

header li {
    display: inline;
    padding: 0 20px;
}

header nav {
    display: flex;
    justify-content: center;
}

/* Main Content Styles */
main {
    flex: 1;
    padding: 2rem 0;
}

/* Footer Styles */
footer {
    background: #333;
    color: #fff;
    text-align: center;
    padding: 1rem 0;
    margin-top: auto;
}

/* Headings */
h1, h2, h3 {
    color: #333;
    margin-bottom: 1rem;
}

h1 {
    font-size: 2.5rem;
}

h2 {
    font-size: 2rem;
}

h3 {
    font-size: 1.5rem;
}

/* Links */
a {
    color: #0779e4;
    text-decoration: none;
}

a:hover {
    color: #0056b3;
    text-decoration: underline;
}

/* Buttons */
.btn {
    display: inline-block;
    background: #0779e4;
    color: #fff;
    border: none;
    padding: 10px 20px;
    margin: 5px;
    border-radius: 5px;
    cursor: pointer;
    text-decoration: none;
    font-size: 15px;
    font-family: inherit;
}

.btn:hover {
    background: #0056b3;
    color: #fff;
    text-decoration: none;
}

.btn-light {
    background: #f4f4f4;
    color: #333;
}

.btn-light:hover {
    background: #e4e4e4;
    color: #333;
}

/* Form Styles */
input[type="text"],
input[type="email"],
input[type="password"],
input[type="date"],
select,
textarea {
    border: 1px solid #ddd;
    margin: 1rem 0;
    padding: 0.5rem;
    width: 100%;
    border-radius: 5px;
    font-family: inherit;
}

/* Responsive Design */
@media(max-width: 768px) {
    header #branding,
    header nav,
    header nav li {
        float: none;
        text-align: center;
        width: 100%;
    }

    .container {
        width: 90%;
    }
}
EOF
fi

echo "Pre-deployment setup completed successfully!"