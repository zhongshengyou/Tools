@echo off
setlocal

:: 设置源目录和目标目录
set SOURCE_DIR=/sdcard/pudu/log
set TARGET_DIR=G:\pudutech\debug-log\cc1_pro\sync-board\20250210

:: 创建目标目录（如果不存在）
::mkdir "%TARGET_DIR%"

:: 列出以 "Na" 开头的文件，并拉取
for /f "tokens=*" %%f in ('adb shell ls %SOURCE_DIR%/Na*') do (
    adb pull %%f %TARGET_DIR%\
    echo Pulled: %%f
)

:: 完成
echo All matching files have been pulled to %TARGET_DIR%
endlocal
pause