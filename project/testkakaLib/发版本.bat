@ECHO off
@ECHO ʹ��ǰ���뻷������:
@ECHO 1����flex sdk��binĿ¼��ӽ�ϵͳpath��������
@ECHO 2����Adobe Flash Builder\jreĿ¼��ӽ�ϵͳ��JAVA_HOME����(���û�о��½�һ��)
@ECHO.
@ECHO ����releaseĿ¼

TortoiseProc.exe /command:update /path:"release" /closeonend:2

@ECHO.
@ECHO ��ʼ�����ļ�...
@ECHO.

call :compileSwf SgtMain
call :compileSwf SgtPreloader

@ECHO.
@ECHO �������
@ECHO.

@ECHO ����SgtPreloader
flaze.exe release\SgtPreloader.swf -o 1 -c 1

@ECHO �����ļ���relsase

XCOPY "res" "release" /E/I/Y/Q/EXCLUDE:ex.txt
XCOPY "project\src" "release" /I/Y/Q/EXCLUDE:ex.txt

@ECHO ѹ��ָ���ļ�
call :compress config.xml
call :compress asset\data\protocol.xml
call :compress asset\data\keyWord.txt
rem call :compress asset\map

@ECHO ��һ���ύ
TortoiseProc.exe /command:commit /path:"release" /closeonend:2

@ECHO ����svn�汾�š��ļ���С��Ϣ
"kakaTools 2.0\ResourceInfoMaker.exe" %cd%\release

call :compress fileInfo.txt

@ECHO �ύfileInfo.txt��buildVersion.js
TortoiseProc.exe /command:commit /path:"release" /closeonend:2

@ECHO ���������
@pause

goto :eof
:compress
@ECHO ѹ��%1
"kakaTools 2.0\fileCompressTool.exe" compress "" %cd%\release\%1

goto :eof
:compileSwf

@ECHO.
@echo ����%1
@ECHO.

mxmlc project\src\%1.as -source-path project\lib -library-path project\lib -static-link-runtime-shared-libraries=true -output=release\%1.swf -incremental=true

rem @echo ������:%errorlevel%

if %errorlevel%==0 (

@ECHO.
@echo ����%1�ɹ�
@ECHO.

) else (
@echo ����%1ʧ��
@pause
exit
)