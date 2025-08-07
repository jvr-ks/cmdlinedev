@rem test_curl_open_sbt_console.bat

@echo off

echo open (testareaQuick) with curl ...

rem curl http://localhost:65505/scs?open=(testareaQuick)
curl.exe http://localhost:65505/scs?open=(testareaQuick)
rem curl http://127.0.0.1:65505/scs?open=(testareaQuick)  

