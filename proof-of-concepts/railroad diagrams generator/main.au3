#include <GDIPlus.au3>

#cs
	syntax/railroad diagrams generator
#ce

#cs
	_GDIPlus_GraphicsSetClipPath
	_GDIPlus_BitmapCreateFromResource
	_GDIPlus_PathReverse
	_GDIPlus_PathGetData
	_GDIPlus_PathGetLastPoint
	_GDIPlus_PathGetPointCount
	_GDIPlus_PathGetPoints
	_GDIPlus_PathGetWorldBounds
	_GDIPlus_PathIsOutlineVisiblePoint
	_GDIPlus_PathIsVisiblePoint
	_GDIPlus_PathStartFigure
	_GDIPlus_PathCloseFigure
	_GDIPlus_PathTransform
	_GDIPlus_PathWarp
	_GDIPlus_PathWiden
	_GDIPlus_PathWindingModeOutline
#ce

#cs
	JSON structure visual documentation
	     #-----
	     |
	-----#-----
#ce

_GDIPlus_Startup()

$hBitmap = _GDIPlus_BitmapCreateFromScan0(700, 320)
$hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
$hPath = _GDIPlus_PathCreate()
$hPen = _GDIPlus_PenCreate(0xFF000000, 4)

_GDIPlus_GraphicsSetSmoothingMode($hGraphics, 2)
_GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, 2)

$x = 100
$y = 100
$size = 20

$X1 = $x
$Y1 = $y + $size

$X2 = $x + $size/2
$y2 = $y + $size

$X3 = $x + $size
$Y3 = $y + $size/2

$X4 = $x + $size
$Y4 = $y

_GDIPlus_PathAddBezier($hPath, $X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4)

$x += $size
$y -= $size

$X1 = $x
$Y1 = $y + $size

$X2 = $x
$y2 = $y + $size/2

$X3 = $x + $size/2
$Y3 = $y

$X4 = $x + $size
$Y4 = $y

_GDIPlus_PathAddBezier($hPath, $X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4)

$y += $size

_GDIPlus_GraphicsDrawPath($hGraphics, $hPath, $hPen)
_GDIPlus_GraphicsDrawLine($hGraphics, 10, $y + $size, 680, $y + $size, $hPen)
_GDIPlus_GraphicsDrawLine($hGraphics, $x + $size, $y - $size, 680, $y - $size, $hPen)

Dim $Size = [20,20]
Dim $Point01 = [150,150]
Dim $Point02 = [$Point01[0]-$Size[0],$Point01[1]+$Size[1]]
$hPath2 = _GDIPlus_PathCreate()
$X1 = $Point01[0]
$Y1 = $Point01[1]
$X2 = $Point01[0] - ($size[0]*.6)
$Y2 = $Point01[1]
$X3 = $Point02[0]
$Y3 = $Point02[1] - ($size[1]*.6)
$X4 = $Point02[0]
$Y4 = $Point02[1]
_GDIPlus_PathAddBezier($hPath2, $X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4)
_GDIPlus_PenSetWidth($hPen, 1)
_GDIPlus_GraphicsDrawPath($hGraphics, $hPath2, $hPen)

_GDIPlus_PathReset($hPath)

;~ Dim $Size = [20,20]
;~ Dim $Point01 = [20,20];x, y += 20
;~ Dim $Point02 = [$Point01[0]-$Size[0],$Point01[1]+$Size[1]]
;~ $hPath2 = _GDIPlus_PathCreate()
;~ $X1 = $Point01[0]
;~ $Y1 = $Point01[1]
;~ $X2 = $Point01[0] - ($size[0]*.5)
;~ $Y2 = $Point01[1]
;~ $X3 = $Point02[0]
;~ $Y3 = $Point02[1] - ($size[1]*.5)
;~ $X4 = $Point02[0]
;~ $Y4 = $Point02[1]
;~ _GDIPlus_PathAddBezier($hPath2, $X1, $Y1, $X2, $Y2, $X3, $Y3, $X4, $Y4)
_DrawCornor($hPath2, 20, 1, 1, 1)
_GDIPlus_PenSetWidth($hPen, 4)
_GDIPlus_GraphicsDrawPath($hGraphics, $hPath2, $hPen)


;~ _GDIPlus_GraphicsDrawLine($hGraphics, $X1, $Y1, $X2, $Y2, $hPen)
;~ _GDIPlus_GraphicsDrawLine($hGraphics, $X4, $Y4, $X3, $Y3, $hPen)

#Region StringTest

	$hFamily = _GDIPlus_FontFamilyCreate("Courier New")
	$fSize = 10
	$iStyle = 0
	$hFont = _GDIPlus_FontCreate($hFamily, $fSize, $iStyle)
	$sString = "ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijlkmnopqrstuvxyz"
	$sString = "a"
	$tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hBrush = _GDIPlus_BrushCreateSolid(0xFF000000)
	$aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	_GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)

	_GDIPlus_BrushSetSolidColor($hBrush, 0x33000000)
	_GDIPlus_GraphicsFillRect($hGraphics, $aInfo[0].X, $aInfo[0].Y, $aInfo[0].Width, $aInfo[0].Height, $hBrush)
;~ 	_GDIPlus_GraphicsFillEllipse($hGraphics, $aInfo[0].X-5, $aInfo[0].Y-5, $aInfo[0].Width+10, $aInfo[0].Height+10, $hBrush)

	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)

#EndRegion StringTest

_GDIPlus_ImageSaveToFileEx($hBitmap, "img.png", _GDIPlus_EncodersGetCLSID("PNG"))

_GDIPlus_BitmapDispose($hBitmap)
_GDIPlus_GraphicsDispose($hGraphics)
_GDIPlus_PathDispose($hPath)
_GDIPlus_PenDispose($hPen)

_GDIPlus_Shutdown()

#cs
	1---2
	|   |
	3---4
#ce

Func _DrawCornor($hPath, $nSize, $iHorisontal=1, $iVertical=1, $iDirection=1)
	Local $aPoint = _GDIPlus_PathGetLastPoint($hPath)
	If @error Then Dim $aPoint[2] = [0,0]
	MsgBox(0, "", $aPoint[0]&"x"&$aPoint[1])
	Local $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4
	$nX1 = $aPoint[0]
	$nY1 = $aPoint[1]

	$nX4 = $nX1 + (($iHorisontal)?$nSize:-$nSize)
	$nY4 = $nY1 + (($iVertical)?$nSize:-$nSize)

	$nX2 = $nX1
	$nY2 = $nY1
	$nX3 = $nX4
	$nY3 = $nY4

	For $i=1 To 4
		ConsoleWrite("["&$i&"]: "&Execute("$nX"&$i)&"x"&Execute("$nY"&$i)&@CRLF)
	Next

	_GDIPlus_PathAddBezier($hPath, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4)
	Return True
EndFunc
