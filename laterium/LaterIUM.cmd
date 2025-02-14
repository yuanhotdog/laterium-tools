@ECHO OFF

setlocal EnableDelayedExpansion

color F

SET "AMX_OPT_O=-o"
SET "AMX_OPT_F=-d0"

IF not EXIST .cache ( MKDIR .cache )
SET "METADAT_FILE=.cache\compiler.log"

SET "CMDSUSERS=%username%@%computername%"

TITLE %CMDSUSERS%:~

SET "COMMAND_DIR=%~dp0"
SET "COMMAND_TITLE="
SET "COMMAND_NAME=LaterIUM.cmd"
SET "COMMAND_SERVER=samp-server.exe"
SET "COMMAND_BUILD=v1-2025"

SET "COMPILER_LTIUM=false"
SET "COMPILER_PAWNCC="

:COMMAND_TYPEOF
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & ECHO on & FOR %%b in (1) do rem"') do (SET "DEL=%%a")

<nul SET /p="" 
    CALL :COLOURTEXT A "%CMDSUSERS%" 
    <nul SET /p=":~$ " 
    SET /p LATERIUM_F=" "
    GOTO NEXT

:COLOURTEXT
    <nul SET /p "=%DEL%" > "%~2"
    FINDSTR /v /a:%1 /R "+" "%~2" nul
    del "%~2" > nul
    GOTO :eof

:NEXT
SET "CMDSFILE=true"
SET "CMDSOPTION=cat"

IF "%LATERIUM_F%"=="%CMDSOPTION% -c" (

    TASKKILL /f /im "!COMMAND_SERVER!" >nul 2>&1

    SET "COMMAND_TITLE=compilers"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!
    
    ECHO.

    SET "COMPILER_LTIUM=true"
    GOTO COMPILERS

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -r" (

    TASKKILL /f /im "!COMMAND_SERVER!" >nul 2>&1
    
    SET "COMMAND_TITLE=running"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    TIMEOUT /t 0 >nul
    GOTO SERVERS

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -d" (
    
    SET "COMMAND_TITLE=samp server debugger"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

:TESTSERVERS
    IF EXIST "%COMMAND_DIR%server_log.txt" ( DEL "%COMMAND_DIR%server_log.txt" /q >nul )
    
    TASKKILL /f /im "!COMMAND_SERVER!" >nul 2>&1
    
    TIMEOUT /t 0 >nul
        START /min "" "!COMMAND_SERVER!"
    TIMEOUT /t 1 >nul
        TYPE server_log.txt
        ECHO.
	TASKKILL /f /im "!COMMAND_SERVER!" >nul 2>&1
	
    GOTO COMMAND_END

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -ci" (

    TASKKILL /f /im "!COMMAND_SERVER!" >nul 2>&1

    SET "COMMAND_TITLE=compile running"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    SET "COMPILER_LTIUM=false"

    ECHO.
    CALL :COMPILERS
    FINDSTR /i "error" %METADAT_FILE% >nul && ECHO. || CALL :OK_NEXT

:OK_NEXT
<nul SET /p=""
    CALL :COLOURTEXT a "# Press any key to running."
    ECHO.
    PAUSE >nul

:SERVERS
    IF EXIST "%COMMAND_DIR%server_log.txt" ( DEL "%COMMAND_DIR%server_log.txt" /q >nul )
	
    START "" "!COMMAND_SERVER!"
	
    TIMEOUT /t 2 >nul
    TASKLIST | FIND /i "!COMMAND_SERVER!" >nul

    IF not EXIST !COMMAND_SERVER! (
        ECHO # !COMMAND_SERVER! not found..
        TIMEOUT /t 2 >nul
            START "" "https://sa-mp.app/"
        GOTO COMMAND_TYPEOF
    )

    IF ERRORLEVEL 1 (
        SET "COMMAND_TITLE=running - failed"
        TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

        ECHO.
        <nul SET /p=""
            CALL :COLOURTEXT 4X "# Fail"
            ECHO.
		
        IF EXIST "server_log.txt" (
            TIMEOUT /t 2 >nul
                TYPE server_log.txt
            ECHO.
        ) ELSE (
            ECHO # server_log.txt not found.
        )
        
        <nul SET /p=""
            CALL :COLOURTEXT a "# End."
            ECHO.
        GOTO COMMAND_TYPEOF
    ) ELSE ( :: if
	ECHO.
        <nul SET /p=""
        CALL :COLOURTEXT a "# Succes"
        ECHO.
		
        TIMEOUT /t 2 >nul
        FINDSTR /i "error" server_log.txt >nul && CALL :START_TRUE2 || CALL :START_FALSE2

    :START_TRUE2
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    ; "error"   .. Yes .. True
        CALL :ERROR_CACHE
        
        GOTO :eof

    :START_FALSE2
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    ; "error"   .. No .. False
        
:CHECK2
        FINDSTR /i "failed" server_log.txt >nul && CALL :START_TRUE || CALL :START_FALSE

    :START_TRUE
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    ; "failed"  .. Yes .. True
        CALL :FAILED_CACHE
        
        GOTO :eof

    :START_FALSE
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    ; "failed"  .. No .. False

:CHECK3
        FINDSTR /i "invalid" server_log.txt >nul && CALL :START_TRUE3 || CALL :START_FALSE3

    :START_TRUE3
        <nul SET /p=""
            CALL :COLOURTEXT 4X "~"
            ECHO    ; "invalid" .. Yes .. True
        CALL :INVALID_CACHE

        GOTO :eof

    :START_FALSE3
        <nul SET /p=""
            CALL :COLOURTEXT a "~"
            ECHO    ; "invalid" .. No .. false

        ECHO.
        GOTO COMMAND_END
    )

:ERROR_CACHE
    ECHO.
    FINDSTR /i "error" ^> server_log.txt
    ECHO.
    GOTO CHECK2
:FAILED_CACHE
    ECHO.
    FINDSTR /i "failed" ^> server_log.txt
    ECHO.
    GOTO CHECK3
:INVALID_CACHE
    ECHO.
    FINDSTR /i "invalid" ^> server_log.txt
    ECHO.

    GOTO COMMAND_TYPEOF

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -C" (

    SET "COMMAND_TITLE=clear screen"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    CLS
    GOTO COMMAND_TYPEOF

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -V" (

    SET "COMMAND_TITLE=vscode tasks"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    IF EXIST ".vscode" (
        RMDIR /s /q .vscode
    )
    MKDIR ".vscode"
    (
        ECHO {
        ECHO   "version": "2.0.0",
        ECHO   "tasks": [
        ECHO     {
        ECHO       "label": "Run LaterIUM",
        ECHO       "type": "process",
        ECHO       "command": "${workspaceFolder}/%COMMAND_NAME%",
        ECHO       "group": {
        ECHO           "kind": "build",
        ECHO           "isDefault": true
        ECHO       },
        ECHO       "problemMatcher": [],
        ECHO       "detail": "Task to run the LaterIUM"
        ECHO     }
        ECHO   ]
        ECHO }
    ) > ".vscode\tasks.json"
    ECHO # C? '.vscode\tasks.json'...: [yes]
    GOTO COMMAND_END

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -R" (

    SET /p nameput="~ "

    FOR /r "%COMMAND_DIR%" %%a in ("!nameput!.*") do (
        ECHO %%~nxa | FINDSTR /i /E ".io" >nul
        IF not ERRORLEVEL 1 (
            ECHO E: File "%%~nxa" can't rename.
            GOTO COMMAND_END
        )

        ECHO %%~nxa | FINDSTR /i /E ".amx" >nul
        IF ERRORLEVEL 1 (
            ECHO R: "%%a" to "!nameput!.io.pwn"
            ren "%%a" "!nameput!.io.pwn"
        )
    )

    GOTO COMMAND_END
) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -F" (

    SET "COMMAND_TITLE=folder check"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    IF EXIST filterscripts (
        ECHO.
        ECHO # filterscripts is .. Ok ..
        ECHO  [A subdirectory or file filterscripts already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        MKDIR filterscripts
        ECHO # C? '%COMMAND_DIR%filterscripts'...: [yes]
        TIMEOUT /t 1 >nul
    )
    IF EXIST gamemodes (
        ECHO.
        ECHO # gamemodes is .. Ok ..
        ECHO  [A subdirectory or file gamemodes already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        setlocal EnableDelayedExpansion
        MKDIR gamemodes
        (
            ECHO #include ^<a_samp^>
            ECHO.
            ECHO main^(^) {
            ECHO     print "Hello, World!";
            ECHO }
        ) > "gamemodes\main.io.pwn"
        endlocal
        ECHO.
        ECHO # C? '%COMMAND_DIR%gamemodes'...: [yes]
        ECHO.
        TIMEOUT /t 1 >nul
    )
    IF EXIST scriptfiles (
        ECHO.
        ECHO # scriptfiles is .. Ok ..
        ECHO  [A subdirectory or file scriptfiles already exists.]
        ECHO -
        TIMEOUT /t 1 >nul
    ) ELSE (
        MKDIR scriptfiles
        ECHO # C? '%COMMAND_DIR%scriptfiles'...: [yes]
        TIMEOUT /t 1 >nul
    )
    FOR /r "%COMMAND_DIR%" %%F in (*.io*) do (
        IF EXIST "%%F" (
            IF not "%%~xF"==".amx" (
                ECHO.
                ECHO # LaterIUM Pawn file is .. Ok ..
                ECHO  [A subdirectory or file %%F already exists.]
                ECHO -
                TIMEOUT /t 1 >nul
            )
        )
    )
    IF EXIST server.cfg (
        ECHO.
        ECHO # server.cfg is .. Ok ..
        ECHO  [A subdirectory or file server.cfg already exists.]
    ) ELSE (
        (
            
            ECHO echo Executing Server Config...
            ECHO lanmode 0
            ECHO rcon_password changename
            ECHO maxplayers 150
            ECHO port 7777
            ECHO hostname SA-MP 0.3
            ECHO gamemode0 main 1
            ECHO filterscripts 
            ECHO announce 0
            ECHO chatlogging 0
            ECHO weburl www.sa-mp.com
            ECHO onfoot_rate 40
            ECHO incar_rate 40
            ECHO weapon_rate 40
            ECHO stream_distance 300.0
            ECHO stream_rate 1000
            ECHO maxnpc 0
            ECHO logtimeformat [%H:%M:%S]
            ECHO language English

        ) > "server.cfg"
        ECHO # C? '%COMMAND_DIR%server.cfg'...: [yes]
        ECHO.
        TYPE server.cfg
        ECHO.
        GOTO COMMAND_END
    )

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -v" (

    SET "COMMAND_TITLE=version"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    ECHO.
    ECHO ~ !COMMAND_BUILD!
    ECHO.

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -T" (

    SET "COMMAND_TITLE=type files"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!

    ECHO Example: ~ server.cfg server_log.txt

    SET /p inputTYPES="~ "
    TYPE !inputTYPES!
    ECHO.

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -D" (

    cmd /c dir

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% -K" (

    START %COMMAND_NAME%
    EXIT

) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% pwd" (
    ECHO %cd%
) ELSE IF "%LATERIUM_F%"=="help" (

    SET "COMMAND_TITLE=help"
    TITLE %CMDSUSERS%:~/!COMMAND_TITLE!
    
:_@H
    ECHO usage: cat [-c compile] [-r running] [-d debugger server] [-ci compile-running]
    ECHO       	   [-R rename file] [-C clear screen] [-F folder check] [-V vscode tasks]
    ECHO       	   [-T ^type file] [-K kill cmd] [-D directory] [-v version] [-pwd pwd]
    GOTO COMMAND_TYPEOF

) ELSE IF "%LATERIUM_F%"=="cat ." (

    GOTO TESTSERVERS

) ELSE IF "%LATERIUM_F%"=="cat" (

    GOTO _@H

) ELSE IF "%LATERIUM_F%"=="" (
    GOTO COMMAND_TYPEOF
) ELSE IF "%LATERIUM_F%"==" " (
    GOTO COMMAND_TYPEOF
) ELSE IF "%LATERIUM_F%"=="%CMDSOPTION% " (
    GOTO _@H
) ELSE (
    ECHO '!LATERIUM_F!' is not recognized as an internal or external command,
    ECHO operable program or batch file.
    ECHO.
    GOTO _@H
    GOTO COMMAND_TYPEOF
)

:COMMAND_END
<nul SET /p=""
    CALL :COLOURTEXT a "# Press any key to return."
    ECHO.
PAUSE >nul
GOTO COMMAND_TYPEOF

:COMPILERS
    FOR /r "%COMMAND_DIR%" %%P in (pawncc.exe) do (
        IF EXIST "%%P" (
            SET "COMPILER_PAWNCC=%%P"
            GOTO PAWNCC
        )
    )
:PAWNCC
    IF not DEFINED COMPILER_PAWNCC (
        ECHO.
            ECHO # pawncc not found..
        ECHO.

        TIMEOUT /t 2 >nul
        START "" "https://github.com/pawn-lang/compiler/releases"
        GOTO COMMAND_TYPEOF
    )
    SET "CMDSFILE=false"
    FOR /r "%COMMAND_DIR%" %%F in (*.io*) do (
        IF EXIST "%%F" (
            IF not "%%~xF"==".amx" (
            
            SET "CMDSFILE=true"
            
            TITLE %%F
            
            SET "AMX_O=%%~dpnF"
            SET "AMX_O=!AMX_O:.io=!%.amx"

            "!COMPILER_PAWNCC!" "%%F" %AMX_OPT_O%"!AMX_O!" %AMX_OPT_F% > %METADAT_FILE% 2>&1

            CALL :_@R

            TIMEOUT /t 0 >nul
            TYPE %METADAT_FILE%

            IF EXIST "!AMX_O!" (
                FOR %%A in ("!AMX_O!") do (
                    ECHO.
                    ECHO ~ %AMX_O%
						
                    IF "%COMPILER_LTIUM%"=="true" (
                        SET "COMMAND_TITLE=compilers "%AMX_OPT_O% %AMX_OPT_F%""
                        TITLE %CMDSUSERS%:~/!COMMAND_TITLE!
                    ) ELSE IF "%COMPILER_LTIUM%"=="false" (
                        SET "COMMAND_TITLE=compiler - running "%AMX_OPT_O% %AMX_OPT_F%""
                        TITLE %CMDSUSERS%:~/!COMMAND_TITLE!
                    )
                    ECHO end at %time%
                    ECHO total size : %%~zA / bytes
                    ECHO.
                )
            ) ELSE (
                    IF "%COMPILER_LTIUM%"=="false" (
                        GOTO COMMAND_END
                    )
                )
            )
        )
    )
    IF not "%CMDSFILE%"=="true" (
        ECHO   ~ "!COMMAND_DIR!.io" no files found.
        GOTO COMMAND_END
    )
    IF "%COMPILER_LTIUM%"=="true" (
        GOTO COMMAND_END
    )
    IF "%COMPILER_LTIUM%"=="false" (
        GOTO OK_NEXT
    )

:_@R
    SET "cache_compiler=.cache\compiler.log"
    SET "_cache_compiler=.cache\.compiler.log"

    IF EXIST %_cache_compiler% del %_cache_compiler%

    FOR /f "delims=" %%A in (%cache_compiler%) do (

        ECHO ~ >> %_cache_compiler%
        
            SET "CACHEREP=%%A"

        ECHO !CACHEREP! >> %_cache_compiler%

    )

    MOVE /y %_cache_compiler% %cache_compiler% >nul
