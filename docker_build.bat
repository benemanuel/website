
docker build -t website   --no-cache=true .
docker run -p 4000:4000  -itd --name aviweb website


docker-compose up -d
"C:\Program Files\Waterfox\waterfox.exe" http://127.0.0.1:4000/website/
pause
docker-compose stop
c:\temp\dockerstop_kill.bat websitebenemanuel-jekyll-1


c:\temp\dockerstop_kill.bat aviweb
docker rmi website
