#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
Opt("GUiOnEventMode", 1)
GUICreate("test", 300, 300)
GUISetState()
GUISetOnEvent(-3, "close")
GUIRegisterMsg($WM_MOVE, "moved")
While 1
    Sleep(100)
WEnd

Func close()
    Exit
EndFunc   ;==>close

Func moved()
    $pos = WinGetPos("test")
    If $pos[0] < 25 Then WinMove("test", "", 0, $pos[1])
    If $pos[1] < 25 Then WinMove("test", "", $pos[0], 0)
    If $pos[0] + 300 > @DesktopWidth - 25 Then WinMove("test", "", @DesktopWidth - 300, $pos[1])
    If $pos[1] + 300 > @DesktopHeight - 25 Then WinMove("test", "", $pos[0], @DesktopHeight - 300)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>moved
