@echo off 
setlocal enabledelayedexpansion

SET SOLR_HOME=%~dp0
SET SERVICE_ID=Solr

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

@REM questions
echo A few questions before we start the installation.
echo Press ENTER to accept the default value (between the brackets).
echo[

set SERVICE_DELETE=Y
SC query %SERVICE_ID% > NUL
IF NOT %ERRORLEVEL%==1060 (
	set /p SERVICE_DELETE="Service has already been installed. Do you want to delete it first / reinstall? (Y/N) [%SERVICE_DELETE%]: "
	if /I not "!SERVICE_DELETE!"=="Y" (
		echo -Installation aborted by user.
		set /p SCRIPT_END="<Press any key to exit>"
		exit /B 1 
	)
	echo[
	
	SC query %SERVICE_ID% | FIND /i "RUNNING" > NUL
	if !ERRORLEVEL!==0 (
		echo The service will be stopped...
		%PR_INSTALL% stop %SERVICE_ID%^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"
	 
		if !errorlevel!==0 (
			echo -The service "%SERVICE_ID%" has been stopped.
		) else (
			echo -Error, couldn't stop the service "%SERVICE_ID%".
			echo -Installaton aborted because of an error.
			set /p SCRIPT_END="<Press any key to exit>"
			exit /B 1 
		)
		echo[
	)
 
	echo The service will be removed...
	%PR_INSTALL% delete %SERVICE_ID%^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"
 
	if !errorlevel!==0 (
		echo -The service "%SERVICE_ID%" has been removed
	) else (
		echo -Error, couldn't remove the service "%SERVICE_ID%". 
		echo -Installaton aborted because of an error.
		set /p SCRIPT_END="<Press any key to exit>"
		exit /B 1 
	)
	echo[
)

set SERVICE_NAME=Solr
set /p SERVICE_NAME="Name of the service [%SERVICE_NAME%]: "

set SERVICE_DESCRIPTION=Installation supported by Doomic, \"%PR_INSTALL%\"
set /p SERVICE_DESCRIPTION="Description of the service [%SERVICE_DESCRIPTION%]: "

set SOLR_PORT=8983
set /p SOLR_PORT="Port number where Solar should be running [%SOLR_PORT%]: "
echo[

@REM Startup Configuration 
set PR_STARTUP=auto
set PR_STARTMODE=exe
set PR_STARTIMAGE=%SOLR_HOME%bin\solr.cmd
set PR_STARTPARAMS=start;-p=%SOLR_PORT%

@REM Shutdown Configuration 
set PR_STOPMODE=exe
set PR_STOPIMAGE=%SOLR_HOME%bin\solr.cmd
set PR_STOPPARAMS=stop;-p=%SOLR_PORT%

@REM start
%PR_INSTALL% //IS/%SERVICE_ID%^
 --Description="%SERVICE_DESCRIPTION%"^
 --DisplayName="%SERVICE_NAME%"^
 --Install="%PR_INSTALL%"^
 --Startup="%PR_STARTUP%"^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"^
 --StartMode="%PR_STARTMODE%"^
 --StartImage="%PR_STARTIMAGE%"^
 --StartParams="%PR_STARTPARAMS%"^
 --StopMode="%PR_STOPMODE%"^
 --StopImage="%PR_STOPIMAGE%"^
 --StopParams="%PR_STOPPARAMS%"
 
@REM end
if %errorlevel%==0 (
	echo The service is successfully installed.
	echo   -id:    "%SERVICE_ID%"
	echo   -name:  "%SERVICE_NAME%" 
	echo   -port:  "%SOLR_PORT%" 
	echo Use "%SOLR_HOME%%SERVICE_ID%.exe" to manage the service.
	
	echo[
	echo The service "%SERVICE_ID%" will be started...
	
	%PR_INSTALL% start %SERVICE_ID%^
 --LogPath="%PR_LOGPATH%"^
 --LogPrefix="%PR_LOGPREFIX%"^
 --LogLevel="%PR_LOGLEVEL%"^
 --StdOutput="%PR_STDOUTPUT%"^
 --StdError="%PR_STDERROR%"
	if !errorlevel!==0 (
		echo -The service "%SERVICE_ID%" has been started.
		set /p SCRIPT_END="<Press any key to exit>"
		exit /B 0 
	) else (
		echo -Error, couldn't start the service "%SERVICE_ID%".
		set /p SCRIPT_END="<Press any key to exit>"
		exit /B 1 
	)
) else (
	echo Error, couldn't install the service "%SERVICE_ID%".
	set /p SCRIPT_END="<Press any key to exit>"
	exit /B 1 
)
