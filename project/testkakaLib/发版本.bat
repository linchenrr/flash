@ECHO off
@ECHO 使用前编译环境配置:
@ECHO 1、将flex sdk的bin目录添加进系统path环境变量
@ECHO 2、将Adobe Flash Builder\jre目录添加进系统的JAVA_HOME变量(如果没有就新建一个)
@ECHO.
@ECHO 更新release目录

TortoiseProc.exe /command:update /path:"release" /closeonend:2

@ECHO.
@ECHO 开始编译文件...
@ECHO.

call :compileSwf SgtMain
call :compileSwf SgtPreloader

@ECHO.
@ECHO 编译完成
@ECHO.

@ECHO 加密SgtPreloader
flaze.exe release\SgtPreloader.swf -o 1 -c 1

@ECHO 复制文件到relsase

XCOPY "res" "release" /E/I/Y/Q/EXCLUDE:ex.txt
XCOPY "project\src" "release" /I/Y/Q/EXCLUDE:ex.txt

@ECHO 压缩指定文件
call :compress config.xml
call :compress asset\data\protocol.xml
call :compress asset\data\keyWord.txt
rem call :compress asset\map

@ECHO 第一次提交
TortoiseProc.exe /command:commit /path:"release" /closeonend:2

@ECHO 生成svn版本号、文件大小信息
"kakaTools 2.0\ResourceInfoMaker.exe" %cd%\release

call :compress fileInfo.txt

@ECHO 提交fileInfo.txt和buildVersion.js
TortoiseProc.exe /command:commit /path:"release" /closeonend:2

@ECHO 发布已完成
@pause

goto :eof
:compress
@ECHO 压缩%1
"kakaTools 2.0\fileCompressTool.exe" compress "" %cd%\release\%1

goto :eof
:compileSwf

@ECHO.
@echo 编译%1
@ECHO.

mxmlc project\src\%1.as -source-path project\lib -library-path project\lib -static-link-runtime-shared-libraries=true -output=release\%1.swf -incremental=true

rem @echo 编译结果:%errorlevel%

if %errorlevel%==0 (

@ECHO.
@echo 编译%1成功
@ECHO.

) else (
@echo 编译%1失败
@pause
exit
)