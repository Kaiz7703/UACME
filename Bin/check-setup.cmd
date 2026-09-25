@echo off
setlocal enabledelayedexpansion
title UACME - Kiem tra cau hinh

echo ==================================================
echo    UACME - KIEM TRA CAU HINH TRUOC KHI CHAY
echo ==================================================
echo.

set /a PASS=0
set /a FAIL=0

echo [1] Tai khoan hien tai
echo     --------------------------------------------
echo     User : %USERNAME%
echo     May  : %COMPUTERNAME%
echo.

rem ---------- 2. UAC phai BAT ----------
set LUA=
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA 2^>nul ^| findstr /i EnableLUA') do set LUA=%%a
if /i "!LUA!"=="0x1" (
    echo [2] UAC dang BAT ......................... [ PASS ]
    set /a PASS+=1
) else (
    echo [2] UAC dang BAT ......................... [ FAIL ]  EnableLUA=!LUA!
    echo         ^-^> Bat UAC: go "uac" o Start, keo len muc mac dinh, restart
    set /a FAIL+=1
)

rem ---------- 3. Thuoc nhom Administrators ----------
set ADMINGRP=0
for /f "delims=" %%a in ('whoami /groups ^| findstr /c:"S-1-5-32-544"') do set ADMINGRP=1
if "!ADMINGRP!"=="1" (
    echo [3] Thuoc nhom Administrators ........... [ PASS ]
    set /a PASS+=1
) else (
    echo [3] Thuoc nhom Administrators ........... [ FAIL ]
    echo         ^-^> Chay trong cmd ADMIN:  net localgroup Administrators %USERNAME% /add
    set /a FAIL+=1
)

rem ---------- 4. KHONG duoc elevated (High IL) ----------
set HIGHIL=0
for /f "delims=" %%a in ('whoami /groups ^| findstr /c:"S-1-16-12288"') do set HIGHIL=1
if "!HIGHIL!"=="1" (
    echo [4] Shell chua elevate .................. [ FAIL ]  dang la High IL
    echo         ^-^> Mo cmd THUONG bang Win+R -^> cmd  ^(dung dung Run as administrator^)
    set /a FAIL+=1
) else (
    echo [4] Shell chua elevate .................. [ PASS ]  Medium IL
    set /a PASS+=1
)

rem ---------- 5. Token admin bi loc (dau hieu quyet dinh) ----------
set DENYONLY=0
for /f "delims=" %%a in ('whoami /groups ^| findstr /c:"S-1-5-32-544" ^| findstr /c:"deny only"') do set DENYONLY=1
if "!DENYONLY!"=="1" (
    echo [5] Token admin bi loc .................. [ PASS ]  Limited token
    set /a PASS+=1
) else (
    echo [5] Token admin bi loc .................. [ FAIL ]  khong phai Limited token
    echo         ^-^> Nguyen nhan: user thuong, hoac da elevate, hoac UAC tat
    set /a FAIL+=1
)

echo.
echo ==================================================
echo    KET QUA:  PASS=!PASS!   FAIL=!FAIL!
echo ==================================================
echo.

if !FAIL! EQU 0 (
    echo [OK] Cau hinh DUNG. Chay thu:
    echo.
    echo        akagi64.exe 41
    echo.
    choice /c YN /m "    Chay thu akagi64.exe 41 ngay bay gio"
    if !errorlevel! EQU 1 (
        if exist "%~dp0Akagi64.exe" (
            echo.
            echo    Dang chay... neu thanh cong se mo 1 cua so cmd moi.
            echo    Kiem tra trong cua so do:  whoami /groups ^| findstr S-1-16-
            echo.
            pushd "%~dp0"
            Akagi64.exe 41
            echo    Exit code: !errorlevel!
            popd
        ) else (
            echo    Khong tim thay Akagi64.exe canh script nay.
        )
    )
) else (
    echo [X] Cau hinh CHUA DUNG - sua cac muc [ FAIL ] o tren roi chay lai.
)

echo.
pause
