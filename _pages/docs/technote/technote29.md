---
layout:      page
title:       ProDOS 8 Technical Note #29 - Clearing the Backup Needed Bit
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/29/
---

<h2>Written by Jim Luther (September 1990)</h2>

<p>This Technical Note shows how to clear the "backup needed bit" in a 
directory entry's access byte.</p>

<hr>

<p>If you are writing a file backup utility program, you probably want to clear 
the backup needed bit in each directory entry's access byte as you make the 
backup of the file associated with that directory entry.  The SET_FILE_INFO 
MLI call normally sets the backup needed bit of the access byte, but how do 
you clear it?  The answer is at location BUBIT ($BF95) on the ProDOS 8 system 
global page.</p>

<p>BUBIT normally contains the value $00.  When BUBIT contains $00, the 
SET_FILE_INFO MLI call always sets the backup needed bit in the directory 
entry's access byte.  However, if the value $20 is stored in BUBIT immediately 
before calling SET_FILE_INFO, the backup needed bit in the directory entry's 
access byte can be cleared.  BUBIT is set back to $00 by the MLI call.  The 
following code example shows how to clear the backup needed bit.  Values other 
than $20 or $00 in BUBIT are not supported.</p>

<pre>

; The pathname of the file should be in ThePathname buffer when this code is 
called!

               65816 off
               longa off
               longi off

ClearBackupBit start

; System global page locations

MLI            equ $BF00              ;MLI call entry point
BUBIT          equ $BF95              ;Backup Bit Disable, SET_FILE_INFO only

; MLI call numbers

SET_FILE_INFO  equ $C3
GET_FILE_INFO  equ $C4

; set up FileInfoParms for GET_FILE_INFO MLI call
               lda #$0A
               sta param_count
; then...
               jsr MLI                  ;get the current file info
               dc  I1'GET_FILE_INFO'
               dc  I2'FileInfoParms'
               bne Error

               lda #$20                 ;set the backup bit disable bit
               sta BUBIT
               eor #$FF
               and access               ;clear the backup needed bit
               sta access

; set up FileInfoParms for SET_FILE_INFO MLI call
               lda #$07
               sta param_count
; then...
               jsr MLI                  ;set the file info with the file info
               dc  I1'SET_FILE_INFO'   ;(clearing only the backup needed bit)
               dc  I2'FileInfoParms'
               bne Error
               rts                      ;return to caller

Error          anop                     ;routine to handle MLI errors
               rts

; Parameter block used for GET_FILE_INFO and SET_FILE_INFO MLI calls

FileInfoParms  anop
param_count    ds  1
pathname       dc  i2'ThePathname'
access         ds  1
file_type      ds  1
aux_type       ds  2
storage_type   ds  1
blocks_used    ds  2
mod_date       ds  2
mod_time       ds  2
create_date    ds  2
create_time    ds  2

ThePathname    entry
               ds  65                   ;store the pathname of the file here

               end

</pre>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
</ul>

<hr>



{% include technote_credit.html %}
