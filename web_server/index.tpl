<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Web Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .section-color {
            background: linear-gradient(to right, #15024d, #760202);
            padding: 50px;
            text-align: center;
            color: white;
            font-size: 24px;
        }

        .section-content {
            padding: 50px;
            color: white;
            text-align: center;
        }

        .frame {
            border: 2px solid #15024d; /* Frame border color */
            padding: 20px; /* Space between text and border */
            display: inline-block; /* To shrink to fit the content */
            border-radius: 10px; /* Rounded corners */
            background-color: #292471; /* Frame background color */
            box-shadow: 2px 2px 10px rgb(255, 251, 251); /* Optional shadow */
        }

        .signature {
            margin-top: 30px;
            font-size: 18px;
        }
    </style>
</head>
<body>

    <!-- Section with colored background -->
    <section class="section-color">
        <h1>ITI Port Said Branch</h1>
        <div class="signature" style="position: absolute; bottom: 520px; right: 50px; font-size: 20px;">
            By | Ahmed Tobar
        </div>
    </section>

    <!-- Section with text, image, and signature -->
    <section class="section-content">
        <div class="frame">
            <h1>Hello from ${web_server}</h1>
        </div>
    </section>

</body>
</html>
