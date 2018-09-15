---
layout:      page
title:       TechRef - Contents
description: ProDOS 8 Technical Reference Manual Contents
permalink:   /docs/techref/contents/
---



<H2>Contents</H2>

<UL>
<LI><B><A HREF="/docs/techref/preface/#P">Preface</A></B> ... xv
<UL>
<LI><A HREF="/docs/techref/preface/#P1">About ProDOS</A> ... xv
<LI><A HREF="/docs/techref/preface/#P2">About This Manual</A> ... xvi
<LI><A HREF="/docs/techref/preface/#P3">What These Mean</A> ... xvii
<LI><A HREF="/docs/techref/preface/#P4">About the Apple IIc</A> ... xvii
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/introduction/#1">Chapter 1</A> - Introduction</B> ... 1
<UL>
<LI><A HREF="/docs/techref/introduction/#1.1">1.1</A> - What Is ProDOS? ... 2
<UL>
<LI><A HREF="/docs/techref/introduction/#1.1.1">1.1.1</A> - Use of Disk Drives ... 3
<LI><A HREF="/docs/techref/introduction/#1.1.2">1.1.2</A> - Volume and File Characteristics ... 5
<LI><A HREF="/docs/techref/introduction/#1.1.3">1.1.3</A> - Use of Memory ... 5
<LI><A HREF="/docs/techref/introduction/#1.1.4">1.1.4</A> - Use of Interrupt Driven Devices ... 6
<LI><A HREF="/docs/techref/introduction/#1.1.5">1.1.5</A> - Use of Other Devices ... 6
</UL>
<LI><A HREF="/docs/techref/introduction/#1.2">1.2</A> - Summary ... 7
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/file-use/#2">Chapter 2</A> - File Use</B> ... 9
<UL>
<LI><A HREF="/docs/techref/file-use/#2.1">2.1</A> - Using Files ... 10
<UL>
<LI><A HREF="/docs/techref/file-use/#2.1.1">2.1.1</A> - Pathnames ... 10
<LI><A HREF="/docs/techref/file-use/#2.1.2">2.1.2</A> - Creating Files ... 13
<LI><A HREF="/docs/techref/file-use/#2.1.3">2.1.3</A> - Opening Files ... 13
<LI><A HREF="/docs/techref/file-use/#2.1.4">2.1.4</A> - The EOF and MARK ... 14
<LI><A HREF="/docs/techref/file-use/#2.1.5">2.1.5</A> - Reading and Writing Files ... 15
<LI><A HREF="/docs/techref/file-use/#2.1.6">2.1.6</A> - Closing and Flushing Files ... 16
<LI><A HREF="/docs/techref/file-use/#2.1.7">2.1.7</A> - File Levels ... 17
</UL>
</UL>
</UL>

<a name="pagevi"></a>

<UL>
<UL>
<LI><A HREF="/docs/techref/file-use/#2.2">2.2</A> - File Organization ... 17
<UL>
<LI><A HREF="/docs/techref/file-use/#2.2.1">2.2.1</A> - Directory Files and Standard Files ... 17
<LI><A HREF="/docs/techref/file-use/#2.2.2">2.2.2</A> - File Structure ... 18
<LI><A HREF="/docs/techref/file-use/#2.2.3">2.2.3</A> - Sparse Files ... 20
</UL>
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/memory-use/#3">Chapter 3</A> - Memory Use</B> ... 21
<UL>
<LI><A HREF="/docs/techref/memory-use/#3.1">3.1</A> - Loading Sequence ... 22
<LI><A HREF="/docs/techref/memory-use/#3.2">3.2</A> - Volume Search Order ... 23
<LI><A HREF="/docs/techref/memory-use/#3.3">3.3</A> - Memory Map ... 23
<UL>
<LI><A HREF="/docs/techref/memory-use/#3.3.1">3.3.1</A> - Zero Page ... 25
<LI><A HREF="/docs/techref/memory-use/#3.3.2">3.3.2</A> - The System Global Page ... 25
<LI><A HREF="/docs/techref/memory-use/#3.3.3">3.3.3</A> - The System Bit Map ... 25
</UL>
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/calls-to-the-mli/#4">Chapter 4</A> - Calls to the MLI</B> ... 27
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.1">4.1</A> - The Machine Language Interface ... 28
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.2">4.2</A> - Issuing a Call to the MLI ... 29
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.2.1">4.2.1</A> - Parameter Lists ... 31
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.2.2">4.2.2</A> - The ProDOS Machine Language Exerciser ... 31
</UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.3">4.3</A> - The MLI Calls ... 32
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.3.1">4.3.1</A> - Housekeeping Calls ... 32
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.3.2">4.3.2</A> - Filing Calls ... 33
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.3.3">4.3.3</A> - System Calls ... 35
</UL>
</UL>
</UL>

<a name="pagevii"></a>

<UL>
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4">4.4</A> - Housekeeping Calls ... 36
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.1">4.4.1</A> - CREATE ($C0) ... 36
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.2">4.4.2</A> - DESTROY ($C1) ... 40
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.3">4.4.3</A> - RENAME ($C2) ... 42
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.4">4.4.4</A> - SET_FILE_INFO ($C3) ... 43
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.5">4.4.5</A> - GET_FILE_INFO ($C4) ... 47
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.6">4.4.6</A> - ON_LINE ($C5) ... 51
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.7">4.4.7</A> - SET_PREFIX ($C6) ... 54
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.4.8">4.4.8</A> - GET_PREFIX ($C7) ... 55
</UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5">4.5</A> - Filing Calls ... 56
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.1">4.5.1</A> - OPEN ($C8) ... 56
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.2">4.5.2</A> - NEWLINE ($C9) ... 58
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.3">4.5.3</A> - READ ($CA) ... 59
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.4">4.5.4</A> - WRITE ($CB) ... 61
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.5">4.5.5</A> - CLOSE ($CC) ... 63
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.6">4.5.6</A> - FLUSH ($CD) ... 64
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.7">4.5.7</A> - SET_MARK ($CE) ... 65
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.8">4.5.8</A> - GET_MARK ($CF) ... 66
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.9">4.5.9</A> - SET_EOF ($D0) ... 67
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.10">4.5.10</A> - GET_EOF ($D1) ... 68
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.11">4.5.11</A> - SET_BUF ($D2) ... 69
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.5.12">4.5.12</A> - GET_BUF ($D3) ... 70
</UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.6">4.6</A> - System Calls ... 71
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.6.1">4.6.1</A> - GET_TIME ($82) ... 71
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.6.2">4.6.2</A> - ALLOC_INTERRUPT ($40) ... 72
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.6.3">4.6.3</A> - DEALLOC_INTERRUPT ($41) ... 73
</UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.7">4.7</A> - Direct Disk Access Commands ... 73
<UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.7.1">4.7.1</A> - READ_BLOCK ($80) ... 74
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.7.2">4.7.2</A> - WRITE_BLOCK ($81) ... 75
</UL>
<LI><A HREF="/docs/techref/calls-to-the-mli/#4.8">4.8</A> - MLI Error Codes ... 77
</UL>
</UL>

<a name="pageviii"></a>

<UL>
<LI><B><A HREF="/docs/techref/writing-a-prodos-system-program/#5">Chapter 5</A> - Writing a ProDOS System Program</B> ... 81
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1">5.1</A> - System Program Requirements ... 82
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.1">5.1.1</A> - Placement in Memory ... 82
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.2">5.1.2</A> - Relocating the Code ... 84
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.3">5.1.3</A> - Updating the System Global Page ... 84
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.4">5.1.4</A> - The System Bit Map ... 84
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.4.1">5.1.4.1</A> - Using the Bit Map ... 85
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.5">5.1.5</A> - Switching System Programs ... 86
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.5.1">5.1.5.1</A> - Starting System Programs ... 86
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.1.5.2">5.1.5.2</A> - Quitting System Programs ... 87
</UL>
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2">5.2</A> - Managing System Resources ... 89
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.1">5.2.1</A> - Using the Stack ... 89
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.2">5.2.2</A> - Using the Alternate 64K RAM Bank ... 89
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.2.1">5.2.2.1</A> - Protecting Auxiliary Bank Hi-Res Graphics Pages ... 89
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.2.2">5.2.2.2</A> - Disconnecting /RAM ... 90
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.2.3">5.2.2.3</A> - How to Treat RAM Disks With More Than 64K ... 91
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.2.4">5.2.2.4</A> - Reinstalling /RAM ... 92
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.3">5.2.3</A> - The System Global Page ... 94
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.2.4">5.2.4</A> - Rules for Using the System Global Page ... 94
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3">5.3</A> - General Techniques ... 98
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.1">5.3.1</A> - Determining Machine Configuration ... 98
<UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.1.1">5.3.1.1</A> - Machine Type ... 98
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.1.2">5.3.1.2</A> - Memory Size ... 98
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.1.3">5.3.1.3</A> - 80-Column Text Card ... 99
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.2">5.3.2</A> - Using the Date ... 99
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.3">5.3.3</A> - System Program Defaults ... 100
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.4">5.3.4</A> - Finding a Volume ... 100
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.3.5">5.3.5</A> - Using the RESET Vector ... 101
</UL>
<LI><A HREF="/docs/techref/writing-a-prodos-system-program/#5.4">5.4</A> - ProDOS System Program Conventions ... 101
</UL>
</UL>

<a name="pageix"></a>

<UL>
<LI><B><A HREF="/docs/techref/adding-routines-to-prodos/#6">Chapter 6</A> - Adding Routines to ProDOS</B> ... 103
<UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.1">6.1</A> - Clock/Calendar Routines ... 104
<UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.1.1">6.1.1</A> - Other Clock/Calendars ... 106
</UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.2">6.2</A> - Interrupt Handling Routines ... 106
<UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.2.1">6.2.1</A> - Interrupts During MLI Calls ... 108
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.2.2">6.2.2</A> - Sample Interrupt Routine ... 109
</UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.3">6.3</A> - Disk Driver Routines ... 112
<UL>
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.3.1">6.3.1</A> - ROM Code Conventions ... 112
<LI><A HREF="/docs/techref/adding-routines-to-prodos/#6.3.2">6.3.2</A> - Call Parameters ... 114
</UL>
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/the-prodos-basic-system-program/#A">Appendix A</A> - The ProDOS BASIC System Program</B> ... 117
<UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.1">A.1</A> - Memory Map ... 118
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.2">A.2</A> - HIMEM ... 120
<UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.2.1">A.2.1</A> - Buffer Management ... 121
</UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3">A.3</A> - The BASIC Global Page ... 123
<UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3.1">A.3.1</A> - BASIC.SYSTEM Commands From Assembly Language ... 131
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3.2">A.3.2</A> - Adding Commands to the BASIC System Program ... 134
<UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3.2.1">A.3.2.1</A> - BEEP Example ... 136
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3.2.2">A.3.3.2</A> - BEEPSLOT Example ... 138
</UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.3.3">A.3.3</A> - Command String Parsing ... 140
</UL>
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.4">A.4</A> - Zero Page ... 142
<LI><A HREF="/docs/techref/the-prodos-basic-system-program/#A.5">A.5</A> - The Extended 80-Column Text Card ... 143
</UL>
</UL>

<a name="pagex"></a>

<UL>
<LI><B><A HREF="/docs/techref/file-organization/#B">Appendix B</A> - File Organization</B> ... 145
<UL>
<LI><A HREF="/docs/techref/file-organization/#B.1">B.1</A> - Format of Information on a Volume ... 146
<LI><A HREF="/docs/techref/file-organization/#B.2">B.2</A> - Format of Directory Files ... 147
<UL>
<LI><A HREF="/docs/techref/file-organization/#B.2.1">B.2.1</A> - Pointer Fields ... 148
<LI><A HREF="/docs/techref/file-organization/#B.2.2">B.2.2</A> - Volume Directory Headers ... 148
<LI><A HREF="/docs/techref/file-organization/#B.2.3">B.2.3</A> - Subdirectory Headers ... 151
<LI><A HREF="/docs/techref/file-organization/#B.2.4">B.2.4</A> - File Entries ... 154
<LI><A HREF="/docs/techref/file-organization/#B.2.5">B.2.5</A> - Reading a Directory File ... 157
</UL>
<LI><A HREF="/docs/techref/file-organization/#B.3">B.3</A> - Format of Standard Files ... 159
<UL>
<LI><A HREF="/docs/techref/file-organization/#B.3.1">B.3.1</A> - Growing a Tree File ... 159
<LI><A HREF="/docs/techref/file-organization/#B.3.2">B.3.2</A> - Seedling Files ... 161
<LI><A HREF="/docs/techref/file-organization/#B.3.3">B.3.3</A> - Sapling Files ... 162
<LI><A HREF="/docs/techref/file-organization/#B.3.4">B.3.4</A> - Tree Files ... 163
<LI><A HREF="/docs/techref/file-organization/#B.3.5">B.3.5</A> - Using Standard Files ... 163
<LI><A HREF="/docs/techref/file-organization/#B.3.6">B.3.6</A> - Sparse Files ... 164
<LI><A HREF="/docs/techref/file-organization/#B.3.7">B.3.7</A> - Locating a Byte in a File ... 166
</UL>
<LI><A HREF="/docs/techref/file-organization/#B.4">B.4</A> - Disk Organization ... 167
<UL>
<LI><A HREF="/docs/techref/file-organization/#B.4.1">B.4.1</A> - Standard Files ... 169
<LI><A HREF="/docs/techref/file-organization/#B.4.2">B.4.2</A> - Header and Entry Fields ... 170
<UL>
<LI><A HREF="/docs/techref/file-organization/#B.4.2.1">B.4.2.1</A> - The storage_type Attribute ... 171
<LI><A HREF="/docs/techref/file-organization/#B.4.2.2">B.4.2.2</A> - The creation and last_mod Fields ... 171
<LI><A HREF="/docs/techref/file-organization/#B.4.2.3">B.4.2.3</A> - The access Attribute ... 172
<LI><A HREF="/docs/techref/file-organization/#B.4.2.4">B.4.2.4</A> - The file_type Attribute ... 172
</UL>
</UL>
<LI><A HREF="/docs/techref/file-organization/#B.5">B.5</A> - DOS 3.3 Disk Organization ... 174
</UL>
</UL>

<a name="pagexi"></a>

<UL>
<LI><B><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C">Appendix C</A> - ProDOS, the Apple III, and SOS</B> ... 175
<UL>
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.1">C.1</A> - ProDOS, the Apple III, and SOS ... 176
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.2">C.2</A> - File Compatibility ... 176
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.3">C.3</A> - Operating System Compatibility ... 177
<UL>
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.3.1">C.3.1</A> - Comparison of Input/Output ... 177
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.3.2">C.3.2</A> - Comparison of Filing Calls ... 177
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.3.3">C.3.3</A> - Memory Handling Techniques ... 178
<LI><A HREF="/docs/techref/prodos-the-appleiii-and-sos/#C.3.4">C.3.4</A> - Comparison of Interrupts ... 178
</UL>
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/the-prodos-machine-language-exerciser/#D">Appendix D</A> - The ProDOS Machine Language Exerciser</B> ... 179
<UL>
<LI><A HREF="/docs/techref/the-prodos-machine-language-exerciser/#D.1">D.1</A> - How to Use It ... 180
<LI><A HREF="/docs/techref/the-prodos-machine-language-exerciser/#D.2">D.2</A> - Modify Buffer ... 181
</UL>
</UL>

<UL>
<LI><B><A HREF="/docs/techref/index/#I">Index</A></B> ... 183
</UL>

<UL>
<LI><B><A HREF="/docs/techref/quick-reference-card/#QR">Quick Reference Card</A></B>
</UL>

<a name="pagexii"></a>










