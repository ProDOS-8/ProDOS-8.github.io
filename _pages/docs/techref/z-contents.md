---
layout:      page
title:       TechRef - Contents
description: ProDOS 8 Technical Reference Manual Contents
permalink:   /docs/techref/contents/
---

<a name="pagevi"></a>
<a name="pagevii"></a>
<a name="pageviii"></a>
<a name="pageix"></a>
<a name="pagex"></a>
<a name="pagexi"></a>
<a name="pagexii"></a>


Can't find what you're looking for? Check the [Index](/docs/techref/index/#I).


## [Preface](/docs/techref/preface/#P) ... xv

  * [About ProDOS](/docs/techref/preface/#P1) ... xv
  * [About This Manual](/docs/techref/preface/#P2) ... xvi
  * [What These Mean](/docs/techref/preface/#P3) ... xvii
  * [About the Apple IIc](/docs/techref/preface/#P4) ... xvii






## [Chapter 1 - Introduction](/docs/techref/introduction/#1) ... 1

  * [1.1 - What Is ProDOS?](/docs/techref/introduction/#1.1) ... 2

    * [1.1.1 - Use of Disk Drives](/docs/techref/introduction/#1.1.1) ... 3
    * [1.1.2 - Volume and File Characteristics](/docs/techref/introduction/#1.1.2) ... 5
    * [1.1.3 - Use of Memory](/docs/techref/introduction/#1.1.3) ... 5
    * [1.1.4 - Use of Interrupt Driven Devices](/docs/techref/introduction/#1.1.4) ... 6
    * [1.1.5 - Use of Other Devices](/docs/techref/introduction/#1.1.5) ... 6

  * [1.2 - Summary](/docs/techref/introduction/#1.2) ... 7








## [Chapter 2 - File Use](/docs/techref/file-use/#2) ... 9

  * [2.1 - Using Files](/docs/techref/file-use/#2.1) ... 10

    * [2.1.1 - Pathnames](/docs/techref/file-use/#2.1.1) ... 10
    * [2.1.2 - Creating Files](/docs/techref/file-use/#2.1.2) ... 13
    * [2.1.3 - Opening Files](/docs/techref/file-use/#2.1.3) ... 13
    * [2.1.4 - The EOF and MARK](/docs/techref/file-use/#2.1.4) ... 14
    * [2.1.5 - Reading and Writing Files](/docs/techref/file-use/#2.1.5) ... 15
    * [2.1.6 - Closing and Flushing Files](/docs/techref/file-use/#2.1.6) ... 16
    * [2.1.7 - File Levels](/docs/techref/file-use/#2.1.7) ... 17







  * [2.2 - File Organization](/docs/techref/file-use/#2.2) ... 17

    * [2.2.1 - Directory Files and Standard Files](/docs/techref/file-use/#2.2.1) ... 17
    * [2.2.2 - File Structure](/docs/techref/file-use/#2.2.2) ... 18
    * [2.2.3 - Sparse Files](/docs/techref/file-use/#2.2.3) ... 20





## [Chapter 3 - Memory Use](/docs/techref/memory-use/#3) ... 21

  * [3.1 - Loading Sequence](/docs/techref/memory-use/#3.1) ... 22
  * [3.2 - Volume Search Order](/docs/techref/memory-use/#3.2) ... 23
  * [3.3 - Memory Map](/docs/techref/memory-use/#3.3) ... 23

    * [3.3.1 - Zero Page](/docs/techref/memory-use/#3.3.1) ... 25
    * [3.3.2 - The System Global Page](/docs/techref/memory-use/#3.3.2) ... 25
    * [3.3.3 - The System Bit Map](/docs/techref/memory-use/#3.3.3) ... 25





## [Chapter 4 - Calls to the MLI](/docs/techref/calls-to-the-mli/#4) ... 27

  * [4.1 - The Machine Language Interface](/docs/techref/calls-to-the-mli/#4.1) ... 28
  * [4.2 - Issuing a Call to the MLI](/docs/techref/calls-to-the-mli/#4.2) ... 29

    * [4.2.1 - Parameter Lists](/docs/techref/calls-to-the-mli/#4.2.1) ... 31
    * [4.2.2 - The ProDOS Machine Language Exerciser](/docs/techref/calls-to-the-mli/#4.2.2) ... 31

  * [4.3 - The MLI Calls](/docs/techref/calls-to-the-mli/#4.3) ... 32

    * [4.3.1 - Housekeeping Calls](/docs/techref/calls-to-the-mli/#4.3.1) ... 32
    * [4.3.2 - Filing Calls](/docs/techref/calls-to-the-mli/#4.3.2) ... 33
    * [4.3.3 - System Calls](/docs/techref/calls-to-the-mli/#4.3.3) ... 35

  * [4.4 - Housekeeping Calls](/docs/techref/calls-to-the-mli/#4.4) ... 36

    * [4.4.1 - CREATE ($C0)](/docs/techref/calls-to-the-mli/#4.4.1) ... 36
    * [4.4.2 - DESTROY ($C1)](/docs/techref/calls-to-the-mli/#4.4.2) ... 40
    * [4.4.3 - RENAME ($C2)](/docs/techref/calls-to-the-mli/#4.4.3) ... 42
    * [4.4.4 - SET_FILE_INFO ($C3)](/docs/techref/calls-to-the-mli/#4.4.4) ... 43
    * [4.4.5 - GET_FILE_INFO ($C4)](/docs/techref/calls-to-the-mli/#4.4.5) ... 47
    * [4.4.6 - ON_LINE ($C5)](/docs/techref/calls-to-the-mli/#4.4.6) ... 51
    * [4.4.7 - SET_PREFIX ($C6)](/docs/techref/calls-to-the-mli/#4.4.7) ... 54
    * [4.4.8 - GET_PREFIX ($C7)](/docs/techref/calls-to-the-mli/#4.4.8) ... 55

  * [4.5 - Filing Calls](/docs/techref/calls-to-the-mli/#4.5) ... 56

    * [4.5.1 - OPEN ($C8)](/docs/techref/calls-to-the-mli/#4.5.1) ... 56
    * [4.5.2 - NEWLINE ($C9)](/docs/techref/calls-to-the-mli/#4.5.2) ... 58
    * [4.5.3 - READ ($CA)](/docs/techref/calls-to-the-mli/#4.5.3) ... 59
    * [4.5.4 - WRITE ($CB)](/docs/techref/calls-to-the-mli/#4.5.4) ... 61
    * [4.5.5 - CLOSE ($CC)](/docs/techref/calls-to-the-mli/#4.5.5) ... 63
    * [4.5.6 - FLUSH ($CD)](/docs/techref/calls-to-the-mli/#4.5.6) ... 64
    * [4.5.7 - SET_MARK ($CE)](/docs/techref/calls-to-the-mli/#4.5.7) ... 65
    * [4.5.8 - GET_MARK ($CF)](/docs/techref/calls-to-the-mli/#4.5.8) ... 66
    * [4.5.9 - SET_EOF ($D0)](/docs/techref/calls-to-the-mli/#4.5.9) ... 67
    * [4.5.10 - GET_EOF ($D1)](/docs/techref/calls-to-the-mli/#4.5.10) ... 68
    * [4.5.11 - SET_BUF ($D2)](/docs/techref/calls-to-the-mli/#4.5.11) ... 69
    * [4.5.12 - GET_BUF ($D3)](/docs/techref/calls-to-the-mli/#4.5.12) ... 70

  * [4.6 - System Calls](/docs/techref/calls-to-the-mli/#4.6) ... 71

    * [4.6.1 - GET_TIME ($82)](/docs/techref/calls-to-the-mli/#4.6.1) ... 71
    * [4.6.2 - ALLOC_INTERRUPT ($40)](/docs/techref/calls-to-the-mli/#4.6.2) ... 72
    * [4.6.3 - DEALLOC_INTERRUPT ($41)](/docs/techref/calls-to-the-mli/#4.6.3) ... 73

  * [4.7 - Direct Disk Access Commands](/docs/techref/calls-to-the-mli/#4.7) ... 73

    * [4.7.1 - READ_BLOCK ($80)](/docs/techref/calls-to-the-mli/#4.7.1) ... 74
    * [4.7.2 - WRITE_BLOCK ($81)](/docs/techref/calls-to-the-mli/#4.7.2) ... 75

  * [4.8 - MLI Error Codes](/docs/techref/calls-to-the-mli/#4.8) ... 77











## [Chapter 5 - Writing a ProDOS System Program](/docs/techref/writing-a-prodos-system-program/#5) ... 81

  * [5.1 - System Program Requirements](/docs/techref/writing-a-prodos-system-program/#5.1) ... 82

    * [5.1.1 - Placement in Memory](/docs/techref/writing-a-prodos-system-program/#5.1.1) ... 82
    * [5.1.2 - Relocating the Code](/docs/techref/writing-a-prodos-system-program/#5.1.2) ... 84
    * [5.1.3 - Updating the System Global Page](/docs/techref/writing-a-prodos-system-program/#5.1.3) ... 84
    * [5.1.4 - The System Bit Map](/docs/techref/writing-a-prodos-system-program/#5.1.4) ... 84

      * [5.1.4.1 - Using the Bit Map](/docs/techref/writing-a-prodos-system-program/#5.1.4.1) ... 85

    * [5.1.5 - Switching System Programs](/docs/techref/writing-a-prodos-system-program/#5.1.5) ... 86

      * [5.1.5.1 - Starting System Programs](/docs/techref/writing-a-prodos-system-program/#5.1.5.1) ... 86
      * [5.1.5.2 - Quitting System Programs](/docs/techref/writing-a-prodos-system-program/#5.1.5.2) ... 87

  * [5.2 - Managing System Resources](/docs/techref/writing-a-prodos-system-program/#5.2) ... 89

    * [5.2.1 - Using the Stack](/docs/techref/writing-a-prodos-system-program/#5.2.1) ... 89
    * [5.2.2 - Using the Alternate 64K RAM Bank](/docs/techref/writing-a-prodos-system-program/#5.2.2) ... 89

      * [5.2.2.1 - Protecting Auxiliary Bank Hi-Res Graphics Pages](/docs/techref/writing-a-prodos-system-program/#5.2.2.1) ... 89
      * [5.2.2.2 - Disconnecting /RAM](/docs/techref/writing-a-prodos-system-program/#5.2.2.2) ... 90
      * [5.2.2.3 - How to Treat RAM Disks With More Than 64K](/docs/techref/writing-a-prodos-system-program/#5.2.2.3) ... 91
      * [5.2.2.4 - Reinstalling /RAM](/docs/techref/writing-a-prodos-system-program/#5.2.2.4) ... 92

    * [5.2.3 - The System Global Page](/docs/techref/writing-a-prodos-system-program/#5.2.3) ... 94
    * [5.2.4 - Rules for Using the System Global Page](/docs/techref/writing-a-prodos-system-program/#5.2.4) ... 94

  * [5.3 - General Techniques](/docs/techref/writing-a-prodos-system-program/#5.3) ... 98

    * [5.3.1 - Determining Machine Configuration](/docs/techref/writing-a-prodos-system-program/#5.3.1) ... 98

      * [5.3.1.1 - Machine Type](/docs/techref/writing-a-prodos-system-program/#5.3.1.1) ... 98
      * [5.3.1.2 - Memory Size](/docs/techref/writing-a-prodos-system-program/#5.3.1.2) ... 98
      * [5.3.1.3 - 80-Column Text Card](/docs/techref/writing-a-prodos-system-program/#5.3.1.3) ... 99

    * [5.3.2 - Using the Date](/docs/techref/writing-a-prodos-system-program/#5.3.2) ... 99
    * [5.3.3 - System Program Defaults](/docs/techref/writing-a-prodos-system-program/#5.3.3) ... 100
    * [5.3.4 - Finding a Volume](/docs/techref/writing-a-prodos-system-program/#5.3.4) ... 100
    * [5.3.5 - Using the RESET Vector](/docs/techref/writing-a-prodos-system-program/#5.3.5) ... 101

  * [5.4 - ProDOS System Program Conventions](/docs/techref/writing-a-prodos-system-program/#5.4) ... 101







## [Chapter 6 - Adding Routines to ProDOS](/docs/techref/adding-routines-to-prodos/#6) ... 103

  * [6.1 - Clock/Calendar Routines](/docs/techref/adding-routines-to-prodos/#6.1) ... 104

    * [6.1.1 - Other Clock/Calendars](/docs/techref/adding-routines-to-prodos/#6.1.1) ... 106

  * [6.2 - Interrupt Handling Routines](/docs/techref/adding-routines-to-prodos/#6.2) ... 106

    * [6.2.1 - Interrupts During MLI Calls](/docs/techref/adding-routines-to-prodos/#6.2.1) ... 108
    * [6.2.2 - Sample Interrupt Routine](/docs/techref/adding-routines-to-prodos/#6.2.2) ... 109

  * [6.3 - Disk Driver Routines](/docs/techref/adding-routines-to-prodos/#6.3) ... 112

    * [6.3.1 - ROM Code Conventions](/docs/techref/adding-routines-to-prodos/#6.3.1) ... 112
    * [6.3.2 - Call Parameters](/docs/techref/adding-routines-to-prodos/#6.3.2) ... 114














## [Appendix A - The ProDOS BASIC System Program](/docs/techref/the-prodos-basic-system-program/#A) ... 117

  * [A.1 - Memory Map](/docs/techref/the-prodos-basic-system-program/#A.1) ... 118
  * [A.2 - HIMEM](/docs/techref/the-prodos-basic-system-program/#A.2) ... 120

    * [A.2.1 - Buffer Management](/docs/techref/the-prodos-basic-system-program/#A.2.1) ... 121

  * [A.3 - The BASIC Global Page](/docs/techref/the-prodos-basic-system-program/#A.3) ... 123

    * [A.3.1 - BASIC.SYSTEM Commands From Assembly Language](/docs/techref/the-prodos-basic-system-program/#A.3.1) ... 131
    * [A.3.2 - Adding Commands to the BASIC System Program](/docs/techref/the-prodos-basic-system-program/#A.3.2) ... 134

      * [A.3.2.1 - BEEP Example](/docs/techref/the-prodos-basic-system-program/#A.3.2.1) ... 136
      * [A.3.3.2 - BEEPSLOT Example](/docs/techref/the-prodos-basic-system-program/#A.3.2.2) ... 138

    * [A.3.3 - Command String Parsing](/docs/techref/the-prodos-basic-system-program/#A.3.3) ... 140

  * [A.4 - Zero Page](/docs/techref/the-prodos-basic-system-program/#A.4) ... 142
  * [A.5 - The Extended 80-Column Text Card](/docs/techref/the-prodos-basic-system-program/#A.5) ... 143
















## [Appendix B - File Organization](/docs/techref/file-organization/#B) ... 145

  * [B.1 - Format of Information on a Volume](/docs/techref/file-organization/#B.1) ... 146
  * [B.2 - Format of Directory Files](/docs/techref/file-organization/#B.2) ... 147

    * [B.2.1 - Pointer Fields](/docs/techref/file-organization/#B.2.1) ... 148
    * [B.2.2 - Volume Directory Headers](/docs/techref/file-organization/#B.2.2) ... 148
    * [B.2.3 - Subdirectory Headers](/docs/techref/file-organization/#B.2.3) ... 151
    * [B.2.4 - File Entries](/docs/techref/file-organization/#B.2.4) ... 154
    * [B.2.5 - Reading a Directory File](/docs/techref/file-organization/#B.2.5) ... 157

  * [B.3 - Format of Standard Files](/docs/techref/file-organization/#B.3) ... 159

    * [B.3.1 - Growing a Tree File](/docs/techref/file-organization/#B.3.1) ... 159
    * [B.3.2 - Seedling Files](/docs/techref/file-organization/#B.3.2) ... 161
    * [B.3.3 - Sapling Files](/docs/techref/file-organization/#B.3.3) ... 162
    * [B.3.4 - Tree Files](/docs/techref/file-organization/#B.3.4) ... 163
    * [B.3.5 - Using Standard Files](/docs/techref/file-organization/#B.3.5) ... 163
    * [B.3.6 - Sparse Files](/docs/techref/file-organization/#B.3.6) ... 164
    * [B.3.7 - Locating a Byte in a File](/docs/techref/file-organization/#B.3.7) ... 166

  * [B.4 - Disk Organization](/docs/techref/file-organization/#B.4) ... 167

    * [B.4.1 - Standard Files](/docs/techref/file-organization/#B.4.1) ... 169
    * [B.4.2 - Header and Entry Fields](/docs/techref/file-organization/#B.4.2) ... 170

      * [B.4.2.1 - The storage_type Attribute](/docs/techref/file-organization/#B.4.2.1) ... 171
      * [B.4.2.2 - The creation and last_mod Fields](/docs/techref/file-organization/#B.4.2.2) ... 171
      * [B.4.2.3 - The access Attribute](/docs/techref/file-organization/#B.4.2.3) ... 172
      * [B.4.2.4 - The file_type Attribute](/docs/techref/file-organization/#B.4.2.4) ... 172


  * [B.5 - DOS 3.3 Disk Organization](/docs/techref/file-organization/#B.5) ... 174













## [Appendix C - ProDOS, the Apple III, and SOS](/docs/techref/prodos-the-appleiii-and-sos/#C) ... 175

  * [C.1 - ProDOS, the Apple III, and SOS](/docs/techref/prodos-the-appleiii-and-sos/#C.1) ... 176
  * [C.2 - File Compatibility](/docs/techref/prodos-the-appleiii-and-sos/#C.2) ... 176
  * [C.3 - Operating System Compatibility](/docs/techref/prodos-the-appleiii-and-sos/#C.3) ... 177

    * [C.3.1 - Comparison of Input/Output](/docs/techref/prodos-the-appleiii-and-sos/#C.3.1) ... 177
    * [C.3.2 - Comparison of Filing Calls](/docs/techref/prodos-the-appleiii-and-sos/#C.3.2) ... 177
    * [C.3.3 - Memory Handling Techniques](/docs/techref/prodos-the-appleiii-and-sos/#C.3.3) ... 178
    * [C.3.4 - Comparison of Interrupts](/docs/techref/prodos-the-appleiii-and-sos/#C.3.4) ... 178








## [Appendix D - The ProDOS Machine Language Exerciser](/docs/techref/the-prodos-machine-language-exerciser/#D) ... 179

  * [D.1 - How to Use It](/docs/techref/the-prodos-machine-language-exerciser/#D.1) ... 180
  * [D.2 - Modify Buffer](/docs/techref/the-prodos-machine-language-exerciser/#D.2) ... 181







## [Quick Reference Card](/docs/techref/quick-reference-card/#QR)













