@echo off
setlocal enabledelayedexpansion

REM 检查 7-Zip 是否可用
where 7z >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 7z 命令，请确保 7-Zip 已安装并已添加到系统 PATH。
    pause
    exit /b 1
)

REM 递归遍历当前目录及所有子目录下的文件
for /r %%f in (*) do (
    REM 跳过已经是压缩包的文件，避免重复处理
    if not "%%~xf"==".7z" if not "%%~xf"==".zip" if not "%%~xf"==".rar" (

        REM 获取文件大小（字节）
        set "size=%%~zf"
        REM 100 MB = 104857600 字节
        if !size! gtr 104857600 (

            echo 正在处理: %%f
            REM 压缩文件，分卷 99 MB，压缩等级 5，输出到原文件所在目录
            7z a -v99m -mx5 "%%~dpnf.7z" "%%f"

            if !errorlevel! equ 0 (
                echo 压缩成功，正在删除源文件: %%f
                del /f /q "%%f"
            ) else (
                echo 压缩失败，保留源文件: %%f
            )
        )
    )
)

echo 所有文件处理完成。
pause