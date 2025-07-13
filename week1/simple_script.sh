# make an html, css, and js file, and put the html boiler plate in there too

#!/bin/bash

mkdir sample_project

touch sample_project/index.html
touch sample_project/style.css
touch sample_project/script.js

echo "<html>
    <head>
        <title>Sample Project</title>
        <link rel='stylesheet' href='style.css'>
    </head>
    <body>
        <h1>Sample Project</h1>
        <p>This is a sample project.</p>
        <script src='script.js'></script>
    </body>
</html>" > sample_project/index.html

ls -R sample_project