@echo off

setlocal

chcp 1251 > nul

set "?~dp0=%~dp0"
set "?~nx0=%~nx0"
set ?01=^^^|
set TAB={\u0009}
set "EOLTAB=	"

set "SETUP_ROOT=%~dp0"
set "SETUP_ROOT=%SETUP_ROOT:~0,-1%"

set CECHO="%SETUP_ROOT%\tools\cecho.exe"
if not exist %CECHO% (
  echo.%?~nx0%: error: cecho.exe is not found: %CECHO%.
  exit /b -254
) >&2


set "TARGETS_LIST=PlatformA1 PlatformA2 PlatformB PlatformC1 PlatformD1 PlatformD2 PlatformD3"
set "TARGETS_SEPARATOR_LIST=%TAB%|%TAB%|%TAB%|%TAB%|%TAB%|%TAB%|%TAB%"
set "ALL_IN_ONE_SEPARATOR0=%TAB%"

rem MUST BE ALWAYS QUOTED AS INTRODUCED!
set "TARGET_DESC.PlatformA1=ApplicationX_v5 description for PlatformA1"
set "TARGET_DESC.PlatformA2=ApplicationX_v5 description for PlatformA2"
set "TARGET_DESC.PlatformB=ApplicationX_v5 description for PlatformB"
set "TARGET_DESC.PlatformC1=ApplicationX_v6 description for PlatformC1"
set "TARGET_DESC.PlatformD1=ApplicationX_v6 description for PlatformD1"
set "TARGET_DESC.PlatformD2=ApplicationX_v6 description for PlatformD2"
set "TARGET_DESC.PlatformD3=ApplicationX_v6 description for PlatformD3"
set "TARGET_DESC.all_in_one[EN]={#}[{0F}EN{#}] {06}Select platform at setup execution{#}"
set "TARGET_DESC.all_in_one[RU]={#}[{0F}RU{#}] {06}Âûáîð ïëàòôîðìû â ìîìåíò èíñòàëëÿöèè{#}"

set "APPX.APP_TARGETS_LIST=PlatformA PlatformB PlatformC PlatformD"
set "APPX.PlatformA.TARGETS_LIST=PlatformA1 PlatformA2"
set "APPX.PlatformB.TARGETS_LIST=PlatformB"
set "APPX.PlatformC.TARGETS_LIST=PlatformC1"
set "APPX.PlatformD.TARGETS_LIST=PlatformD1 PlatformD2 PlatformD3"

rem MUST BE ALWAYS QUOTED AS INTRODUCED!
set APPX.PlatformA.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS="ApplicationX_v5\SetupApplicationX_v5_%%APP_TARGET_NAME%%.exe.*" ^
  "ApplicationX_v5\ApplicationX_v5_%%APP_TARGET_NAME%%.7z"
set APPX.PlatformB.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS="ApplicationX_v5\SetupApplicationX_v5_%%APP_TARGET_NAME%%.exe.*" ^
  "ApplicationX_v5\ApplicationX_v5_%%APP_TARGET_NAME%%.7z"
set APPX.PlatformC.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS="ApplicationX_v6\SetupApplicationX_v6_%%APP_TARGET_NAME%%.exe.*" ^
  "ApplicationX_v6\ApplicationX_v6_%%APP_TARGET_NAME%%.7z"
set APPX.PlatformD.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS="ApplicationX_v6\SetupApplicationX_v6_%%APP_TARGET_NAME%%.exe.*" ^
  "ApplicationX_v6\ApplicationX_v6_%%APP_TARGET_NAME%%.7z"

set APPX.PlatformA.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ApplicationX_v6"
set APPX.PlatformB.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ApplicationX_v6"
set APPX.PlatformC.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ApplicationX_v5"
set APPX.PlatformD.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ApplicationX_v5"

set "ROOTSETUP.APP_TARGETS_LIST=ScenarioU ScenarioV"
set "ROOTSETUP.APP_TARGETS_DESC_LIST=Scenario_U Scenario_V"
set "ROOTSETUP.APP_TARGETS_SEPARATOR_LIST=	|	"

set "ROOTSETUP.APP_TARGET_DESC[EN].ScenarioU=Scenario U"
set "ROOTSETUP.APP_TARGET_DESC[RU].ScenarioU=Ñöåíàðèé U"
set "ROOTSETUP.APP_TARGET_DESC[EN].ScenarioV=Scenario V+W"
set "ROOTSETUP.APP_TARGET_DESC[RU].ScenarioV=Ñöåíàðèé V+W"

rem MUST BE ALWAYS QUOTED AS INTRODUCED!
set "ROOTSETUP.ScenarioU.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS=README*.txt"
set "ROOTSETUP.ScenarioV.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS=README*.txt"

set ROOTSETUP.ScenarioU.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ScenarioV" "ScenarioW"
set ROOTSETUP.ScenarioV.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS="ScenarioU"

rem common list
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTNS="Database" "MS Redist" "MS Updates" "MS .NET Framework" "MS Windows Installer 3.1" "MS Windows Installer 4.5"

rem groupped list
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTNS_GROUP_NUMS=3
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_0="Database"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_0_DESC[EN]="Databases server"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_0_DESC[RU]="Ñåðâåð áàç äàííûõ"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_1="MS Redist" "MS Updates"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_1_DESC[EN]="Windows update and redistributable components"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_1_DESC[RU]="Êîìïîíåíòû îáíîâëåíèÿ Windows è îáùèå êîìïîíåíòû ïðèëîæåíèé"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_2="MS .NET Framework" "MS Windows Installer 3.1" "MS Windows Installer 4.5"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_2_DESC[EN]=".NET Framework and Windows Installer Agent"
set DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_2_DESC[RU]="Ôðåéìâîðê .NET è èíñòàëëÿòîð àãåíòà Windows"


set "TEMP_BASE_DIR=%TEMP%\_preinstall.bat"
set "PREINSTALL_DIR_PATH_DECORATED=%~dp0"
set "PREINSTALL_DIR_PATH_DECORATED=%PREINSTALL_DIR_PATH_DECORATED:~0,-1%"

set "PREINSTALL_DIR_PATH_DECORATED=%PREINSTALL_DIR_PATH_DECORATED:\=--%"
set "PREINSTALL_DIR_PATH_DECORATED=%PREINSTALL_DIR_PATH_DECORATED::=--%"

set "PREINSTALL_REVERT_STORE_DIR=%TEMP_BASE_DIR%\%PREINSTALL_DIR_PATH_DECORATED%"

rem read the date and time
set "PREINSTALL_DATETIME="
for /F "usebackq eol=%EOLTAB% tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^> nul`) do if "%%i" == "LocalDateTime" set "PREINSTALL_DATETIME=%%j"

if not defined PREINSTALL_DATETIME goto PREINSTALL_DATETIME_END

set "PREINSTALL_DATE=%PREINSTALL_DATETIME:~0,4%_%PREINSTALL_DATETIME:~4,2%_%PREINSTALL_DATETIME:~6,2%"
set "PREINSTALL_TIME=%PREINSTALL_DATETIME:~8,2%_%PREINSTALL_DATETIME:~10,2%_%PREINSTALL_DATETIME:~12,2%_%PREINSTALL_DATETIME:~15,3%"

:PREINSTALL_DATETIME_END

set "TEMP_PREINSTALL_DIR=%PREINSTALL_REVERT_STORE_DIR%\%PREINSTALL_DATE%.%PREINSTALL_TIME%"

rem preinstall by update only w/o script self delete at the end
set FLAG_U=0
rem open directory with temporaries generated by previous preinstalls instead of preinstall
set FLAG_OPEN_TEMPS=0
rem remove directory with temporaries generated by previous preinstalls instead of preinstall
set FLAG_REMOVE_ALL_TEMPS=0
rem revert previous preinstall run
set FLAG_REVERT=0

:FLAGS_LOOP

rem flags always at first
set "FLAG=%~1"

if defined FLAG ^
if not "%FLAG:~0,1%" == "-" set "FLAG="

if defined FLAG (
  if "%FLAG%" == "-u" (
    set FLAG_U=1
    shift
  ) else if "%FLAG%" == "-open-temps" (
    set FLAG_OPEN_TEMPS=1
    shift
  ) else if "%FLAG%" == "-remove-all-temps" (
    set FLAG_REMOVE_ALL_TEMPS=1
    shift
  ) else if "%FLAG%" == "-revert" (
    set FLAG_REVERT=1
    shift
  ) else (
    echo.%?~nx0%: error: invalid flag: %FLAG%
    exit /b -255
  )

  rem read until no flags
  goto FLAGS_LOOP
)

if %FLAG_OPEN_TEMPS% NEQ 0 (
  if exist "%PREINSTALL_REVERT_STORE_DIR%\" (
    "%SystemRoot%\explorer.exe" "%PREINSTALL_REVERT_STORE_DIR%\"
  ) else if exist "%TEMP_BASE_DIR%\" (
    "%SystemRoot%\explorer.exe" "%TEMP_BASE_DIR%\"
  )
  exit /b 0
)

if %FLAG_REMOVE_ALL_TEMPS% NEQ 0 (
  if exist "%TEMP_BASE_DIR%\" rmdir /S /Q "%TEMP_BASE_DIR%"
  exit /b 0
)

if %FLAG_REVERT% NEQ 0 (
  call :REVERT || goto :EOF
  goto REVERT_POSTPROCESS
)


goto REVERT_END

:REVERT
if not exist "%PREINSTALL_REVERT_STORE_DIR%\????_??_??.??_??_??_???" (
  echo.%?~nx0%: error: revert temporary directory does not exist or empty to begin revert: "%PREINSTALL_REVERT_STORE_DIR%\".
  exit /b -253
) >&2

echo.Select directory copy to revert by:
echo.

set REVERT_REV_INDEX=0
set REVERT_REVISION_MAX=1
for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in (`dir /A:D /B "%PREINSTALL_REVERT_STORE_DIR%\????_??_??.??_??_??_???"`) do (
  set REVERT_DIR=%%i
  call :SET_REVERT_DIR
)

echo.

set REVERT_INDEX_OK=0

:TYPE_REVERT_INDEX
echo.--------------------------------------------------------------------------------
set "REVERT_TYPE_INDEX="
set /P REVERT_TYPE_INDEX= Type the number or label^> 
echo.

if not defined REVERT_TYPE_INDEX goto IGNORE_REVERT_TYPE_INDEX_CHECK

if %REVERT_TYPE_INDEX% GEQ 1 if %REVERT_TYPE_INDEX% LEQ %REVERT_REVISION_MAX% set REVERT_INDEX_OK=1

call set "REVERT_DIR=%%REVERT_DIR_%REVERT_TYPE_INDEX%%%"

if not defined REVERT_DIR goto REVERT_DIR_ERROR
if not exist "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%" goto REVERT_DIR_ERROR

rem directory should has files or directories to revert
set "REVERT_DIR_FIRST="
for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in (`dir /B "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%"`) do set "REVERT_DIR_FIRST=%%i"
if not defined REVERT_DIR_FIRST goto REVERT_DIR_ERROR

goto REVERT_DIR_OK
:REVERT_DIR_ERROR
(
  echo.%?~nx0%: error: revert directory is empty.
  echo.
  goto TYPE_REVERT_INDEX
) >&2

:REVERT_DIR_OK
:IGNORE_REVERT_TYPE_INDEX_CHECK

if %REVERT_INDEX_OK% EQU 0 (
  echo.%?~nx0%: error: incorrect value.
  echo.
  goto TYPE_REVERT_INDEX
) >&2

echo.Reverting...

set "SCRIPT_SELF_REVERT_FROM_PATH="
set "SCRIPT_SELF_REVERT_TO_PATH="

for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in (`dir /B "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\"`) do (
  set FILE_PATH=%%i
  call :REVERT_FILE_PATH
)

exit /b 0

:REVERT_FILE_PATH
set "FILE_PATH_DIR=%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%"
if not exist "%FILE_PATH_DIR%\" call :GET_FILE_PATH_DIR "%%FILE_PATH_DIR%%"

call :GET_ROOT_PATH_SUFFIX "%%PREINSTALL_REVERT_STORE_DIR%%\%%REVERT_DIR%%" "%%FILE_PATH_DIR%%"

if not exist "%SETUP_ROOT%\%ROOT_PATH_SUFFIX%" mkdir "%SETUP_ROOT%\%ROOT_PATH_SUFFIX%"

if /i "%SETUP_ROOT%\%FILE_PATH%" == "%~dpf0" goto POSTPONE_REVERT_FILE_PATH

for /F "usebackq tokens=1,* delims=:" %%i in (`chcp 2^> nul`) do set LAST_CODE_PAGE=%%j
set LAST_CODE_PAGE=%LAST_CODE_PAGE: =%

rem switch locale into english compatible locale
chcp 65001 > nul

rem echo.D will only work if locale is in english !!!
if exist "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%\" (
  echo.^>xcopy: "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%\" -^> "%SETUP_ROOT%\%FILE_PATH%\"
  rem echo.D will only work if locale is in english !!!
  rem echo.^>^>xcopy "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%" "%SETUP_ROOT%\%FILE_PATH%\"
  echo.D|xcopy "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%" "%SETUP_ROOT%\%FILE_PATH%\" /E /Y
) else (
  rem echo.F will only work if locale is in english !!!
  rem echo.^>^>xcopy "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%" "%SETUP_ROOT%\%ROOT_PATH_SUFFIX%"
  echo.^>xcopy: "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%" -^> "%SETUP_ROOT%%ROOT_PATH_SUFFIX%"
  echo.F|xcopy "%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%" "%SETUP_ROOT%%ROOT_PATH_SUFFIX%" /Y /H
)
echo.

rem restore locale
if not "%LAST_CODE_PAGE%" == "65001" chcp %LAST_CODE_PAGE% > nul

exit /b 0

:POSTPONE_REVERT_FILE_PATH
set "SCRIPT_SELF_REVERT_FROM_PATH=%PREINSTALL_REVERT_STORE_DIR%\%REVERT_DIR%\%FILE_PATH%"
set "SCRIPT_SELF_REVERT_TO_PATH=%SETUP_ROOT%\%FILE_PATH%"

exit /b 0

:GET_FILE_PATH_DIR
set "FILE_PATH_DIR=%~dp1"
set "FILE_PATH_DIR=%FILE_PATH_DIR:~0,-1%"
exit /b 0

:SET_REVERT_DIR
set /A REVERT_REV_INDEX+=1
set "REVERT_DIR_%REVERT_REV_INDEX%=%REVERT_DIR%"
set REVERT_REVISION_MAX=%REVERT_REV_INDEX%
echo.(%REVERT_REV_INDEX%) - %REVERT_DIR%\

exit /b 0

:REVERT_END

if exist "%TEMP_PREINSTALL_DIR%\" (
  echo.%?~nx0%: error: unique temporary directory must not exist before it's creation: "%TEMP_PREINSTALL_DIR%\".
  exit /b -252
) >&2

mkdir "%TEMP_PREINSTALL_DIR%\"

rem --------------------------------------------------------------------------------

set "ROOTSETUP_HKLM_REG_KEY="
set "ROOTSETUP_TARGET_NAME="

rem read HKLM key from HKCU
set "ROOTSETUP_HKLM_REG_KEY="
for /F "usebackq eol=	 tokens=* delims=" %%i in (`reg.exe query "HKCU\Software\MySoftware\RootSetup" /v SetupRegKey 2^>nul`) do (
  set "REGSTR=%%i"
  call :PROCESS_REGISTRY_HKCU_TARGET_NAME
)

if not defined ROOTSETUP_HKLM_REG_KEY goto PROCESS_REGISTRY_HKLM_TARGET_NAME_END

goto PROCESS_REGISTRY_HKCU_TARGET_NAME_END

:PROCESS_REGISTRY_HKCU_TARGET_NAME
if not defined REGSTR exit /b 0
if not "%REGSTR:~0,15%" == "    SetupRegKey" exit /b 0

for /F "eol=	 tokens=1,* delims= " %%i in ("%REGSTR%") do ^
for /F "eol=	 tokens=1,* delims= " %%k in ("%%j") do set "ROOTSETUP_HKLM_REG_KEY=%%l"
exit /b 0

:PROCESS_REGISTRY_HKCU_TARGET_NAME_END
if defined ROOTSETUP_HKLM_REG_KEY set "ROOTSETUP_HKLM_REG_KEY=\%ROOTSETUP_HKLM_REG_KEY%"

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" goto X64
rem in case of wrong PROCESSOR_ARCHITECTURE value
if defined PROCESSOR_ARCHITEW6432 goto NOTX64

:X64
set "ROOTSETUP_REG_KEY=HKLM%ROOTSETUP_HKLM_REG_KEY:\SOFTWARE\=\SOFTWARE\Wow6432Node\%"
goto PRINT_REGISTRY_HKLM_TARGET_NAME

:NOTX64
set "ROOTSETUP_REG_KEY=HKLM%ROOTSETUP_HKLM_REG_KEY%"

:PRINT_REGISTRY_HKLM_TARGET_NAME
for /F "usebackq eol=	 tokens=* delims=" %%i in (`reg.exe query "%ROOTSETUP_REG_KEY%" /v TargetName 2^>nul`) do (
  set "REGSTR=%%i"
  call :PROCESS_REGISTRY_HKLM_TARGET_NAME
)

goto PROCESS_REGISTRY_HKLM_TARGET_NAME_END

:PROCESS_REGISTRY_HKLM_TARGET_NAME
if not defined REGSTR exit /b 0
if not "%REGSTR:~0,14%" == "    TargetName" exit /b 0

for /F "eol=	 tokens=1,* delims= " %%i in ("%REGSTR%") do ^
for /F "eol=	 tokens=1,* delims= " %%k in ("%%j") do set "ROOTSETUP_TARGET_NAME=%%l"
exit /b 0

:PROCESS_REGISTRY_HKLM_TARGET_NAME_END

if not defined ROOTSETUP_TARGET_NAME goto LAST_TARGET_NAME_NOT_FOUND

%CECHO% [{0F}EN{#}] {0E}The last been installed platform name{#}: %TAB%"{0C}%ROOTSETUP_TARGET_NAME%{#}"{\n}
%CECHO% [{0F}RU{#}] {0E}Ïîñëåäíÿÿ óñòàíàâëèâàåìàÿ ïëàòôîðìà{#}: %TAB%"{0C}%ROOTSETUP_TARGET_NAME%{#}"{\n}
%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
echo.

goto LAST_TARGET_NAME_NOT_FOUND_END

:LAST_TARGET_NAME_NOT_FOUND
%CECHO% [{0F}EN{#}] {0E}The last been installed platform name is{#} {0C}NOT FOUND{#}.{\n}
%CECHO% [{0F}RU{#}] {0E}Ïîñëåäíÿÿ óñòàíàâëèâàåìàÿ ïëàòôîðìà{#} {0C}ÍÅ ÎÁÍÀÐÓÆÅÍÀ{#}.{\n}
%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
echo.

:LAST_TARGET_NAME_NOT_FOUND_END

rem --------------------------------------------------------------------------------

call :PRINT_SELECT_TARGET
%CECHO% ^({06}a{#}^) all_in_one %ALL_IN_ONE_SEPARATOR0%- %TARGET_DESC.all_in_one[EN]%{\n}
%CECHO%                %ALL_IN_ONE_SEPARATOR0%  %TARGET_DESC.all_in_one[RU]%{\n}
%CECHO% ^({06}c{#}^) [{0F}EN{#}] {06}Cancel{#} %?01% [{0F}RU{#}] {06}Îòìåíà{#}{\n}
goto PRINT_SELECT_TARGET_END

:PRINT_SELECT_TARGET
set TARGET_INDEX=1
set NUM_TARGETS=0

%CECHO% [{0F}EN{#}] {06}Select platform to preinstall{#}:{\n}
%CECHO% [{0F}RU{#}] {06}Âûáåðèòå ïëàòôîðìó äëÿ ïðåäóñòàíîâêè{#}:{\n}
echo.

:PRINT_SELECT_TARGET_LOOP
set "TARGET_NAME="
for /F "eol=%EOLTAB% tokens=%TARGET_INDEX% delims= " %%i in ("%TARGETS_LIST%") do set "TARGET_NAME=%%i"

set "TARGET_SEPARATOR0="
for /F "eol=%EOLTAB% tokens=%TARGET_INDEX% delims=|" %%i in ("%TARGETS_SEPARATOR_LIST%") do set "TARGET_SEPARATOR0=%%i"

if not defined TARGET_NAME (
  set /A NUM_TARGETS=%TARGET_INDEX%-1
  exit /b 0
)

set "TARGET_INDEX_CECHO_COLOR={06}"
set "TARGET_NAME_CECHO_COLOR="
set "TARGET_DESC_CECHO_COLOR="
if defined ROOTSETUP_TARGET_NAME ^
if "%ROOTSETUP_TARGET_NAME%" == "%TARGET_NAME%" (
  set "TARGET_INDEX_CECHO_COLOR={0E}"
  set "TARGET_NAME_CECHO_COLOR={0F}"
  set "TARGET_DESC_CECHO_COLOR={0F}"
)

call %%CECHO%% ^(%%TARGET_INDEX_CECHO_COLOR%%%%TARGET_INDEX%%{#}^) %%TARGET_NAME_CECHO_COLOR%%%%TARGET_NAME%%{#} %%TARGET_SEPARATOR0%%- %%TARGET_DESC_CECHO_COLOR%%%%TARGET_DESC.%TARGET_NAME%%%{#}{\n}

set /A TARGET_INDEX+=1

goto PRINT_SELECT_TARGET_LOOP

:PRINT_SELECT_TARGET_END
%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {06}Type the number or label{#} ^| [{0F}RU{#}] {06}Ââåäèòå ÷èñëî èëè ìåòêó{#}{0F}^>{#} 
set "TARGET_INDEX="
set /P TARGET_INDEX=
echo.

set TARGET_INDEX_OK=0

if not defined TARGET_INDEX goto CHECK_TARGET_INDEX

if "%TARGET_INDEX%" == "c" goto CANCEL
if "%TARGET_INDEX%" == "a" (
  set TARGET_INDEX_OK=1
  set TARGET_NAME=*
  goto TARGET_NAME_SELECT_END
)

if %TARGET_INDEX% GTR 0 if %TARGET_INDEX% LEQ %NUM_TARGETS% set TARGET_INDEX_OK=1

:CHECK_TARGET_INDEX
if %TARGET_INDEX_OK% EQU 0 (
  %CECHO% %?~nx0%: {0C}error{#}: incorrect value{\n}
  echo.
  goto PRINT_SELECT_TARGET_END
) >&2

set "TARGET_NAME="
for /F "eol=%EOLTAB% tokens=%TARGET_INDEX% delims= " %%i in ("%TARGETS_LIST%") do set "TARGET_NAME=%%i"

:TARGET_NAME_SELECT_END

call :PRINT_SELECT_APP_TARGET
%CECHO% ^({06}c{#}^) [{0F}EN{#}] {06}Cancel{#} %?01% [{0F}RU{#}] {06}Îòìåíà{#}{\n}
goto PRINT_SELECT_APP_TARGET_END

rem --------------------------------------------------------------------------------

:PRINT_SELECT_APP_TARGET
set ROOTSETUP.APP_TARGET_INDEX=1
set ROOTSETUP.NUM_APP_TARGETS=0

%CECHO% [{0F}EN{#}] {06}What installation scenario/options issue by default{#}?{\n}
%CECHO% [{0F}RU{#}] {06}Êàêîé ñöåíàðèé/îïöèè óñòàíîâêè ïðåäëîæèòü ïî-óìîë÷àíèþ{#}?{\n}
echo.

:PRINT_SELECT_APP_TARGET_LOOP
set "ROOTSETUP.APP_TARGET_NAME="
for /F "eol=%EOLTAB% tokens=%ROOTSETUP.APP_TARGET_INDEX% delims= " %%i in ("%ROOTSETUP.APP_TARGETS_LIST%") do set "ROOTSETUP.APP_TARGET_NAME=%%i"

set "ROOTSETUP.APP_TARGET_DESC_NAME="
for /F "eol=%EOLTAB% tokens=%ROOTSETUP.APP_TARGET_INDEX% delims= " %%i in ("%ROOTSETUP.APP_TARGETS_DESC_LIST%") do set "ROOTSETUP.APP_TARGET_DESC_NAME=%%i"

set "ROOTSETUP.APP_TARGET_SEPARATOR0="
for /F "eol=%EOLTAB% tokens=%ROOTSETUP.APP_TARGET_INDEX% delims=|" %%i in ("%ROOTSETUP.APP_TARGETS_SEPARATOR_LIST%") do set "ROOTSETUP.APP_TARGET_SEPARATOR0=%%i"

if not defined ROOTSETUP.APP_TARGET_NAME (
  set /A ROOTSETUP.NUM_APP_TARGETS=%ROOTSETUP.APP_TARGET_INDEX%-1
  exit /b 0
)

call %%CECHO%% ^({06}%%ROOTSETUP.APP_TARGET_INDEX%%{#}^) %%ROOTSETUP.APP_TARGET_DESC_NAME%% %%ROOTSETUP.APP_TARGET_SEPARATOR0%%- [{0F}EN{#}] %%ROOTSETUP.APP_TARGET_DESC[EN].%ROOTSETUP.APP_TARGET_NAME%%% %%?01%% [{0F}RU{#}] %%ROOTSETUP.APP_TARGET_DESC[RU].%ROOTSETUP.APP_TARGET_NAME%%%{\n}

set /A ROOTSETUP.APP_TARGET_INDEX+=1

goto PRINT_SELECT_APP_TARGET_LOOP

:PRINT_SELECT_APP_TARGET_END
%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {06}Type the number or label{#} ^| [{0F}RU{#}] {06}Ââåäèòå ÷èñëî èëè ìåòêó{#}{0F}^>{#} 
set "ROOTSETUP.APP_TARGET_INDEX="
set /P ROOTSETUP.APP_TARGET_INDEX=
echo.

set ROOTSETUP.APP_TARGET_INDEX_OK=0

if not defined ROOTSETUP.APP_TARGET_INDEX goto CHECK_APP_TARGET_INDEX

if "%ROOTSETUP.APP_TARGET_INDEX%" == "c" goto CANCEL

if %ROOTSETUP.APP_TARGET_INDEX% GTR 0 if %ROOTSETUP.APP_TARGET_INDEX% LEQ %ROOTSETUP.NUM_APP_TARGETS% set ROOTSETUP.APP_TARGET_INDEX_OK=1

:CHECK_APP_TARGET_INDEX
if %ROOTSETUP.APP_TARGET_INDEX_OK% EQU 0 (
  %CECHO% %?~nx0%: {0C}error{#}: incorrect value{\n}
  echo.
  goto PRINT_SELECT_APP_TARGET_END
) >&2

set "ROOTSETUP.APP_TARGET_NAME="
for /F "eol=%EOLTAB% tokens=%ROOTSETUP.APP_TARGET_INDEX% delims= " %%i in ("%ROOTSETUP.APP_TARGETS_LIST%") do set "ROOTSETUP.APP_TARGET_NAME=%%i"

:APP_TARGET_NAME_SELECT_END

rem --------------------------------------------------------------------------------

:DELETE_NOT_RELATED_TO_TARGET_FILES_ASK
set DELETE_NOT_RELATED_TO_TARGET_FILES_OK=0
if "%TARGET_NAME%" == "*" goto DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_END

%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {06}Do you want to{#} {0C}DELETE{#} {06}NOT RELATED TO SELECTED PLATFORM FILES from the installer{#}?{\n}
%CECHO% [{0F}RU{#}] {06}Õîòèòå{#} {0C}ÓÄÀËÈÒÜ{#} {06}ÔÀÉËÛ ÍÅ ÎÒÍÎÑßÙÈÅÑß Ê ÂÛÁÐÀÍÍÎÉ ÏËÀÒÔÎÐÌÅ èç èíñòàëëÿòîðà{#}?{\n}
echo.

:DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_REPEAT
%CECHO%          [{0F}EN{#}] {06}DELETE{#} ^| [{0F}RU{#}] {06}ÓÄÀËÈÒÜ{#} {0F}Y{#}es/{0F}n{#}o/{0F}c{#}ancel{0F}?{#} 
set "DELETE_NOT_RELATED_TO_TARGET_FILES="
set /P DELETE_NOT_RELATED_TO_TARGET_FILES=
echo.

if /i "%DELETE_NOT_RELATED_TO_TARGET_FILES%" == "y" ( set DELETE_NOT_RELATED_TO_TARGET_FILES_OK=1 & goto DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_END )
if not defined DELETE_NOT_RELATED_TO_TARGET_FILES ( set DELETE_NOT_RELATED_TO_TARGET_FILES_OK=1 & goto DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_END )
if /i "%DELETE_NOT_RELATED_TO_TARGET_FILES%" == "n" goto DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_END
if /i "%DELETE_NOT_RELATED_TO_TARGET_FILES%" == "c" goto CANCEL

goto DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_REPEAT

:DELETE_NOT_RELATED_TO_TARGET_FILES_ASK_END

rem --------------------------------------------------------------------------------

:DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK
set DELETE_NOT_RELATED_TO_APP_TARGET_FILES_OK=0
if "%ROOTSETUP.APP_TARGET_NAME%" == "*" goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END

call set "ROOTSETUP_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS=%%ROOTSETUP.%ROOTSETUP.APP_TARGET_NAME%.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%%"
if not defined ROOTSETUP_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END

%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {06}Do you want to{#} {0C}DELETE{#} {06}NOT RELATED TO SELECTED SCENARIO/OPTIONS FILES from the installer{#}?{\n}
%CECHO% [{0F}RU{#}] {06}Õîòèòå{#} {0C}ÓÄÀËÈÒÜ{#} {06}ÔÀÉËÛ ÍÅ ÎÒÍÎÑßÙÈÅÑß Ê ÂÛÁÐÀÍÍÎÌÓ ÑÖÅÍÀÐÈÞ èç èíñòàëëÿòîðà{#}?{\n}
echo.
for %%i in (%ROOTSETUP_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%) do (
  %CECHO%  * {0F}%%i{#}{\n}
)
echo.

:DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_REPEAT
%CECHO%          [{0F}EN{#}] {06}DELETE{#} ^| [{0F}RU{#}] {06}ÓÄÀËÈÒÜ{#} {0F}Y{#}es/{0F}n{#}o/{0F}c{#}ancel{0F}?{#} 
set "DELETE_NOT_RELATED_TO_APP_TARGET_FILES="
set /P DELETE_NOT_RELATED_TO_APP_TARGET_FILES=
echo.

if /i "%DELETE_NOT_RELATED_TO_APP_TARGET_FILES%" == "y" ( set DELETE_NOT_RELATED_TO_APP_TARGET_FILES_OK=1 & goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END )
if not defined DELETE_NOT_RELATED_TO_APP_TARGET_FILES ( set DELETE_NOT_RELATED_TO_APP_TARGET_FILES_OK=1 & goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END )
if /i "%DELETE_NOT_RELATED_TO_APP_TARGET_FILES%" == "n" goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END
if /i "%DELETE_NOT_RELATED_TO_APP_TARGET_FILES%" == "c" goto CANCEL

goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_REPEAT

:DELETE_NOT_RELATED_TO_APP_TARGET_FILES_ASK_END

rem --------------------------------------------------------------------------------

:DELETE_ALL_OTHER_FILES_ASK
set DELETE_ALL_OTHER_FILES_OK=0

%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {06}Do you want to{#} {0E}CHOOSE TO DELETE{#} {06}ALL OTHER COMPONENTS from the installer{#}:{\n}
%CECHO% [{0F}RU{#}] {06}Õîòèòå{#} {0E}ÂÛÁÐÀÒÜ ÄËß ÓÄÀËÅÍÈß{#} {06}ÂÑÅ ÎÑÒÀËÜÍÛÅ ÊÎÌÏÎÍÅÍÒÛ èç èíòàëëÿòîðà{#}:{\n}
echo.
for %%i in (%DIR_LIST_TO_REMOVE_EXCLUDE_PTTNS%) do (
  %CECHO%  * {0F}%%i{#}{\n}
)
echo.

:DELETE_ALL_OTHER_FILES_ASK_REPEAT
%CECHO%          [{0F}EN{#}] {06}DELETE{#} ^| [{0F}RU{#}] {06}ÓÄÀËÈÒÜ{#} {0F}y{#}es/{0F}N{#}o/{0F}c{#}ancel{0F}?{#} 
set "DELETE_ALL_OTHER_FILES="
set /P DELETE_ALL_OTHER_FILES=
echo.

if /i "%DELETE_ALL_OTHER_FILES%" == "y" ( set DELETE_ALL_OTHER_FILES_OK=1 & goto DELETE_ALL_OTHER_FILES_ASK_NEXT )
if not defined DELETE_ALL_OTHER_FILES goto DELETE_ALL_OTHER_FILES_ASK_END
if /i "%DELETE_ALL_OTHER_FILES%" == "n" goto DELETE_ALL_OTHER_FILES_ASK_END
if /i "%DELETE_ALL_OTHER_FILES%" == "c" goto CANCEL

goto DELETE_ALL_OTHER_FILES_ASK_REPEAT

:DELETE_ALL_OTHER_FILES_ASK_NEXT
set DELETE_ALL_OTHER_FILES_INDEX=0

:DELETE_ALL_OTHER_FILES_ASK_NEXT_LOOP
set DELETE_ALL_OTHER_FILES_OK[%DELETE_ALL_OTHER_FILES_INDEX%]=0

call set ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN=%%DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_%DELETE_ALL_OTHER_FILES_INDEX%%%
call set ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_DESC[EN]=%%DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_%DELETE_ALL_OTHER_FILES_INDEX%_DESC[EN]%%
call set ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_DESC[RU]=%%DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_%DELETE_ALL_OTHER_FILES_INDEX%_DESC[RU]%%

%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {0C}DELETE{#} {0F}%ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_DESC[EN]%{#}:{\n}
%CECHO% [{0F}RU{#}] {0C}ÓÄÀËÈÒÜ{#} {0F}%ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_DESC[RU]%{#}:{\n}
echo.
for %%i in (%ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN%) do (
  %CECHO%  * {0F}%%i{#}{\n}
)
echo.

:DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_REPEAT
%CECHO%          [{0F}EN{#}] {06}DELETE{#} ^| [{0F}RU{#}] {06}ÓÄÀËÈÒÜ{#} {0F}y{#}es/{0F}N{#}o/{0F}c{#}ancel{0F}?{#} 
set "DELETE_ALL_OTHER_FILES_IN_GROUP="
set /P DELETE_ALL_OTHER_FILES_IN_GROUP=
echo.

if /i "%DELETE_ALL_OTHER_FILES_IN_GROUP%" == "y" ( set DELETE_ALL_OTHER_FILES_OK[%DELETE_ALL_OTHER_FILES_INDEX%]=1 & goto DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_NEXT )
if not defined DELETE_ALL_OTHER_FILES_IN_GROUP goto DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_NEXT
if /i "%DELETE_ALL_OTHER_FILES_IN_GROUP%" == "n" goto DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_NEXT
if /i "%DELETE_ALL_OTHER_FILES_IN_GROUP%" == "c" goto CANCEL

goto DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_REPEAT

:DELETE_ALL_OTHER_FILES_IN_GROUP_ASK_NEXT
set /A DELETE_ALL_OTHER_FILES_INDEX+=1

if %DELETE_ALL_OTHER_FILES_INDEX% LSS %DIR_LIST_TO_REMOVE_EXCLUDE_PTTNS_GROUP_NUMS% goto DELETE_ALL_OTHER_FILES_ASK_NEXT_LOOP

:DELETE_ALL_OTHER_FILES_ASK_END

rem --------------------------------------------------------------------------------

%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {0C}WARNING{#}: {06}SCRIPT WILL UPDATE THE SETUP FILES INPLACE, DO YOU WANT TO PROCEED{#}?{\n}
%CECHO% [{0F}RU{#}] {0C}ÂÍÈÌÀÍÈÅ{#}: {06}ÑÊÐÈÏÒ ÁÓÄÅÒ ÎÁÍÎÂËßÒÜ/ÓÄÀËßÒÜ ÔÀÉËÛ ÈÍÑÒÀËËßÒÎÐÀ, ÏÐÈÑÒÓÏÈÒÜ{#}?{\n}
echo.

:TARGET_NAME_SELECT_REPEAT
%CECHO%          [{0F}EN{#}] {06}CONTINUE{#} ^| [{0F}RU{#}] {06}ÏÐÎÄÎËÆÈÒÜ{#} {0F}y{#}es/{0F}n{#}o{0F}?{#} 
set "CONTINUE="
set /P CONTINUE=
echo.

if /i "%CONTINUE%" == "y" goto PROCESS_SETUPS
if /i "%CONTINUE%" == "n" goto CANCEL

goto TARGET_NAME_SELECT_REPEAT

rem --------------------------------------------------------------------------------

:PROCESS_SETUPS
echo.Preinstalling setup files inplace...

if %DELETE_NOT_RELATED_TO_APP_TARGET_FILES_OK% EQU 0 goto DELETE_NOT_RELATED_TO_APP_TARGET_FILES_END

rem process root setup targets
set "FOUND_APP_TARGET_NAME="
set "APP_TARGET_PREFIX=ROOTSETUP."
call :PROCESS_PREFIX_PREINSTALL

if defined FOUND_APP_TARGET_NAME call :DELETE_NOT_RELATED_TO_APP_TARGET_FILES

:DELETE_NOT_RELATED_TO_APP_TARGET_FILES_END

if %DELETE_NOT_RELATED_TO_TARGET_FILES_OK% EQU 0 goto DELETE_NOT_RELATED_TO_TARGET_FILES_END

rem process ApplicationX targets
set "FOUND_APP_TARGET_NAME="
set "APP_TARGET_PREFIX=APPX."
call :PROCESS_PREFIX_PREINSTALL

if defined FOUND_APP_TARGET_NAME call :DELETE_NOT_RELATED_TO_TARGET_FILES

:DELETE_NOT_RELATED_TO_TARGET_FILES_END

if %DELETE_ALL_OTHER_FILES_OK% NEQ 0 call :DELETE_ALL_OTHER_FILES

goto PROCESS_SETUPS_EXE

:PROCESS_PREFIX_PREINSTALL
setlocal

call set "APP_TARGETS_LIST=%%%APP_TARGET_PREFIX%APP_TARGETS_LIST%%"

for %%i in (%APP_TARGETS_LIST%) do (
  set "APP_TARGET_NAME=%%i"
  call :PROCESS_APP_TARGET || goto PROCESS_PREFIX_PREINSTALL_EXIT
)
exit /b 0

:PROCESS_PREFIX_PREINSTALL_EXIT
(
  endlocal
  set "FOUND_APP_TARGET_NAME=%FOUND_APP_TARGET_NAME%"
)
exit /b

:PROCESS_APP_TARGET
call set "TARGETS_LIST_IN_APP_TARGET=%%%APP_TARGET_PREFIX%%APP_TARGET_NAME%.TARGETS_LIST%%"
if defined TARGETS_LIST_IN_APP_TARGET (
  for %%i in (%TARGETS_LIST_IN_APP_TARGET%) do (
    set "TARGET_NAME_IN_APP_TARGET=%%i"
    call :PROCESS_TARGET_NAME_IN_APP_TARGET || exit /b
  )
) else (
  set "FOUND_APP_TARGET_NAME=%ROOTSETUP.APP_TARGET_NAME%"
  exit /b 1
)
exit /b 0

:PROCESS_TARGET_NAME_IN_APP_TARGET
if "%TARGET_NAME_IN_APP_TARGET%" == "%TARGET_NAME%" (
  set "FOUND_APP_TARGET_NAME=%APP_TARGET_NAME%"
  exit /b 1
)
exit /b 0

:DELETE_NOT_RELATED_TO_APP_TARGET_FILES
setlocal

call set "APP_TARGETS_LIST_TO_REMOVE=%%%APP_TARGET_PREFIX%APP_TARGETS_LIST%%"

for %%i in (%APP_TARGETS_LIST_TO_REMOVE%) do (
  if not "%%i" == "%FOUND_APP_TARGET_NAME%" (
    set "APP_TARGET_TO_REMOVE=%%i"
    call :REMOVE_APP_TARGET_EXCLUDE_FILES
  )
)
echo.

for %%i in (%APP_TARGETS_LIST_TO_REMOVE%) do (
  if "%%i" == "%FOUND_APP_TARGET_NAME%" (
    set "APP_TARGET_TO_REMOVE=%%i"
    call :REMOVE_APP_TARGET_INCLUDE_DIRS
  )
)
echo.
exit /b 0

:DELETE_NOT_RELATED_TO_TARGET_FILES
setlocal

call set TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS=%%%TARGET_PREFIX%%TARGET_NAME%.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%%
if defined TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS call set TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS=%TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%
if defined TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS (
  for %%i in (%TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%) do (
    set DIR_TO_REMOVE_PTTN=%%i
    call :REMOVE_DIR
  )
)
echo.
exit /b 0

:REMOVE_APP_TARGET_EXCLUDE_FILES
set "APP_TARGET_NAME=%APP_TARGET_TO_REMOVE%"
call set FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS=%%%APP_TARGET_PREFIX%%APP_TARGET_NAME%.FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS%%
if defined FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS call set FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS=%FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS%
if defined FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS (
  for %%i in (%FILE_LIST_TO_REMOVE_EXCLUDE_PTTNS%) do (
    set FILE_TO_REMOVE_PTTN=%%i
    call :REMOVE_FILE
  )
)
exit /b 0

:REMOVE_APP_TARGET_INCLUDE_DIRS
set "APP_TARGET_NAME=%APP_TARGET_TO_REMOVE%"
call set APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS=%%%APP_TARGET_PREFIX%%APP_TARGET_NAME%.DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%%
if defined APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS call set APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS=%APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%
if defined APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS (
  for %%i in (%APP_TARGET_DIR_LIST_TO_REMOVE_INCLUDE_PTTNS%) do (
    set DIR_TO_REMOVE_PTTN=%%i
    call :REMOVE_DIR
  )
)
exit /b 0

:DELETE_ALL_OTHER_FILES
set DELETE_ALL_OTHER_FILES_INDEX=0

:DELETE_ALL_OTHER_FILES_LOOP
call set DELETE_ALL_OTHER_FILES_IN_GROUP_OK=%%DELETE_ALL_OTHER_FILES_OK[%DELETE_ALL_OTHER_FILES_INDEX%]%%
if %DELETE_ALL_OTHER_FILES_IN_GROUP_OK% EQU 0 goto DELETE_ALL_OTHER_FILES_NEXT

call set ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN=%%DIR_LIST_TO_REMOVE_EXCLUDE_PTTN_%DELETE_ALL_OTHER_FILES_INDEX%%%

for %%i in (%ROOTSETUP_DIR_LIST_TO_REMOVE_EXCLUDE_PTTN%) do (
  set DIR_TO_REMOVE_PTTN=%%i
  call :REMOVE_DIR
)

:DELETE_ALL_OTHER_FILES_NEXT
set /A DELETE_ALL_OTHER_FILES_INDEX+=1

if %DELETE_ALL_OTHER_FILES_INDEX% LSS %DIR_LIST_TO_REMOVE_EXCLUDE_PTTNS_GROUP_NUMS% goto DELETE_ALL_OTHER_FILES_LOOP

exit /b 0

:REMOVE_FILE
if ^%FILE_TO_REMOVE_PTTN:~0,1%/ == ^"/ (
  call set "FILE_TO_REMOVE=%FILE_TO_REMOVE_PTTN:~1,-1%"
) else (
  set "FILE_TO_REMOVE=%FILE_TO_REMOVE_PTTN%"
)
call :DEL_FILE "%%SETUP_ROOT%%\%%FILE_TO_REMOVE%%"
exit /b 0

:REMOVE_DIR
if ^%DIR_TO_REMOVE_PTTN:~0,1%/ == ^"/ (
  call set "DIR_TO_REMOVE=%DIR_TO_REMOVE_PTTN:~1,-1%"
) else (
  set "DIR_TO_REMOVE=%DIR_TO_REMOVE_PTTN%"
)
rem if not exist "%SETUP_ROOT%\%DIR_TO_REMOVE%" exit /b 1
call :RMDIR "%%SETUP_ROOT%%\%%DIR_TO_REMOVE%%"
exit /b 0

:PROCESS_SETUPS_EXE
for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in (`dir "%SETUP_ROOT%\*.exe.dat" /A:-D /B /S 2^> nul`) do ( call :PROCESS_SETUP_EXE "%%i" || goto CANCEL )
echo.
goto PROCESS_SETUPS_EXE_END

:PROCESS_SETUP_EXE
set "SETUP_EXE_PATH=%~dpf1"
set "SETUP_EXE_FILE=%~nx1"
set "SETUP_EXE_DIR=%~dp1"
set "SETUP_EXE_DIR=%SETUP_EXE_DIR:~0,-1%"

set "SETUP_EXE_FILE_TO_RENAME=%~n1"

call :RENAME_FILE "%%SETUP_EXE_DIR%%" "%%SETUP_EXE_FILE%%" "%%SETUP_EXE_FILE_TO_RENAME%%" || goto :EOF
exit /b 0

:PROCESS_SETUPS_EXE_END

:PROCESS_SETUPS_INI
for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in (`dir "%SETUP_ROOT%\setup.ini" /A:-D /B /S 2^> nul`) do ( call :PROCESS_SETUP_INI "%%i" || goto CANCEL )
goto PROCESS_SETUPS_INI_END

:PROCESS_SETUP_INI
set "SETUP_INI_PATH=%~dpf1"
set "SETUP_INI_FILE=%~nx1"
set "SETUP_INI_DIR=%~dp1"
set "SETUP_INI_DIR=%SETUP_INI_DIR:~0,-1%"

findstr /R /C:"^TARGET_NAME=" "%SETUP_INI_PATH%" > nul
if %ERRORLEVEL% NEQ 0 exit /b 0

call :RENAME_FILE_W_SUBST "%%SETUP_INI_DIR%%" "%%SETUP_INI_FILE%%" "%%SETUP_INI_FILE%%.tmp" || goto :EOF
call :COPY_WITH_SUBST_FILE || goto :EOF
exit /b 0

:COPY_WITH_SUBST_FILE
rem batch exclusive file write lock w/ truncation
set FILE_CREATED=0
(
  rem create empty file
  (
    rem drop error level
    cd .
  ) > "%SETUP_INI_PATH%" && set FILE_CREATED=1
) 2> nul

if %FILE_CREATED% EQU 0 (
  %CECHO% %?~nx0%: {0C}error{#}: failed to create file: "{06}%SETUP_INI_DIR%\%SETUP_INI_PATH%{#}"{\n}>&2
  exit /b 1
)

for /F "usebackq eol=%EOLTAB% tokens=* delims=" %%i in ("%SETUP_INI_DIR%\%SETUP_INI_FILE%.tmp") do ( call :PROCESS_COPY_WITH_SUBST_FILE_LINE "%%i" || goto :EOF )

del /A:-D /F /Q "%SETUP_INI_DIR%\%SETUP_INI_FILE%.tmp"

exit /b 0

:PROCESS_COPY_WITH_SUBST_FILE_LINE
set "STR=%~1"
if defined STR (
  if "TARGET_NAME={{TARGET_NAME}}" == "%STR:~0,27%" (
    set "STR=TARGET_NAME=%TARGET_NAME%"
  ) else if "APP_TARGET_NAME={{APPA_APP_TARGET_NAME}}" == "%STR:~0,42%" (
    set "STR=APP_TARGET_NAME=%ROOTSETUP.APP_TARGET_NAME%"
  )
)
(
  echo.%STR%
) >> "%SETUP_INI_DIR%\%SETUP_INI_FILE%"
exit /b 0

:PROCESS_SETUPS_INI_END

:PROCESS_PREFIX_PREINSTALL_END
echo.

rem update only
set SELF_DELETE=0
if %FLAG_U% EQU 0 set SELF_DELETE=1

if %SELF_DELETE% NEQ 0 call :DEL_FILE "%%~dpf0"

echo.
%CECHO% {0A}OK{#}{\n}
echo.

if %SELF_DELETE% EQU 0 (
  pause
  exit /b 0
)

rem delete this script after preinstall with timeout prefix and exit immediately
timeout /t 1 /nobreak > nul

:REPEAT_DEL_AT_EXIT
del /A:-D /F /Q "%~dpf0" 2> nul & if exist "%~dpf0" ( goto REPEAT_DEL_AT_EXIT ) else ( pause & exit /b 0 )

:CANCEL
%CECHO% {0F}--------------------------------------------------------------------------------{#}{\n}
%CECHO% [{0F}EN{#}] {0C}Canceled{#} ^| [{0F}RU{#}] {0C}Îòìåíåíî{#}{0F}!{#}{\n}
pause

exit /b -1

:RENAME_FILE
setlocal

set "FILE_DIR=%~dpf1"
set "FILE_NAME_FROM=%~2"
set "FILE_NAME_TO=%~3"

echo.^>rename: "%FILE_DIR%\%FILE_NAME_FROM%" -^> "%FILE_NAME_TO%"
goto RENAME_FILE_IMPL

:RENAME_FILE_W_SUBST
setlocal

set "FILE_DIR=%~dpf1"
set "FILE_NAME_FROM=%~2"
set "FILE_NAME_TO=%~3"

echo.^>rename: "%FILE_DIR%\%FILE_NAME_FROM%" ^<-^> "%FILE_NAME_TO%"

:RENAME_FILE_IMPL
call :GET_ROOT_PATH_SUFFIX_DECORATED "%%SETUP_ROOT%%" "%%FILE_DIR%%"
if not exist "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%" mkdir "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%"

copy /Y /B "%FILE_DIR%\%FILE_NAME_FROM%" "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%%FILE_NAME_FROM%" > nul

if exist "%FILE_DIR%\%FILE_NAME_FROM%" del /A:-D /F /Q "%FILE_DIR%\%FILE_NAME_TO%" 2> nul
rename "%FILE_DIR%\%FILE_NAME_FROM%" "%FILE_NAME_TO%" || (
  echo.
  %CECHO% %?~nx0%: {0C}error{#}: failed to process file: "{06}%FILE_DIR%\%FILE_NAME_FROM%{#}"{\n}>&2
  exit /b 1
)

exit /b 0

:DEL_FILE
setlocal

set "FILE_TO_REMOVE=%~dpf1"
set "FILE_DIR_TO_REMOVE=%~dp1"
set "FILE_NAME_TO_REMOVE=%~nx1"

echo.^>del: "%FILE_TO_REMOVE%"

call :GET_ROOT_PATH_SUFFIX_DECORATED "%%SETUP_ROOT%%" "%%FILE_DIR_TO_REMOVE%%."
if not exist "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%" mkdir "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%"

copy /Y /B "%FILE_TO_REMOVE%" "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%%FILE_NAME_TO_REMOVE%" > nul

rem drop last error level
cd .

rem ignore remove self script
if /i not "%~dpf0" == "%FILE_TO_REMOVE%" del /F /Q /A:-D "%FILE_TO_REMOVE%"

exit /b

:RMDIR
setlocal

set "DIR_PATH=%~dpf1"

echo.^>rmdir: "%DIR_PATH%"

call :GET_ROOT_PATH_SUFFIX_DECORATED "%%SETUP_ROOT%%" "%%DIR_PATH%%"
if not exist "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%" mkdir "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%"

for /F "usebackq tokens=1,* delims=:" %%i in (`chcp 2^> nul`) do set LAST_CODE_PAGE=%%j
set LAST_CODE_PAGE=%LAST_CODE_PAGE: =%

rem switch locale into english compatible locale
chcp 65001 > nul

rem save directory to restore later,
rem echo.D will only work if locale is in english !!!
rem echo.^>^>xcopy "%DIR_PATH%" "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%"
echo.D|xcopy "%DIR_PATH%" "%TEMP_PREINSTALL_DIR%\%ROOT_PATH_SUFFIX%" /E /Y
echo.

rem echo.^>^>rmdir /S /Q "%DIR_PATH%"
rmdir /S /Q "%DIR_PATH%"
set LASTERROR=%ERRORLEVEL%

rem restore locale
if not "%LAST_CODE_PAGE%" == "65001" chcp %LAST_CODE_PAGE% > nul

exit /b %LASTERROR%

:GET_ROOT_PATH_SUFFIX_DECORATED
setlocal

set "ROOT_PATH=%~dpf1"
set "FILE_PATH=%~dpf2\"

rem replace system characters to avoid interference with them
call :REPLACE_SYS_CHARS FILE_PATH
call :REPLACE_SYS_CHARS ROOT_PATH

call set "FILE_PATH_SUFFIX=%%FILE_PATH:%ROOT_PATH%\=%%"

rem restore system characters
call :RESTORE_SYS_CHARS FILE_PATH_SUFFIX
call :RESTORE_SYS_CHARS FILE_PATH
call :RESTORE_SYS_CHARS ROOT_PATH

set "ROOT_PATH_SUFFIX="
set "ROOT_PATH_SUFFIX_DECORATED="

if not defined FILE_PATH_SUFFIX goto GET_ROOT_PATH_SUFFIX_DECORATED_EXIT

rem relative or absolute
if /i not "%ROOT_PATH%\%FILE_PATH_SUFFIX%" == "%FILE_PATH%" set "FILE_PATH_SUFFIX=%FILE_PATH%"

if "%FILE_PATH_SUFFIX:~-1%" == "\" set "FILE_PATH_SUFFIX=%FILE_PATH_SUFFIX:~0,-1%"
set "ROOT_PATH_SUFFIX_DECORATED=%FILE_PATH_SUFFIX%"

rem ignore characters replace if relative
if not defined FILE_PATH_SUFFIX goto IGNORE_ROOT_PATH_SUFFIX_DECORATE
if not "%FILE_PATH_SUFFIX:~1,1%" == ":" goto IGNORE_ROOT_PATH_SUFFIX_DECORATE

set "ROOT_PATH_SUFFIX_DECORATED=%ROOT_PATH_SUFFIX_DECORATED::=--%"
set "ROOT_PATH_SUFFIX_DECORATED=%ROOT_PATH_SUFFIX_DECORATED:\=--%"

:IGNORE_ROOT_PATH_SUFFIX_DECORATE
if defined ROOT_PATH_SUFFIX_DECORATED set "ROOT_PATH_SUFFIX=%ROOT_PATH_SUFFIX_DECORATED%\"

:GET_ROOT_PATH_SUFFIX_DECORATED_EXIT
(
  endlocal
  set "ROOT_PATH_SUFFIX=%ROOT_PATH_SUFFIX%"
)

exit /b 0

:GET_ROOT_PATH_SUFFIX
setlocal

set "ROOT_PATH=%~dpf1"
set "FILE_PATH=%~dpf2\"

rem replace system characters to avoid interference with them
call :REPLACE_SYS_CHARS FILE_PATH
call :REPLACE_SYS_CHARS ROOT_PATH

call set "FILE_PATH_SUFFIX=%%FILE_PATH:%ROOT_PATH%\=%%"

rem restore system characters
call :RESTORE_SYS_CHARS FILE_PATH_SUFFIX
call :RESTORE_SYS_CHARS FILE_PATH
call :RESTORE_SYS_CHARS ROOT_PATH

set "ROOT_PATH_SUFFIX="

if not defined FILE_PATH_SUFFIX goto GET_ROOT_PATH_SUFFIX_EXIT

rem relative or absolute
if /i not "%ROOT_PATH%\%FILE_PATH_SUFFIX%" == "%FILE_PATH%" set "FILE_PATH_SUFFIX=%FILE_PATH%"

if "%FILE_PATH_SUFFIX:~-1%" == "\" set "FILE_PATH_SUFFIX=%FILE_PATH_SUFFIX:~0,-1%"

:GET_ROOT_PATH_SUFFIX_EXIT
(
  endlocal
  set "ROOT_PATH_SUFFIX=%FILE_PATH_SUFFIX%\"
)

exit /b 0

:REPLACE_SYS_CHARS
setlocal DISABLEDELAYEDEXPANSION

set "__VAR__=%~1"

if not defined __VAR__ exit /b 1

rem ignore empty variables
call set "STR=%%%__VAR__%%%"
if not defined STR exit /b 0

set ?00=!

call set "STR=%%%__VAR__%:!=?00%%"

setlocal ENABLEDELAYEDEXPANSION

set STR=!STR:%%=?01!
set "STR_TMP="
set INDEX=1

:EQUAL_CHAR_REPLACE_LOOP
set "STR_TMP2="
for /F "tokens=%INDEX% delims== eol=" %%i in ("/!STR!/") do set STR_TMP2=%%i
if not defined STR_TMP2 goto EQUAL_CHAR_REPLACE_LOOP_END
set "STR_TMP=!STR_TMP!!STR_TMP2!?02"
set /A INDEX+=1
goto EQUAL_CHAR_REPLACE_LOOP

:EQUAL_CHAR_REPLACE_LOOP_END
if defined STR_TMP set STR=!STR_TMP:~1,-4!

(
  endlocal
  endlocal
  set "%__VAR__%=%STR%"
)

exit /b 0

:RESTORE_SYS_CHARS
setlocal DISABLEDELAYEDEXPANSION

set "__VAR__=%~1"

if not defined __VAR__ exit /b 1

rem ignore empty variables
call set "STR=%%%__VAR__%%%"
if not defined STR exit /b 0

setlocal ENABLEDELAYEDEXPANSION

set STR=!STR:?01=%%!
set STR=!STR:?02==!

(
  endlocal
  set "STR=%STR%"
)

set "STR=%STR:?00=!%"

(
  endlocal
  set "%__VAR__%=%STR%"
)

exit /b 0

:REVERT_POSTPROCESS
if not defined SCRIPT_SELF_REVERT_FROM_PATH exit /b 0

:REPEAT_COPY_AT_EXIT
echo.copy: "%SCRIPT_SELF_REVERT_FROM_PATH%" -^> "%SCRIPT_SELF_REVERT_TO_PATH%"
copy /Y /B "%SCRIPT_SELF_REVERT_FROM_PATH%" "%SCRIPT_SELF_REVERT_TO_PATH%" > nul && ( pause & exit /b 0 )
goto REPEAT_COPY_AT_EXIT
