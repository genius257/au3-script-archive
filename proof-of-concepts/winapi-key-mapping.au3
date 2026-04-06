#include <WindowsConstants.au3>
#include <WinAPISys.au3>

opt("GuiOnEventMode", 1)

$hWnd = GUICreate("title", 700, 320)
GUISetState(@SW_SHOW, $hWnd)
GUISetOnEvent(-3, "MyExit", $hWnd)

$hLocale = _WinAPI_LoadKeyboardLayout(0x046d, $KLF_NOTELLSHELL)
ConsoleWrite($hLocale&@TAB&@error&@CRLF)
GUIRegisterMsg($WM_KEYUP, "WM_KEYUP")

While 1
    Sleep(10)
WEnd

Func WM_KEYUP($hWnd, $iMsg, $wParam, $lParam)
    $a = _WinAPI_MapVirtualKey($wParam, $MAPVK_VK_TO_CHAR, $hLocale)

    ConsoleWrite($a&@CRLF)
    ConsoleWrite(ChrW($a)&@CRLF)
EndFunc

Func MyExit()
    Exit
EndFunc
