#include <WinAPISys.au3>
#include <Clipboard.au3>
;~ #include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
;~ #include <Array.au3>

; Title: Clipboard HTML Monitor
; Description: Monitors clipboard for HTML format and extracts URLs using Regex.

;~ $CF_HTML = 49261
;~ $CF_HTML = 49309;wtf!
;~ Global Const $CF_HTML = 0xC06D
Global Const $CF_HTML = _ClipBoard_RegisterFormat("HTML Format")

If $CF_HTML = 0 Then
	ConsoleWrite("!> "&_WinAPI_GetLastError()&@CRLF)
	Exit
EndIf

Global $hWnd = GUICreate("Title", 700, 320, -1, -1)

If Not _WinAPI_AddClipboardFormatListener($hWnd) Then
	ConsoleWrite("!> "&_WinAPI_GetLastError()&@CRLF)
	Exit
EndIf

OnAutoItExitRegister("_CleanUp")

GUIRegisterMsg($WM_CLIPBOARDUPDATE, 'WM_CLIPBOARDUPDATE')

;~ MsgBox(0, "", $CF_TEXT&@CRLF&$CF_OEMTEXT)

While 1
	Sleep(10)
WEnd

Func _CleanUp()
	_WinAPI_RemoveClipboardFormatListener($hWnd)
	GUIDelete($hWnd)
EndFunc

Func WM_CLIPBOARDUPDATE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	If Not _ClipBoard_IsFormatAvailable($CF_HTML) Then Return 0
	If Not _ClipBoard_Open(0) Then Return 0
	Local $hMemory = _ClipBoard_GetDataEx($CF_HTML)
	If $hMemory = 0 Then
		_ClipBoard_Close()
		Return 0
	EndIf
	Local $pMemoryBlock = _MemGlobalLock($hMemory)
	If $pMemoryBlock = 0 Then
		_ClipBoard_Close()
		Return 0
	EndIf
	Local $iDataSize = _MemGlobalSize($hMemory)
	If $iDataSize = 0 Then
		_MemGlobalUnlock($hMemory)
		_ClipBoard_Close()
		Return 0
	EndIf
;~ 	Local $tData = DllStructCreate("byte[" & $iDataSize & "]", $pMemoryBlock)
	Local $tData = DllStructCreate("char[" & $iDataSize & "]", $pMemoryBlock)
;~ 	$iDataSize = Round($iDataSize / 2)
;~ 	Local $tData = DllStructCreate("wchar[" & $iDataSize & "]", $pMemoryBlock)
	Local $vReturn = DllStructGetData($tData, 1)
	Local $q = StringRegExp(DllStructGetData($tData, 1), "StartHTML:([0-9]+)", 1)
	Local $a = StringRegExp(DllStructGetData($tData, 1), "(http(?:s)?\://(?:www.)?[a-zA-Z0-9.\-_/%?=&#]+)", 3, Number($q[0])+1)
;~ 	Local $a = StringRegExp(DllStructGetData($tData, 1), "(?s)(.+)", 3, Number($q[0])+1);for testing where the offset starts (includes line breaks)
	_MemGlobalUnlock($hMemory)
	_ClipBoard_Close()
;~ 	ConsoleWrite($vReturn&@CRLF)
#cs
	For $i=0 To UBound($a, 1)-1
		ConsoleWrite("["&$i&"]: "&$a[$i]&@CRLF)
	Next
#ce
	Return 0
EndFunc   ;==>WM_CLIPBOARDUPDATE
