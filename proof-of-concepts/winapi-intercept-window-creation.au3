#include <WinAPISys.au3>
#include <WinAPISysWin.au3>
#include <SendMessage.au3>
#include <WinAPI.au3>

Global Const $WM_CLOSE = 0x0010

; Description: POC for WinEventHooks to detect window creation and auto-close dialogs.
; Includes commented-out CBTProc hook alternative.


#cs
$CBTProc = DllCallbackRegister('CBTProc', "int", "int;int;int")

$hMod = 0;_WinAPI_GetModuleHandle(0)
$hTread = _WinAPI_GetCurrentThreadId()
$hHook = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($CBTProc), $hMod, $hTread)

;~ ConsoleWrite("$hHook"&$hHook&@CRLF)
If $hHook=0 Then Exit MsgBox(0, _WinAPI_GetLastError(), _WinAPI_GetLastErrorMessage())

Func CBTProc($nCode, $wParam, $lParam)
	ConsoleWrite("CBTProc"&@CRLF)
	If $nCode < 0 Then
        Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
    EndIf

	If $nCode = 5 Then ConsoleWrite("acticating window"&@CRLF)

	Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc

OnAutoItExitRegister('OnAutoItExit2')

$hGUI=GUICreate("", 0, 0)
;~ GUISetState(@SW_SHOW, $hGUI)

While 1
	Sleep(10)
WEnd

Func OnAutoItExit2()
    _WinAPI_UnhookWindowsHookEx($hHook)
    DllCallbackFree($CBTProc)
EndFunc   ;==>OnAutoItExit
#ce





















#AutoIt3Wrapper_UseX64=N

;~ $hGUI = GUICreate("", 0, 0)

Global Const $pEventProc = DllCallbackRegister('fEventProc', 'none', 'ptr;dword;hwnd;long;long;dword;dword')

Global Const $iPID = 0

Global Const $iThreadId = 0

Global Const $iFlags = $WINEVENT_OUTOFCONTEXT + $WINEVENT_SKIPOWNPROCESS

Global Const $hookId = _WinAPI_SetWinEventHook($EVENT_OBJECT_CREATE, $EVENT_OBJECT_CREATE, DllCallbackGetPtr($pEventProc), $iPID, $iThreadId);, $iFlags)
;~ Global Const $hookId = _WinAPI_SetWinEventHook($EVENT_MIN, $EVENT_MAX, DllCallbackGetPtr($pEventProc), $iPID, $iThreadId, $iFlags)

Run(@SystemDir & '\notepad.exe')

Func fEventProc($hEventHook, $iEvent, $hWnd, $iObjectID, $iChildID, $iThreadId, $iEventTime)
;~ 	ConsoleWrite("fEventProc"&@CRLF)
	If $hWnd == 0 Then Return

;~ 	ConsoleWrite(_WinAPI_GetClassName($hWnd)&@CRLF)

	If _WinAPI_GetClassName($hWnd) == "#32770" Then _SendMessage($hWnd, $WM_CLOSE);_WinAPI_DestroyWindow($hWnd)
EndFunc

OnAutoItExitRegister('OnAutoItExit')

While 1
	Sleep(10)
WEnd

Func OnAutoItExit()
    _WinAPI_UnhookWinEvent($hookId)
    DllCallbackFree($pEventProc)
EndFunc   ;==>OnAutoItExit
