@echo off
setlocal enabledelayedexpansion

REM Set your AWS S3 bucket name and Lighthouse options
set S3_BUCKET_NAME=myuploads3
set LIGHTHOUSE_OPTIONS=--output=json --chrome-flags="--headless"

REM Replace "urls.txt" with the path to your text file containing URLs
set URLS_FILE=extracted-urls.txt

set /A j=1

REM Loop through each URL in the file
for /f "tokens=*" %%i in (%URLS_FILE%) do (
    set URL=%%i

    REM Generate a unique name for the JSON report
    set TIMESTAMP=%date:~-4%%date:~7,2%%date:~4,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set JSON_REPORT_NAME=!URL!_!TIMESTAMP!.json
    echo !JSON_REPORT_NAME!
    echo Generating Lighthouse report for !URL!
    REM Run Lighthouse and directly upload the output to the S3 bucket
    lighthouse !URL! %LIGHTHOUSE_OPTIONS%  | aws s3 cp - s3://myuploads3/!j!.json
    set /A j=j+1

    REM Note: The "-" after "aws s3 cp" indicates that the output from lighthouse will be piped directly to the S3 bucket without saving it locally.

    REM Optionally, you can also delete the temporary JSON report created by Lighthouse if you want to save storage space.
)

echo All reports generated and uploaded to S3.