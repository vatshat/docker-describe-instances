--------------
[Learn To Code] [BSC]
--------------

To avoid confusion, ignore everything else and only focus on the files of interest:
1. Bash script - ec2-user-data.sh
2. Python script - bsc-repo/docker-describe-instances/app/app.py
3. Javascript - bsc-repo/docker-describe-instances/app/static/js/angular_app.js

--------------
Description 
--------------
Using Javscript (AngularJS) for client side scripting to provide UI page after describing instances. Terribly buggy (still needs A LOT of optimizing but does the job (sometimes).

Using Python (flask) for backend processing and web server processing.

To give a try, launch a new Amazon Linux instance using "ec2-user-data.sh". Then browse to port 80 of that instance.

NB!! Make sure that instance has IAM permissions to make ec2 API calls. There's no error checking so it'll crash
