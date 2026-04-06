#include <WinAPI.au3>
#include <GDIPlus.au3>

; Description: POC for centering a GDI+ Path (string) within a GUI client area using Matrix transformations.
; TODO: scale path to match client rect

Opt("GuiOnEventMode", 1)

$hWnd = GUICreate("Tetris", 700, 320)
GUISetState(@SW_SHOW, $hWnd)

_GDIPlus_Startup()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hWnd)

$hPen = _GDIPlus_PenCreate()

$hMatrix = _GDIPlus_MatrixCreate()
;~ _GDIPlus_MatrixScale($hMatrix, 3, 3)

$sString = "This is a test"&@CRLF&"This is test number 2"&@CRLF&"This is the final test"&@CRLF&"This is the final test"&@CRLF&"This is the final test"&@CRLF&"This is the final test"&@CRLF&"This is the final test"&@CRLF&"This is the final test"&@CRLF&"This is the final test???????????????????"
$iStyle  = 0
$fSize = 30
$hFormat = 0
$hFamily = _GDIPlus_FontFamilyCreate("Arial") ;Create font family object
$tLayout = _GDIPlus_RectFCreate() ;Create string bounding rectangle X=0, Y=0

$hPath = _GDIPlus_PathCreate()
;~ _GDIPlus_PathSetFillMode($hPath, 1)

_GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily, $iStyle, $fSize, $hFormat)

$aBounds = _GDIPlus_PathGetWorldBounds($hPath, 0, $hPen)

$tRect = _WinAPI_GetClientRect($hWnd)

If (($tRect.Right-$tRect.Left)<($aBounds[2]-$aBounds[0])) Or (($tRect.Bottom-$tRect.Top)<($aBounds[3]-$aBounds[1])) Then Exit MsgBox(0, "", "too big");TODO: scale path to match client rect

_GDIPlus_MatrixTranslate($hMatrix, ($tRect.Right-$tRect.Left)/2-($aBounds[2]-$aBounds[0])/2, ($tRect.Bottom-$tRect.Top)/2-($aBounds[3]-$aBounds[1])/2)

_GDIPlus_PathTransform($hPath, $hMatrix)

_GDIPlus_GraphicsDrawPath($hGraphics, $hPath, $hPen)

_GDIPlus_PathDispose($hPath)
_GDIPlus_PenDispose($hPen)
_GDIPlus_FontFamilyDispose($hFamily)
_GDIPlus_GraphicsDispose($hGraphics)

_GDIPlus_MatrixDispose($hMatrix)

OnAutoItExitRegister("_CleanUp")
GUISetOnEvent(-3, "_MyExit", $hWnd)

While 1
	Sleep(10)
WEnd

Func _CleanUp()
	_GDIPlus_Shutdown()
EndFunc

Func _MyExit()
	Exit
EndFunc
