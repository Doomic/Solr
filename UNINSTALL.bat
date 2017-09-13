@echo off 
setlocal enabledelayedexpansion

SET SOLR_HOME=%~dp0
SET SERVICE_ID=Solr
@REM sc delete %SERVICE_ID%

@REM Service Log Configuration
set PR_LOGPREFIX=%SERVICE_ID%: 
set PR_LOGPATH=%SOLR_HOME%server\logs
set PR_STDOUTPUT=auto
set PR_STDERROR=auto
set PR_LOGLEVEL=Debug

@REM find prunsrv.exe location
set PR_INSTALL=%SOLR_HOME%commons-deamon\%PROCESSOR_ARCHITECTURE%\prunsrv.exe
if not exist %PR_INSTALL% (
	PR_INSTALL=%SOLR_HOME%commons-deamon\prunsrv.exe
)

SC query %SERVICE_ID% > NUL
if %ERRORLEVEL%==1060 (
	echo -Error, couldn't find the service "%SERVICE_ID%". 
	echo -Is the service "%SERVICE_ID%" installed at all?
	set /p SCRIPT_END="<Press any key to exit>"
	exit /B 0
)

SC query %SERVICE_ID% | FIND /i "RUNNING" > NUL
if %ERRORLEVEL%==0 (
	echo The service will be stopped...
	"%PR_INSTALL%" stop %SERVICE_ID%^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"
 
	echo !errorlevel!
	if !errorlevel!==0 (
		echo -The service "%SERVICE_ID%" has been stopped.
	) else (
		echo -Error, couldn't stop the service "%SERVICE_ID%".
		echo -Installaton aborted because of an error.
		set /p SCRIPT_END="<Press any key to exit>"
		exit /B 1 
	)
)

echo The service will be removed...
"%PR_INSTALL%" delete %SERVICE_ID%^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"

@REM end
if %errorlevel%==0 (
	echo -The service "%SERVICE_ID%" has been removed
) else (
	echo -Error, couldn't remove the service "%SERVICE_ID%". 
	echo -Installaton aborted because of an error.
	set /p SCRIPT_END="<Press any key to exit>"
	exit /B 1 
)
