#include <GDIPlus.au3>
;#include <GDIPConstants.au3>
; #VARIABLES# ===================================================================================================================
Global $ghGDIPMatrix = 0
Global $GDIP_STATUS = 0
Global $GDIP_ERROR = 0
; ===============================================================================================================================

_GDIPlus_Startup()
;$hBmp = _GDIPlus_BitmapCreateFromScan0(100, 100, $GDIP_PXF08INDEXED)
$hBmp = _GDIPlus_BitmapCreateFromScan0(100, 100, $GDIP_PXF32ARGB)
$hGraphics = _GDIPlus_ImageGetGraphicsContext($hBmp)
$hBrush = _GDIPlus_BrushCreateSolid(0xFF00FF00)
_GDIPlus_GraphicsFillRect($hGraphics, 10, 10, 10, 10, $hBrush)
_GDIPlus_BrushSetSolidColor($hBrush, 0xFF00FFFF)
_GDIPlus_GraphicsFillRect($hGraphics, 20, 10, 10, 10, $hBrush)
_GDIPlus_BrushSetSolidColor($hBrush, 0xFF0000FF)
_GDIPlus_GraphicsFillRect($hGraphics, 20, 20, 10, 10, $hBrush)

_GDIPlus_BrushSetSolidColor($hBrush, 0xFFFFFFFF)
_GDIPlus_GraphicsFillRect($hGraphics, 30, 10, 10, 10, $hBrush)

_GDIPlus_BrushSetSolidColor($hBrush, 0xFFFF00FF)
_GDIPlus_GraphicsFillRect($hGraphics, 30, 20, 10, 10, $hBrush)
_GDIPlus_BrushSetSolidColor($hBrush, 0xFFFF0000)
_GDIPlus_GraphicsFillRect($hGraphics, 30, 30, 10, 10, $hBrush)

;~ MsgBox(0, "", _GDIPlus_ImageGetPaletteSize($hBmp))
;~ MsgBox(0, "", _GDIPlus_ImageGetPixelFormat($hBmp)[1])
;~ _GDIPlus_GraphicsClear($hGraphics)

$tResult = _GDIPlus_ImageGetPalette($hBmp)
;~ MsgBox(0, "", VarGetType($tResult)&@CRLF&$tResult)
;~ MsgBox(0, "", DllStructGetData($tResult, 1))
;~ MsgBox(0, "", DllStructGetData($tResult, 2))
;~ MsgBox(0, "", DllStructGetData($tResult, 3))
ConsoleWrite(VarGetType($tResult) &"["& DllStructGetSize($tResult) &"]"& @CRLF&@TAB &"[Flags] "& DllStructGetData($tResult, "Flags")& @CRLF&@TAB &"[Count] "& DllStructGetData($tResult, "Count")& @CRLF&@TAB &"[Entries]" &@CRLF)
For $i=1 To DllStructGetData($tResult, "Count")
	ConsoleWrite( @TAB&@TAB &"["&$i&"] 0x"& Hex(DllStructGetData($tResult, "Entries", $i), 8) & @CRLF)
Next

_GDIPlus_ImageSaveToFileEx($hBmp, "x.jpg", _GDIPlus_EncodersGetCLSID("JPG"))

$iSize = Ceiling( DllStructGetData($tResult, "Count")^(1/2) )*10
$hBmp2 = _GDIPlus_BitmapCreateFromScan0($iSize, $iSize)
$hGraphics2 = _GDIPlus_ImageGetGraphicsContext($hBmp2)
For $i=1 To DllStructGetData($tResult, "Count")
	_GDIPlus_BrushSetSolidColor($hBrush, DllStructGetData($tResult, "Entries", $i))
	_GDIPlus_GraphicsFillRect($hGraphics2, Mod($i, $iSize/10)*10, Floor($i/($iSize/10))*10, 10, 10, $hBrush)
Next

$tParams = _GDIPlus_ParamInit (1)
$tData = DllStructCreate("int Quality")
;~ DllStructSetData($tData, "Quality", 10) ;quality 0-100
DllStructSetData($tData, "Quality", 50) ;quality 0-100
$pData = DllStructGetPtr($tData)
_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
$pParams = DllStructGetPtr($tParams)

_GDIPlus_ImageSaveToFileEx($hBmp2, "3.jpg", _GDIPlus_EncodersGetCLSID("JPG"), $pParams)
_GDIPlus_GraphicsDispose($hGraphics2)
_GDIPlus_ImageDispose($hBmp2)


_GDIPlus_BrushDispose($hBrush)
_GDIPlus_GraphicsDispose($hGraphics)
_GDIPlus_BitmapDispose($hBmp)
_GDIPlus_Shutdown()
Exit

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetPalette
; Description ...: Gets the color palette of an Image object
; Syntax.........: _GDIPlus_ImageGetPalette($hImage)
; Parameters ....: $hImage - Pointer to an Image object
; Return values .: Success      - $tagGDIPCOLORPALETTE structure.
;                  Failure      - -1 and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
;                  |$GDIP_ERROR:
;                  |	1 - The _GDIPlus_ImageGetPaletteSize function failed, $GDIP_STATUS contains the error code
;                  |	2 - The image does not contain a palette
;                  |	3 - The _GDIPlus_ImageGetPalette function failed, $GDIP_STATUS contains the error code
; Remarks .......: None
; Related .......: _GDIPlus_ImageGetPaletteSize, $tagGDIPCOLORPALETTE
; Link ..........; @@MsdnLink@@ GdipGetImagePalette
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_ImageGetPalette($hImage)
	Local $iCount, $iColorPalette, $tColorPalette, $pColorPalette, $aResult

	$iColorPalette = _GDIPlus_ImageGetPaletteSize($hImage)
	If @error Then Return SetError(@error, @extended, -1)

	If $GDIP_STATUS Then
		$GDIP_ERROR = 1
		Return -1
	ElseIf $iColorPalette = 0 Then
		$GDIP_ERROR = 2
		Return -1
	EndIf

	$iCount = ($iColorPalette - 8) / 4
	$tColorPalette = DllStructCreate("uint Flags;uint Count;uint Entries[" & $iCount & "];")
;~ 	$tColorPalette = DllStructCreate("uint Flags;uint Count;DWORD Entries[" & $iCount & "];")
	$pColorPalette = DllStructGetPtr($tColorPalette)
	$aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetImagePalette", "hwnd", $hImage, "ptr", $pColorPalette, "int", $iColorPalette)
	If @error Then Return SetError(@error, @extended, -1)

	$GDIP_STATUS = $aResult[0]
	If $GDIP_STATUS Then Return -1
	Return $tColorPalette
EndFunc   ;==>_GDIPlus_ImageGetPalette

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetPaletteSize
; Description ...: Gets the size, in bytes, of the color palette of an Image object
; Syntax.........: _GDIPlus_ImageGetPaletteSize($hImage)
; Parameters ....: $hImage - Pointer to an Image object
; Return values .: Success      - Size, in bytes, of the color palette
;                  Failure      - -1 and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
; Remarks .......: None
; Related .......: _GDIPlus_ImageGetPalette, $tagGDIPCOLORPALETTE
; Link ..........; @@MsdnLink@@ GdipGetImagePaletteSize
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_ImageGetPaletteSize($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetImagePaletteSize", "hwnd", $hImage, "int*", 0)

	If @error Then Return SetError(@error, @extended, -1)

	$GDIP_STATUS = $aResult[0]
	If $GDIP_STATUS Then Return -1
	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ImageGetPaletteSize
