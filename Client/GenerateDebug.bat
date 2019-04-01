call break > log.txt
call copy /b vendor\LOVE\love.exe+gamed.love bin\windows-debug\NetGame.exe
PAUSE
call bin\windows-debug\NetGame.exe > log.txt