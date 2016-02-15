Attribute VB_Name = "modMain"

'This will handle the installation of the OCX control if it is not already found on the system
'this runs from a module before the main form is loaded because the main form depends on the OCX.
'I did not want to use a batch file because there is a strong chance that newer versions of Windows
'which are 64-bit would try to execute it with a 64-bit cmd.exe which would then screw up regsvr32 call.

Sub Main()
    
    Dim ocx As String
    Dim src As String
    
    On Error Resume Next
    
    ocx = "c:\windows\system32\mscomm32.ocx"
    src = App.path & "\mscomm32.ocx"
    
    If Not FileExists(ocx) Then
        If Not FileExists(src) Then
           MsgBox "serial port OCX not found and not installed?"
           End
        Else
            FileCopy src, ocx
            Shell "regsvr32 " & ocx
            If Err.Number <> 0 Then
                MsgBox "failed to register OCX control? you may have to run with administrator privileges", vbInformation
            End If
        End If
    End If
    
    Form1.Visible = True
    
End Sub

Function FileExists(path As String) As Boolean
  On Error GoTo hell
    
  If Len(path) = 0 Then Exit Function
  If Right(path, 1) = "\" Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then FileExists = True
  
  Exit Function
hell: FileExists = False
End Function

Sub WriteFile(path, it)
    f = FreeFile
    Open path For Output As #f
    Print #f, it
    Close f
End Sub

Sub push(ary, value) 'this modifies parent ary object
    On Error GoTo init
    x = UBound(ary) '<-throws Error If Not initalized
    ReDim Preserve ary(UBound(ary) + 1)
    ary(UBound(ary)) = value
    Exit Sub
init:     ReDim ary(0): ary(0) = value
End Sub
