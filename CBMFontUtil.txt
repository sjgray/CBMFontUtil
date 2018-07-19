CBM Font Utility - V1.2, July 19, 2018 - (C)2015-2018 Steve J. Gray
================

web....: www.stevegray.ca
email..: sjgray@rogers.com

The CBM Font Utility is a Windows PC program written using VisualBASIC 6. It runs on
Windows 95 or later (including Windows 10).

This program lets you split, combine, and convert Commodore fonts. It is NOT a font editor.
It was written primarily to aid in creating a font EPROM for my ColourPET+G project.
Commodore PET fonts (or should I say character sets) contain 128 symbols, with each symbol
using an 8x8 pixel matrix and therefor using 8 bytes to define one symbol. For the PET, the
"reverse" characters (codes 128-256) are not included in the ROM they are generated via a hardware
circuit thus reducing ROM size.

The Commodore CBM-II was a followup to the PET with two models and is also supported in a limited
way. The Hi-Profile version used an 8x16 matrix (with 14 rows visible) and the Lo-Profile
version had 8 rows visible. I must note that I am considering allowing the ColourPET+G to
use 8x16 fonts and so this utility was also written with that in mind.

A typical PET character ROM normally contains two standard fonts:
	"text"...... contains uppercase, lowercase and a few graphic symbols
	"graphics".. contains uppercase and a full set of graphics.

Later models expanded that to 4 fonts, although this was only used in the SuperPET and some
German models. There were several international character ROMs.


Screen Layout
-------------

Source File.... Either a font file or a text file depending on the mode.
		Use the "..." button to open a file.
Operation...... Drop-down list used to specify which operation is performed.
Characters..... Specifies the format of the input file, either 8x8 or 8x16.
Option......... Allows entry of a value for some operations.
Output File.... The name of the file to create.
About Button... Display program (C) and info.
GO Button...... Start processing.

Operations
----------

These are the operations available from the drop-down menu:

* Combine Fonts or Sets using list file (.txt)
	A plain text file is used as the source file. Each line in the file specifies the
	name of a file to add to the output file. You may use comment lines with ; as the
	first chr. If a file is not found a warning will be displayed and it will be skipped,
	but the remaining file(s) will be included.

* Split to...	
	Reads the source file and splits it to the selected number of characters. Make sure
	to set the character size (8x8 or 8x16) first!

	The output file name will be used as a base name. Each individual font will be named
	by adding "-xx.bin" to the end of the output filename. Where xx is a number.
	For example:
		font-1.bin
		font-2.bin
		font-3.bin ... etc

	The following are available:
	* Split to Character..... A single character
	* Split to Sub Font...... 32 Characters
	* Split to Font.......... 128 Characters
	* Split to Font Pairs.... 256 Characters
	* Split to Font Sets..... 512 Characters
	* Split to Font Sets..... 1024 Characters

* Expand to 8x16 pixels
	Adds 8 blank rows to expand an 8x8 chr to 8x16.
	Option value specifies how many blank rows to insert at top.

* Expand non-cbm font
	Adds appropriate number of blank rows to pad to 8x8 or 8x16.
	Specify the number of rows in the source file in the Option box.

* Stretch to 8x16 pixels
	Double each row.

* Compact to 8x8 pixels
	Take only first 8 rows, discarding the rest.

* Squish to 8x8 pixels
	Copies only ODD or EVEN rows to output.
	Option: 0=Even, 1=Odd

* Invert Pixels
	Like "RVS" characters. 

* Make BOLD
	Makes each character BOLD. Copies all ON pixels one bit to the right.

* Make Italic
	Makes each character ITALIC. <<< Currently not implemented >>>

* Make Underlined
	Makes each character UNDERLINED.
	Option specifies which ROW is used for underline.
	0=None, or 1 to 16 (Depending on source format).

* Rotate 90 
	Rotates each character 90 degrees. Only works on 8x8 fonts.

* Rotate 180
	Rotates each character 180 degrees. Only works on 8x8 fonts.

* Rotate 270
	Rotates each character 270 degrees. Only works on 8x8 fonts.

* Mirror Horizontal
	Mirror each character on the horizontal plane.

* Mirror Vertical
	Mirror each character on the vertical plane.

* Shift Left 1 Pixel
	Shifts each character 1 pixel to the Left. Leftmost pixel is lost.

* Shift Right 1 Pixel
	Shifts each character 1 pixel to the Right. Rightmost pixel is lost.

* Rotate Left 1 Pixel
	Rotates each character 1 pixel to the Left. Leftmost pixel rotates to right side.

* Rotate Right 1 Pixel
	Rotates each character 1 pixel to the Right. Rightmost pixel rotates to left side.

* Double Wide - Left side
	Double wide characters are created using the same symbol, but using two
        different fonts to form one larger character. So for example the letter "A"
	would be drawn on screen as "AA" where the left A could be FONTSET 8 and the right
	A as FONTSET 9. This option creates the left side.

* Double Wide - Right side
	This option creates the right side.

* Double Tall - Top
	Similar to double wide.
	This option creates the top half.

* Double Tall - Bottom
	This option creates the bottom half.

* Double Size - Top Left
	Double size is both WIDE and TALL and requires 4 characters.
	This option creates the top left character.

* Double Size - Top Right
	This option creates the top right character.

* Double Size - Bottom Left
	This option creates the bottom left character.

* Doube Size - Bottom Right
	This option creates the bottom right character.


ColourPET+G Font Usage
----------------------

ColourPET+G is currently in early planning stages. It is a followup to my ColourPET project.
It is planned that 4 bits from the character colour be configurable as font selection bits.
This would allow up to 16 font sets. For compatibility reasons, one "Font Set" contains 4
individual fonts. Printing CHR$(14) or CHR$(142) allows selection of standard "text" or
"graphic" sets. Accessing the other 2 fonts involve setting a line on the CRTC controller chip.

With ColourPET+G, fontset selection will be done by activating the appropriate mode, then
changing the "background colour". For example:

	PRINT "<WHITE><BLACK>" ... will set the text to WHITE and the font to SET 0 (BLACK=0)
	PRINT "<RED><WHITE>"   ... will set the text to RED and the font to SET 15 (WHITE=15)

Double TALL, WIDE and BOTH is planned to be supported in the ColourPET+G firmware.
IE: Printing will automatically set the correct fontset for each character as required.


Bugs and Missing Features
-------------------------

The initial program release should be considered as a work in progress and will be expanded
as needed. If you do not specify an output PATH, files will be written in the same
directory as the EXE file (NOT the source file path). I recommend you copy the EXE into the
directory where your source files are located!

The italic operation is not currently supported.


Revision History
================

Version 1.2 - July 19, 2018
-----------
* Add split to Fontset (1024 characters)
* Add Shift and Rotate 1 pixel Left or Right

Version 1.1 - July 13, 2018
-----------
* Add split to Character and Split to Sub Font (32 characters)
* Add pad non-cbm fonts (fonts with heights not 8 or 16)
* Add Create Text file with output filenames for split operations

Version 1.0 - Aug 10, 2015
-----------
* Initial Release!


Steve