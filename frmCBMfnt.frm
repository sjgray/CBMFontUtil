VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form frmCBMfnt 
   Caption         =   "CBM Font Utility"
   ClientHeight    =   3090
   ClientLeft      =   4455
   ClientTop       =   3585
   ClientWidth     =   9000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   9000
   Begin VB.TextBox txtOptVal 
      Height          =   285
      Left            =   4560
      TabIndex        =   13
      Text            =   "0"
      ToolTipText     =   "Operation-specifiic option value"
      Top             =   1200
      Width           =   975
   End
   Begin VB.OptionButton optSize 
      Caption         =   "8x16 pixel font"
      Height          =   255
      Index           =   1
      Left            =   1200
      TabIndex        =   12
      Top             =   1320
      Width           =   1695
   End
   Begin VB.OptionButton optSize 
      Caption         =   "8x8 pixel font"
      Height          =   255
      Index           =   0
      Left            =   1200
      TabIndex        =   10
      Top             =   1080
      Value           =   -1  'True
      Width           =   1695
   End
   Begin VB.CommandButton cmdAbout 
      Caption         =   "&About"
      Height          =   735
      Left            =   5880
      TabIndex        =   9
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdGo 
      Caption         =   "&GO"
      Height          =   735
      Left            =   7320
      TabIndex        =   8
      Top             =   1800
      Width           =   1575
   End
   Begin VB.ComboBox cboOp 
      Height          =   315
      ItemData        =   "frmCBMfnt.frx":0000
      Left            =   1200
      List            =   "frmCBMfnt.frx":004F
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   720
      Width           =   6975
   End
   Begin VB.TextBox txtOut 
      Height          =   375
      Left            =   1200
      TabIndex        =   3
      ToolTipText     =   "If path is not included file will be written in same directory as source file"
      Top             =   1800
      Width           =   4335
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "..."
      Height          =   375
      Left            =   8280
      TabIndex        =   1
      Top             =   240
      Width           =   615
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   11520
      Top             =   240
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox txtSrc 
      Height          =   375
      Left            =   1200
      TabIndex        =   0
      Top             =   240
      Width           =   6975
   End
   Begin VB.Label lblStat 
      Appearance      =   0  'Flat
      BackColor       =   &H80000018&
      Caption         =   "."
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   120
      TabIndex        =   15
      Top             =   2690
      Width           =   8775
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      Caption         =   "Option:"
      Height          =   195
      Left            =   3960
      TabIndex        =   14
      Top             =   1200
      Width           =   510
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Characters:"
      Height          =   195
      Left            =   240
      TabIndex        =   11
      Top             =   1080
      Width           =   810
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Operation:"
      Height          =   195
      Left            =   315
      TabIndex        =   6
      Top             =   720
      Width           =   735
   End
   Begin VB.Label Label3 
      AutoSize        =   -1  'True
      Caption         =   "(Some operations will create multiple files using output filename as a template)"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   2400
      Width           =   5445
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Output File:"
      Height          =   195
      Left            =   240
      TabIndex        =   4
      Top             =   1920
      Width           =   810
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      Caption         =   "Source File:"
      Height          =   195
      Left            =   240
      TabIndex        =   2
      Top             =   300
      Width           =   840
   End
End
Attribute VB_Name = "frmCBMfnt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Tran(255)
Dim CB(15)

Private Sub cmdAbout_Click()
    MsgBox "CBM Font Utility, V1.0 - Aug 9/15, (C)2015 Steve J. Gray"
End Sub

Private Sub Form_Load()
    cboOp.ListIndex = 0
    Stat "Ready. CBM FontUtil (C)2015 Steve J. Gray"
End Sub

Private Sub cmdGo_Click()
    Dim Choice As Integer, FLen As Double, FIO As Integer, FIO2 As Integer, FIO3 As Integer
    Dim SrcFile As String, DstFile As String
    
    Dim CMat(15) As String * 1                                  'array for one character
    Dim Tr(15) As Integer                                       'translation array
    Dim SBit(7, 7) As Integer, DBit(7, 7) As Integer            'source/dest bit arrays for rotation
    
    Dim T As Integer                                            'temp integer
    Dim BV As Integer, BV2 As Integer, BV3 As Integer           'byte values for calculations
    Dim Row As Integer, Col As Integer                          'loop variables - INT
    Dim C As Double, I As Integer, j As Integer                 'loop variables - INT
    Dim k As Double                                             'loop variables - Double
    Dim X As Integer, Y As Integer                              'loop variables - INT
    Dim OptVal As Integer, OptCSize As Integer                  'option value and chr size
    Dim Hi As Integer, Lo As Integer                            'Hi and Lo nibbles of byte
    
    Dim BChr As String * 1, Tmp As String, BChr2 As String * 1  'buffers for data
    Dim Nul As String
    
    Nul = Chr(0)                                                'Null character
    
    'On Local Error GoTo BailOut
    
    '------------------------ Check input fields
    SrcFile = txtSrc.Text
    DstFile = txtOut.Text
    OptVal = Val(txtOptVal.Text)
        
    If optSize(0).Value = True Then OptCSize = 8 Else OptCSize = 16
    
    If SrcFile = "" Then MsgBox "Source not specified!": Exit Sub
    If DstFile = "" Then MsgBox "Output file not specified!": Exit Sub
    
    If Exists(SrcFile) = False Then MsgBox "Source file does not exist!": Exit Sub
    
    Choice = cboOp.ListIndex
    StatProcessing
    
    '------------------------ Open the Source File
    FIO = FreeFile
    If Choice = 0 Then
        'Text file with list of font files to combine
        Open SrcFile For Input As FIO
    Else
        'Font file to operate on
        Open SrcFile For Binary As FIO
        FLen = FileLen(SrcFile)
        Stat "Source opened. File length=" & str(FLen)
    
        '------------------------ Check Source File size
        T = FLen Mod 1024
        If T <> 0 Then
            If T = 2 Then
                MsgBox "File appears to have 2-byte load address. These bytes will be stripped!"
                Tmp = Input(2, FIO) 'skip them
            Else
                MsgBox "Source file must be a multiple of 1024 bytes!"
                Close FIO
                Exit Sub
            End If
        End If
    End If
    
    '------------------------ Open the output file
    If (Choice = 0) Or (Choice > 3) Then
        FIO2 = FreeFile
        If Overwrite(DstFile) = False Then Exit Sub
    
        Open DstFile For Output As FIO2
    End If
    
    '------------------------ Do the requested operation
    Select Case Choice
        Case 0: GoSub CombineFiles      'Combine Fonts or Sets using list file (.txt)
        Case 1: GoSub SplitFonts        'x Split to Individual Fonts
        Case 2: GoSub SplitFontPairs    'x Split to Font Pair(s)
        Case 3: GoSub SplitFontSet      'x Split to Font Set(s)
        
        Case 4: GoSub ExpandFont    'Expand to 8x16 pixels
        Case 5: GoSub StretchFont   'Stretch font to 8x16
        Case 6: GoSub CompactFont   'Compact 8x16 font to 8x8 pixels
        Case 7: GoSub SquishFont    'Squish 8x16 font to 8x8 pixels
        Case 8: GoSub InvertFont    'Invert pixels
        Case 9: GoSub BoldFont      'Make Bold
        Case 10: GoSub ItalicFont   'x Make Italic
        Case 11: GoSub Underlined   'x Make Underlined
        Case 12: GoSub Rotate90     'x Rotate 90
        Case 13: GoSub Rotate180    'x Rotate 180
        Case 14: GoSub Rotate270    'x Rotate 270
        Case 15: GoSub MirrorH      'x Mirror Horizontal
        Case 16: GoSub MirrorV      'x Mirror Vertical
        Case 17: GoSub DoubleWL     'x Double Wide - Left side
        Case 18: GoSub DoubleWR     'x Double Wide - Right side
        Case 19: GoSub DoubleTT     'x Double Tall - Top
        Case 20: GoSub DoubleTB     'x Double Tall - Bottom
        Case 21: GoSub DoubleS1     'x Double Size - Top Left
        Case 22: GoSub DoubleS2     'x Double Size - Top Right
        Case 23: GoSub DoubleS3     'x Double Size - Bottom Left
        Case 24: GoSub DoubleS4     'x Doube Size - Bottom Right
    End Select
    StatDone
    
BailOut:
    Close
    Exit Sub
    
'----------------------------- Combine Font Files
' Takes a text list of font files and combines them into one file
CombineFiles:
    While Not EOF(FIO)
        Line Input #FIO, Tmp
        If Left(Tmp, 1) <> ";" Then
            If Exists(Tmp) = True Then
                FIO3 = FreeFile
                Open Tmp For Binary As FIO3
                FLen = FileLen(Tmp)
                
                Stat "Adding " & Tmp
                
                'Now read the file and write to the output
                For k = 1 To FLen
                    BChr = Input(1, FIO3)
                    Print #FIO2, BChr;
                Next k
                Close FIO3
                DoEvents
            Else
                MsgBox "File: " & Tmp & " was not found!"
            End If
        End If
    Wend
    Return

'----------------------------- Split to Individual Fonts
' A font is 1024 bytes, containing 128 character of 8 bytes each
SplitFonts:
    T = 1024    'Size of chunks
    GoSub DoSplitting
    Return
    
'----------------------------- Split to Font Pairs
' A font pair is two fonts
SplitFontPairs:
    T = 2048
    GoSub DoSplitting
    Return

'----------------------------- Split to Font Set
' A font set is 4 fonts (2 pairs)
SplitFontSet:
    T = 4096
    GoSub DoSplitting
    Return
    
DoSplitting:
    C = 0       'File part counter
  
    For k = 1 To FLen / T
        C = C + 1                                       'next part number
        Tmp = DstFile & "-" & Format(C) & ".bin"  'build filename
        FIO3 = FreeFile
        Open Tmp For Output As FIO3
        Stat "Creating " & Tmp
        
        ' Read Source file, write to new dst file
        For j = 1 To T
            BChr = Input(1, FIO)
            Print #FIO3, BChr;
        Next j
        Close FIO3
    Next k
    Return
    
'----------------------------- Expand Font
' Converts an 8x8 font file (any number of fonts) to 8x16 by padding with blank lines
ExpandFont:
    If OptCSize = 16 Then MsgBox "This operation only works on 8x8 pixel fonts!": Return
    If OptVal > 8 Then MsgBox "Option must be 0 to 7!": Return
        
    For k = 1 To FLen \ OptCSize
        For I = 1 To OptCSize
            BChr = Input(1, FIO)  'Read a byte
            Print #FIO2, BChr;     'Copy a byte
        Next I
        For I = 1 To OptCSize
            Print #FIO2, Nul; 'expand with blank
        Next I
    Next k
    Return

'----------------------------- Stretch Font
' Converts an 8x8 font file (any number of fonts) to 8x16 by doubling each row
StretchFont:
    If OptCSize = 16 Then MsgBox "This operation only works on 8x8 pixel fonts!": Return

    For k = 1 To FLen \ OptCSize
        For I = 1 To OptCSize
            BChr = Input(1, FIO)        'Read a byte
            Print #FIO2, BChr; BChr;    'Copy twice
        Next I
    Next k
    Return

'----------------------------- Compact Font
' Converts an 8x16 font file (any number of fonts) to 8x8 by truncating rows 8-15
CompactFont:
    If OptCSize = 16 Then MsgBox "This operation only works on 8x16 pixel fonts!": Return
    
    For k = 1 To FLen \ OptCSize
        For I = 1 To OptCSize
            BChr = Input(1, FIO)  'Read a byte
            If I < 9 Then Print #FIO2, BChr;   'Copy a byte if row 0 to 7
        Next I
    Next k
    Return

'----------------------------- Squish Font
' Converts an 8x16 font file (any number of fonts) to 8x8 by skipping every 2nd row
' OPTION: selects odd or even lines
SquishFont:
    If OptCSize = 8 Then MsgBox "This operation only works on 8x16 pixel fonts!": Return
    If OptVal > 1 Then MsgBox "Option must be 0 or 1!": Return
    
    For k = 1 To FLen \ OptCSize
        For I = 0 To 7
            BChr = Input(1, FIO)    'Read a byte
            BChr2 = Input(1, FIO)   'Read a byte
            If OptVal = 0 Then Print #FIO2, BChr;    'Copy a byte
            If OptVal = 1 Then Print #FIO2, BChr2;   'Copy a byte
        Next I
    Next k
    Return

'----------------------------- Invert Font
' Create INVERTED font.
InvertFont:
    For k = 1 To FLen
        BV = Asc(Input(1, FIO))     'Read a byte
        BV2 = 255 - BV              'Invert the pixels
        Print #FIO2, Chr(BV2);      'Write it
    Next k
    Return

'----------------------------- Bold Font
' Create BOLD font. Convert byte to binary, divide by 2, OR with original value
BoldFont:
    For k = 1 To FLen
        BV = Asc(Input(1, FIO))     'Read a byte
        BV2 = Int(BV / 2)           'Shift the pixels
        BV3 = BV Or BV2             'Merge them
        Print #FIO2, Chr(BV3);      'Write it
    Next k
    Return

'----------------------------- Italic Font
' Create Italic font. shift 2 rows right, two same, 2 left
ItalicFont:
    MsgBox "Not implemented!"
    Return

'----------------------------- Underlined Font
' Create Underlined
Underlined:
    If (OptCSize = 8) And (OptVal > 8) Then MsgBox "Underline ROW option must be 0 to 8!": Return
    If OptVal > 16 Then MsgBox "Underline ROW must be 0 to 16! (0=no underline)": Return
    
    For k = 1 To FLen \ OptCSize
        For I = 1 To OptCSize
            BChr = Input(1, FIO)
            If I = OptVal Then Print #FIO2, Chr(255); Else Print #FIO2, BChr;
        Next I
    Next k
    Return
    
'----------------------------- Rotated 90 Font
' Rotate 90 degrees
Rotate90:
    If OptCSize = 16 Then MsgBox "Rotation only supported on 8x8 characters!": Return
    GoSub SetupPowerArray
    C = 0
    
    For k = 1 To FLen \ OptCSize
        GoSub ClearBitArrays                    'Clear arrays for next character (all bits to zero)
        GoSub ReadChr                           'Read 8 bytes and fill Source Bit array
        '---- Do Rotation 90
        For Row = 0 To 7
            For Col = 0 To 7
                DBit(7 - Col, Row) = SBit(Row, Col)
            Next Col
        Next Row
        GoSub WriteChr                          'Write the Dest Bit Array back as bytes
    Next k
    Return

'----------------------------- Rotated 180 Font
' Rotate 180 degrees
Rotate180:
    If OptCSize = 16 Then MsgBox "Rotation only supported on 8x8 characters!": Return
    GoSub SetupPowerArray
    
    For k = 1 To FLen \ OptCSize
        GoSub ClearBitArrays                    'Clear arrays for next character (all bits to zero)
        GoSub ReadChr                           'Read 8 bytes and fill Source Bit array
        '---- Do Rotation 180
        For Row = 0 To 7
            For Col = 0 To 7
                DBit(7 - Row, 7 - Col) = SBit(Row, Col)
            Next Col
        Next Row
        GoSub WriteChr                          'Write the Dest Bit Array back as bytes
    Next k
    Return
    
'----------------------------- Rotated 270 Font
' Rotate 270 degrees
Rotate270:
    If OptCSize = 16 Then MsgBox "Rotation only supported on 8x8 characters!": Return
    GoSub SetupPowerArray
    
    For k = 1 To FLen \ OptCSize
        GoSub ClearBitArrays                    'Clear arrays for next character (all bits to zero)
        GoSub ReadChr                           'Read 8 bytes and fill Source Bit array
        '---- Do Rotation 270
        For Row = 0 To 7
            For Col = 0 To 7
                DBit(Col, 7 - Row) = SBit(Row, Col)
            Next Col
        Next Row
        GoSub WriteChr                          'Write the Dest Bit Array back as bytes
    Next k
    Return
    
'----------------------------- Horizontal Mirror Font
' Create Horizontal Mirrored
MirrorH:
    For k = 1 To FLen \ OptCSize
        For I = 0 To OptCSize - 1
            CMat(I) = Input(1, FIO) 'Read to array in order
        Next I
        
        For I = OptCSize - 1 To 0 Step -1
            Print #FIO2, CMat(I);   'Write to output in reverse order
        Next I
    Next k
    Return
    
'----------------------------- Vertical Mirrored Font
' Create Vertical Mirrored
MirrorV:
    GoSub SetupMirrorArray
    
    For k = 1 To OptCSize
        For I = 0 To OptCSize - 1
            BV = Asc(Input(1, FIO)) 'Read to array in order
            Hi = Int(BV / 16)               'Calculate HI nibble
            Lo = BV Mod 16
            BV2 = Tr(Lo) * 16 + Tr(Hi)
            Print #FIO2, Chr(BV2);   'Write to output in reverse order
        Next I
    Next k
    Return
    
'----------------------------- Double Wide Left
DoubleWL:
    GoSub Setup2XArray
    For k = 1 To FLen
        BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
        Hi = Int(BV / 16)               'Calculate HI nibble
        BV2 = Tr(Hi)                    'Translate
        Print #FIO2, Chr(BV2);          'Write
    Next k
    Return
    
'----------------------------- Double Wide Right
DoubleWR:
    GoSub Setup2XArray
    While Not EOF(FIO)
        BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
        Lo = BV Mod 16                  'Calculate LO nibble
        BV2 = Tr(Lo)                    'Translate
        Print #FIO2, Chr(BV2);          'Write
    Wend
    
    Return
    
'----------------------------- Double Tall Top
' Double each row in the top half only
DoubleTT:
    T = OptCSize / 2 - 1
    While Not EOF(FIO)
        For I = 0 To T
            BChr = Input(1, FIO)        'Read byte
            Print #FIO2, BChr; BChr;    'Write twice
        Next I
        
       Tmp = Input(T + 1, FIO)           'Discard next half of character bytes
        
    Wend
    Return
    
'----------------------------- Double Tall Bottom
DoubleTB:
    T = OptCSize / 2 - 1
    While Not EOF(FIO)
        Tmp = Input(T + 1, FIO)        'Discard first half of character bytes
                
        For I = 0 To T
            BChr = Input(1, FIO)        'Read byte
            Print #FIO2, BChr; BChr;    'Write twice
        Next I
    Wend

    Return
    
'----------------------------- Double Size (tall and wide)
' Top Left
DoubleS1:
    GoSub Setup2XArray
    T = OptCSize / 2 - 1
    
    For k = 1 To FLen \ OptCSize
        For I = 0 To T
            BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
            Hi = Int(BV / 16)               'Calculate HI nibble
            BChr = Chr(Tr(Hi))              'Translate
            Print #FIO2, BChr; BChr;        'Write
        Next I
        
        Tmp = Input(T + 1, FIO)             'Read and discard
    Next k
    Return
    
' Top Right
DoubleS2:
    GoSub Setup2XArray
    T = OptCSize / 2 - 1
    
    For k = 1 To FLen \ OptCSize
        For I = 0 To T
            BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
            Lo = BV Mod 16                  'Calculate HI nibble
            BChr = Chr(Tr(Lo))              'Translate
            Print #FIO2, BChr; BChr;        'Write
        Next I
        
        Tmp = Input(T + 1, FIO)             'Read and discard
    Next k
    Return

' Bottom Left
DoubleS3:
    GoSub Setup2XArray
    T = OptCSize / 2 - 1
    
    For k = 1 To FLen \ OptCSize
        Tmp = Input(T + 1, FIO)             'Read and discard
                
        For I = 0 To T
            BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
            Hi = Int(BV / 16)               'Calculate HI nibble
            BChr = Chr(Tr(Hi))              'Translate
            Print #FIO2, BChr; BChr;        'Write
        Next I
    Next k
    Return

' Bottom Right
DoubleS4:
    GoSub Setup2XArray
    T = OptCSize / 2 - 1
    
    For k = 1 To FLen \ OptCSize
        Tmp = Input(T + 1, FIO)             'Read and discard
        
        For I = 0 To T
            BV = Asc(Input(1, FIO))         'Read byte, convert to ascii
            Lo = BV Mod 16                  'Calculate HI nibble
            BChr = Chr(Tr(Lo))              'Translate
            Print #FIO2, BChr; BChr;        'Write
        Next I
    Next k
    Return

'----------------------- Translation Array
SetupMirrorArray:
    Tr(0) = 0: Tr(1) = 8: Tr(2) = 4: Tr(3) = 12
    Tr(4) = 2: Tr(5) = 10: Tr(6) = 6: Tr(7) = 14
    Tr(8) = 1: Tr(9) = 2: Tr(10) = 5: Tr(11) = 13
    Tr(12) = 3: Tr(13) = 11: Tr(14) = 7: Tr(15) = 15
    Return

Setup2XArray:
    Tr(0) = 0: Tr(1) = 3: Tr(2) = 12: Tr(3) = 15
    Tr(4) = 48: Tr(5) = 51: Tr(6) = 60: Tr(7) = 63
    Tr(8) = 192: Tr(9) = 195: Tr(10) = 204: Tr(11) = 207
    Tr(12) = 240: Tr(13) = 243: Tr(14) = 252: Tr(15) = 255
    Return

SetupPowerArray:
    Tr(0) = 1: Tr(1) = 2: Tr(2) = 4: Tr(3) = 8
    Tr(4) = 16: Tr(5) = 32: Tr(6) = 64: Tr(7) = 128
    Return
    
ClearBitArrays:
    For I = 0 To 7
        For j = 0 To 7
            SBit(I, j) = 0: DBit(I, j) = 0
        Next j
    Next I
    Return
    
'---------- Read 8 bytes and fill the Source Bit array with 0's and 1's
ReadChr:
    For Row = 0 To 7
        BV = Asc(Input(1, FIO))             'Read a byte and get value
        If BV > 0 Then                      'Only do bits if non-zero
            For Col = 0 To 7
                If (BV And Tr(Col)) <> 0 Then SBit(Row, Col) = 1 'Set the bit array
            Next Col
        End If
    Next Row
    Return
    
'---------- Write DBit Array out as 8 bytes
WriteChr:
    For Row = 0 To 7
            BV = 0                                              'Reset to zero
            For Col = 0 To 7
                If DBit(Row, Col) = 1 Then BV = BV + Tr(Col)    'Add the value of the bit position
            Next Col
        Print #FIO2, Chr(BV);                                   'Write byte to output
    Next Row
    Return
    
End Sub

Private Sub Stat(ByVal txt As String)
    lblStat.Caption = txt
End Sub

Private Sub StatProcessing()
    Stat "Processing..."
End Sub

Private Sub StatDone()
    Dim M As String
    
    M = "Operation complete!"
    Stat M
    MsgBox M
    
End Sub
Private Sub cmdBrowse_Click()

        Dim Filename As String
        
        Filename = GetFile()
        If Filename <> "" Then
            txtSrc.Text = Filename
            txtOut.Text = Basename(FileNameOnly(Filename))
        End If
End Sub

Private Function GetFile() As String
        
        On Local Error GoTo DialogError

        CommonDialog1.CancelError = True
        CommonDialog1.Filter = "All Files|*.*|Text Files|*.txt|Binary Files|*.bin|Font Files|*.fnt"
        CommonDialog1.ShowOpen
        
        GetFile = CommonDialog1.Filename
        Exit Function
        
DialogError:
        GetFile = ""
        Exit Function
End Function

