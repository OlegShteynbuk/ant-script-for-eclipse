@echo off

rem check for JAVA_HOME added by Stephane RUCHET (ruchet@besancon.sema.slb.com) 13.02.2003 
rem vm arguments added by Oleg Shteynbuk (oleg_shteynbuk@yahoo.com) 12.02.2003  
rem complete rewrite by Stephane Ruchet (ruchet@besancon.sema.slb.com) 11.02.2003 
rem start and filtering added by Sascha Freitag (freitag@objtec.com) 14.1.2003
rem basic, one line by Oleg Shteynbuk (oleg_shteynbuk@yahoo.com)

set _AT_=@

rem check if external workspace is used
set workspace_dir=@home.workspace.dir@
if "%workspace_dir%"=="%_AT_%home.workspace.dir%_AT_%" goto internal_workspace
set WORKSPACE=-data %workspace_dir%
goto workspaceOK
:internal_workspace
set WORKSPACE=

:workspaceOK

rem set jvm
set javaVM=@custom.javaw@
if not "%javaVM%"=="%_AT_%custom.javaw%_AT_%" goto useJavaVM
rem check if JAVA_HOME exists
if "%JAVA_HOME%"=="" goto noJavaVM
set javaVM=%JAVA_HOME%\bin\javaw.exe

:useJavaVM
rem concat the -vm option to javaVM
set javaVM=-vm %javaVM%
goto javaOk
:noJavaVM
echo "using default JavaVM for eclipse"
set javaVM=

:javaOk

rem check if there are vm arguments 
set vmArgs=@vm.args@
if "%vmArgs%"=="%_AT_%vm.args%_AT_%" goto no_args
set vmArgs=-vmargs %vmArgs%
goto vmArgsOK
:no_args
set vmArgs=

:vmArgsOK


REM this will launch eclipse
start eclipse.exe %javaVM% %WORKSPACE% %vmArgs%
rem eclipse.exe %javaVM% %WORKSPACE% %vmArgs%

