#include <GDIPlus.au3>

; https://www.codeproject.com/kb/graphics/ylscsfreetransform.aspx

Opt("GuiOnEventMode", 1)

Global Const $FillModeAlternate	= 0
Global Const $FillModeWinding	= 1

$hWnd = GUICreate("", 700, 320)
GUISetOnEvent(-3, "_MyExit", $hWnd)
GUISetState(@SW_SHOW, $hWnd)

_GDIPlus_Startup( )
$hGraphics = _GDIPlus_GraphicsCreateFromHWND( $hWnd )
$hBitmap = _GDIPlus_BitmapCreateFromGraphics(700, 320, $hGraphics)
$hGraphics2 = _GDIPlus_ImageGetGraphicsContext($hBitmap)
$hImage = _GDIPlus_ImageLoadFromFile("1.png")

$tRect = DllStructCreate("FLOAT Point[8]")
$tRect.Point(1) = 100;top left
$tRect.Point(2) = 50
$tRect.Point(3) = 200;top right
$tRect.Point(4) = 50
$tRect.Point(5) = 50;bottom left
$tRect.Point(6) = 80
$tRect.Point(7) = 250;bottom right
$tRect.Point(8) = 80

$tRect.Point(1) = 100;top left
$tRect.Point(2) = 50
$tRect.Point(3) = 200;top right
$tRect.Point(4) = 50
$tRect.Point(5) = 50;bottom left
$tRect.Point(6) = 180
$tRect.Point(7) = 250;bottom right
$tRect.Point(8) = 180

_GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, 2)
For $i=0 To 20
	_GDIPlus_GraphicsClear($hGraphics2)
	_GDIPlus_GraphicsDrawImage4Points($hGraphics2, $hImage, $tRect)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
	$tRect.Point(1) -= 2
	$tRect.Point(2) -= 2
	$tRect.Point(3) += 2
	$tRect.Point(4) -= 2
Next

For $i=0 To 20
	_GDIPlus_GraphicsClear($hGraphics2)
	_GDIPlus_GraphicsDrawImage4Points($hGraphics2, $hImage, $tRect)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
	$tRect.Point(1) += 2
;~ 	$tRect.Point(2) -= 2
	$tRect.Point(3) -= 2
;~ 	$tRect.Point(4) -= 2
Next

#cs
$hImage1 = _GDIPlus_BitmapCreateFromScan0(_GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))
$hImage2 = _GDIPlus_BitmapCreateFromScan0(_GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))

$hTexture = _GDIPlus_TextureCreate($hImage)

$hGraphics3 = _GDIPlus_ImageGetGraphicsContext($hImage1)
Dim $aPoints[4][2] = [[3, 0],[0, 0],[_GDIPlus_ImageGetWidth($hImage), 0],[0, _GDIPlus_ImageGetHeight($hImage)]]
_GDIPlus_GraphicsFillPolygon($hGraphics3, $aPoints, $hTexture)
_GDIPlus_GraphicsDispose($hGraphics3)
$hGraphics3 = _GDIPlus_ImageGetGraphicsContext($hImage2)
Dim $aPoints[4][2] = [[3, 0],[0, _GDIPlus_ImageGetHeight($hImage)],[_GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage)],[_GDIPlus_ImageGetWidth($hImage), 0]]
;~ Dim $aPoints[4][2] = [[3, 0],[0, 0],[_GDIPlus_ImageGetWidth($hImage), 0],[0, _GDIPlus_ImageGetHeight($hImage)]]
_GDIPlus_GraphicsFillPolygon($hGraphics3, $aPoints, $hTexture)
$hImage3 = _GDIPlus_BitmapCloneArea($hImage2, 0, 0, _GDIPlus_ImageGetWidth($hImage2), _GDIPlus_ImageGetHeight($hImage2), $GDIP_PXF32ARGB)
_GDIPlus_GraphicsClear($hGraphics3, 0x00000000)
_GDIPlus_GraphicsDrawImageRect($hGraphics3, $hImage3, _GDIPlus_ImageGetWidth($hImage3), _GDIPlus_ImageGetHeight($hImage3), -1*_GDIPlus_ImageGetWidth($hImage3), -1*_GDIPlus_ImageGetHeight($hImage3))
;~ _GDIPlus_GraphicsDrawImageRect($hGraphics3, $hImage3, 0, 0, _GDIPlus_ImageGetWidth($hImage3), _GDIPlus_ImageGetHeight($hImage3))
_GDIPlus_BitmapDispose($hImage3)
_GDIPlus_GraphicsDispose($hGraphics3)

_GDIPlus_BrushDispose($hTexture)

$sEncoder = _GDIPlus_EncodersGetCLSID("PNG")
_GDIPlus_ImageSaveToFileEx($hImage1, "Image1.png", $sEncoder)
_GDIPlus_ImageSaveToFileEx($hImage2, "Image2.png", $sEncoder)

_GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage1, 100, 50, 200, 50, 50, 80, 0, 0, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 100-5, 50-5, 10, 10)
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 200-5, 50-5, 10, 10)
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 50-5, 80-5, 10, 10)

;~ _GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage2, 200, 50, 250, 80, 50, 80, 0, 0, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))
;~ _GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage2, 250, 80, 200, 50, 50, 80, 0, 0, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))
_GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage2, 250, 80, 50, 80, 200, 50, 0, 0, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 200, 50, 1, 1)
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 250, 80, 1, 1)
;~ _GDIPlus_GraphicsDrawEllipse($hGraphics, 50, 80, 1, 1)

_GDIPlus_ImageDispose($hImage1)
_GDIPlus_ImageDispose($hImage2)

;~ _GDIPlus_GraphicsClear($hGraphics, 0xFFFFFFFF)

;~ _GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage, 250, 80, 200, 50, 50, 80, 0, 0, _GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))
#ce
OnAutoItExitRegister("_CleanUp")

While 1
	Sleep(10)
WEnd

Func _MyExit()
	Exit
EndFunc

Func _CleanUp()
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphics2)
;~ 	_GDIPlus_ImageDispose($hImage2)
;~ 	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
EndFunc

Func _GDIPlus_GraphicsDrawImage4Points($hGraphics, $hImage, $tPoints, $hImageAttributes = 0, $iUnit = 2)
;~ 	_GDIPlus_GraphicsDrawImagePointsRect(,
	Local $hImage1, $hImage2, $hImage3
	Local $hGraphics1, $hGraphics2
	$hImage1 = _GDIPlus_BitmapCreateFromScan0(_GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))
	$hImage2 = _GDIPlus_BitmapCreateFromScan0(_GDIPlus_ImageGetWidth($hImage), _GDIPlus_ImageGetHeight($hImage))
	$hTexture = _GDIPlus_TextureCreate($hImage)
	$hGraphics1 = _GDIPlus_ImageGetGraphicsContext($hImage1)
	Local $tPoints2 = DllStructCreate("FLOAT Points[6]")
		$tPoints2.Points(1) = 0
		$tPoints2.Points(2) = 0
		$tPoints2.Points(3) = _GDIPlus_ImageGetWidth($hImage)
		$tPoints2.Points(4) = 0
		$tPoints2.Points(5) = 0
		$tPoints2.Points(6) = _GDIPlus_ImageGetHeight($hImage)
	__GDIPlus_GraphicsFillPolygon($hGraphics1, $tPoints2, $hTexture)
	_GDIPlus_GraphicsDispose($hGraphics1)
	$hGraphics1 = _GDIPlus_ImageGetGraphicsContext($hImage2)
		$tPoints2.Points(1) = 0
		$tPoints2.Points(2) = _GDIPlus_ImageGetHeight($hImage)
		$tPoints2.Points(3) = _GDIPlus_ImageGetWidth($hImage)
		$tPoints2.Points(4) = _GDIPlus_ImageGetHeight($hImage)
		$tPoints2.Points(5) = _GDIPlus_ImageGetWidth($hImage)
		$tPoints2.Points(6) = 0
	__GDIPlus_GraphicsFillPolygon($hGraphics1, $tPoints2, $hTexture)
	$hImage3 = _GDIPlus_BitmapCloneArea($hImage2, 0, 0, _GDIPlus_ImageGetWidth($hImage2), _GDIPlus_ImageGetHeight($hImage2), $GDIP_PXF32ARGB)
	_GDIPlus_GraphicsClear($hGraphics1, 0x00000000)
	_GDIPlus_GraphicsDrawImageRect($hGraphics1, $hImage3, _GDIPlus_ImageGetWidth($hImage3), _GDIPlus_ImageGetHeight($hImage3), -1*_GDIPlus_ImageGetWidth($hImage3), -1*_GDIPlus_ImageGetHeight($hImage3))
	_GDIPlus_BitmapDispose($hImage3)
	_GDIPlus_GraphicsDispose($hGraphics1)

	_GDIPlus_BrushDispose($hTexture)

	_GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage1, $tPoints.Point(1), $tPoints.Point(2), $tPoints.Point(3), $tPoints.Point(4), $tPoints.Point(5), $tPoints.Point(6), 0, 0, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))

	_GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage2, $tPoints.Point(7), $tPoints.Point(8), $tPoints.Point(5), $tPoints.Point(6), $tPoints.Point(3), $tPoints.Point(4), 0, 0, _GDIPlus_ImageGetWidth($hImage2), _GDIPlus_ImageGetHeight($hImage2))

	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
EndFunc

Func __GDIPlus_GraphicsDrawPolygon($hGraphics, $tPoints, $hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "INT", "GdipDrawPolygon", "HANDLE", $hGraphics, "HANDLE", $hPen, "STRUCT*", $tPoints, "INT", DllStructGetSize($tPoints)/4/2)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)
	Return True
EndFunc

Func __GDIPlus_GraphicsFillPolygon($hGraphics, $tPoints, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPolygon", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", DllStructGetSize($tPoints)/4/2, "int", $FillModeAlternate)
	If @error Then Return SetError(@error, @extended, False)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)
	Return True
EndFunc
