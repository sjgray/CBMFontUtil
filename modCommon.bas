Attribute VB_Name = "modCommon"
' Check if Directory exists. If so, returns TRUE
Public Function DirExists(ByVal DirName As String) As Boolean
    On Local Error GoTo ExErr1
    DirExists = False
    If DirName <> "" Then
        If Dir(DirName, vbDirectory) <> "" Then DirExists = True
    End If
    Exit Function
ExErr1:
End Function

'Check if a file exists. If so, returns TRUE
Function Exists(ByVal F As String) As Boolean
    Dim FIO As Integer
    
    On Error GoTo NoFile
    FIO = FreeFile
    Open F For Input As FIO: Close FIO
    Exists = True
    DoEvents
    Exit Function

NoFile:
    Exists = False
    
End Function

'Checks if a file exists, if so it prompts for permission to overwrite
'Returns TRUE if file does NOT exist, or permission is granted
Public Function Overwrite(ByVal Filename As String) As Boolean
    
    Overwrite = True 'assume ok to replace
    
    If Exists(Filename) = True Then
        If MsgBox("The file '" & Filename & "' already exists! Replace it?", vbYesNo, "Overwrite File") = vbNo Then Overwrite = False
    End If
End Function

'Checks end of path for \ and adds if not found
Public Function AddSlash(Path As String) As String
    If Not (Right$(Path, 1) = "\") Then
            Path = Path & "\"
    End If
    
    AddSlash = Path
End Function

'Delete a file if the file exists
Public Sub KillFile(ByVal Filename As String)
    On Error Resume Next
    If Exists(Filename) Then Kill Filename
End Sub

'Validate PC filename - Check for invalid characters
Public Function CheckPCFilename(ByVal Filename As String) As Boolean
    Dim Bad As String, j As Integer
    CheckPCFilename = True 'assume all okay
        
    If Left(Filename, 1) = " " Then CheckPCFilename = False: Exit Function
    
    Bad = "/\:*?<>|" & Qu
    
    For j = 1 To Len(Bad)
        If InStr(1, Filename, Mid(Bad, j, 1), vbtext) > 0 Then CheckPCFilename = False: Exit For
    Next j

End Function


'Return file Extension
Public Function FileExt(ByVal Filename As String) As String
    Dim p As Integer
    
    p = InStrRev(Filename, ".")
    If p > 0 Then FileExt = UCase(Mid(Filename, p + 1)) Else Ext = ""
End Function

'Return Path without filename
Public Function FilePath(ByVal Filename As String) As String
    Dim p As Integer
    
    p = InStrRev(Filename, "\")
    If p > 0 Then FilePath = Left(Filename, p - 1) Else FilePath = ""
    
End Function

'Return Filename without Extension (do not remove path if included)
Public Function Basename(ByVal Filename As String) As String
    Dim p As Integer
    
    p = InStrRev(Filename, ".")
    If p > 0 Then Basename = Left(Filename, p - 1) Else Basename = Filename
    
End Function

'RETURN Filename without Path
Public Function FileNameOnly(ByVal Filename As String) As String
    Dim p As Integer
    
    p = InStrRev(Filename, "\")
    If p > 0 Then FileNameOnly = Mid(Filename, p + 1) Else FileNameOnly = Filename
    
End Function

'Removes the trailing \ from a filename
Public Function NoSlash(ByVal Filename As String) As String
    If Right(Filename, 1) = "\" Then
        NoSlash = Left(Filename, Len(Filename) - 1)
    Else
        NoSlash = Filename
    End If
End Function

Function MyHex(ByVal N As Single, D As Integer)
    MyHex = Right("00000000" & Hex(N), D)
End Function

Function MyTrim(ByVal str As String) As String
    MyTrim = LTrim(RTrim(str))
End Function
