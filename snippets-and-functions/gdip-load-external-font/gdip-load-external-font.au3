#include <APIGdiConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WinAPIGdi.au3>

$iSuccess = _WinAPI_AddFontResourceEx(@ScriptDir&"\font\Android.ttf", $FR_PRIVATE,False)
If $iSuccess=0 Then Exit MsgBox(0, "", "Font did not load successfully")


GUICreate('Test ' & StringReplace(@ScriptName, '.au3', '()'), 400, 100)
GUICtrlCreateLabel('Simple Text', 10, 25, 380, 50, $SS_CENTER)
GUICtrlSetFont(-1, 38, -1, -1, 'Android')
GUICtrlSetColor(-1, 0xF06000)
GUISetState(@SW_SHOW)

Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE
