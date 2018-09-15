---
layout:      page
title:       TechRef - Appendix - Quick Reference Card
description: ProDOS 8 Technical Reference Manual Quick Reference Card
permalink:   /docs/techref/quick-reference-card/
---





## ASCII Tables

<PRE>
                        Binary
Dec     ASCII   Hex     76543210

0       NUL     00      00000000
1       SOH     01      00000001
2       STX     02      00000010
3       ETX     03      00000011
4       EOT     04      00000100
5       ENQ     05      00000101
6       ACK     06      00000110
7       BEL     07      00000111
8       BS      08      00001000
9       HT      09      00001001
10      LF      0A      00001010
11      VT      0B      00001011
12      FF      0C      00001100
13      CR      0D      00001101
14      50      0E      00001110
15      SI      0F      00001111

16      DLE     10      00010000
17      DC1     11      00010001
18      DC2     12      00010010
19      003     13      00010011
20      004     14      00010100
21      NAK     15      00010101
22      SYN     16      00010110
23      ETB     17      00010111
24      CAN     18      00011000
25      EM      19      00011001
26      SUB     1A      00011010
27      ESC     1B      00011011
28      FS      1C      00011100
29      GS      1D      00011101
30      RS      1E      00011110
31      US      1F      00011111
32      SP      20      00100000
33      !       21      00100001
34      "       22      00100010
35      #       23      00100011
36      $       24      00100100
37      %       25      00100101
38      &#38;       26      00100110
39      '       27      00100111
40      (       28      00101000
41      )       29      00101001
42      *       2A      00101010
43      +       2B      00101011
44      ,       2C      00101100
45      -       2D      00101101
46      .       2E      00101110
47      /       2F      00101111
48      0       30      00110000
49      1       31      00110001
50      2       32      00110010
51      3       33      00110011
52      4       34      00110100
53      5       35      00110101
54      6       36      00110110
55      7       37      00110111
56      8       38      00111000
57      9       39      00111001
58      .       3A      00111010
59      ;       3B      00111011
60      &#60;       3C      00111100
61      =       3D      00111101
62      &#62;       3E      00111110
63      ?       3F      00111111
64      @       40      01000000
65      A       41      01000001
66      B       42      01000010
67      C       43      01000011
68      D       44      01000100
69      E       45      01000101
70      F       46      01000110
71      G       47      01000111
72      H       48      01001000
73      I       49      01001001
74      J       4A      01001010
75      K       4B      01001011
76      L       4C      01001100
77      M       4D      01001101
78      N       4E      01001110
79      0       4F      01001111
80      P       50      01010000
81      Q       51      01010001
82      R       52      01010010
83      S       53      01010011
84      T       54      01010100
85      U       55      01010101
86      V       56      01010110
87      W       57      01010111
88      X       58      01011000
89      Y       59      01011001
90      Z       5A      01011010
91      [       5B      01011011
92      /       5C      01011100
93      ]       5D      01011101
94      ^       5E      01011110
95      _       5F      01011111
96      `       60      01100000
97      a       61      01100001
98      b       62      01100010
99      C       63      01100011
100     d       64      01100100
101     e       65      01100101
102     f       66      01100110
103     g       67      01100111
104     h       68      01101000
105     i       69      01101001
106     j       6A      01101010
107     k       6B      01101011
108     I       6C      01101100
109     m       6D      01101101
110     n       6E      01101110
111     a       6F      01101111
112     p       70      01110000
113     q       71      01110001
114     r       72      01110010
115     s       73      01110011
116     t       74      01110100
117     u       75      01110101
118     v       76      01110110
119     w       77      01110111
120     x       78      01111000
121     y       79      01111001
122     z       7A      01111010
123     {       7B      01111011
124     |       7C      01111100
125     }       7D      01111101
126     ~       7E      01111110
127     DEL     7F      01111111
</PRE>

## File Types

<PRE>
**file_type       Preferred Use**

$00             Typeless file (SOS and ProDOS)
$01             Bad block file
$02 *           Pascal code file
$03 *           Pascal text file
$04             ASCII text file (SOS and ProDOS)
$05 *           Pascal data file
$06             General binary file (SOS and ProDOS)
$07 *           Font file
$08             Graphics screen file
$09 *           Business BASIC program file
$0A *           Business BASIC data file
$0B *           Word Processor file
$0C *           SOS system file
$0D,$0E *       SOS reserved
$0F             Directory file (SOS and ProDOS)
$10 *           RPS data file
$11 *           RPS index file
$12 *           AppleFile discard file
$13 *           AppleFile model file
$14 *           AppleFile report format file
$15 *           Screen library file
$16-$18 *       SOS reserved
$19             AppleWorks Data Base file
$1A             AppleWorks Word Processor file
$1B             AppleWorks Spreadsheet file
$1C-$EE         Reserved
$EF             Pascal area
$F0             ProDOS added command file
$F1-$F8         ProDOS user defined files 1-8
$F9             ProDOS reserved
$FA             Integer BASIC program file
$FB             Integer BASIC variable file
$FC             Applesoft program file
$FD             Applesoft variables file
$FE             Relocatable code file (EDASM)
$FF             ProDOS system file
</PRE>

* Apple III SOS only; not used by ProDOS.

For the file_types used by Apple III SOS only, refer to the <I>SOS Reference Manual</I>.



## MLI Error Codes

<PRE>
$00:    No error
$01:    Bad system call number
$04:    Bad system call parameter count
$25:    Interrupt table full
$27:    I/O error
$28:    No device connected
$2B:    Disk write protected
$2E:    Disk switched
$40:    Invalid pathname
$42:    Maximum number of files open
$43:    Invalid reference number
$44:    Directory not found
$45:    Volume not found
$46:    File not found
$47:    Duplicate filename
$48:    Volume full
$49:    Volume directory full
$4A:    Incompatible file format, also a ProDOS directory
$4B:    Unsupported storage_type
$4C:    End of file encountered
$4D:    Position out of range
$4E:    File access error, also file locked
$50:    File is open
$51:    Directory structure damaged
$52:    Not a ProDOS volume
$53:    Invalid system call parameter
$55:    Volume Control Block table full
$56:    Bad buffer address
$57:    Duplicate volume
$5A:    File structure damaged
</PRE>

Refer to Section 4.8 for a more detailed description of these error codes.



## ProDOS MLI Calls

<PRE>



 4.4.1 CREATE ($C0)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 7               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access         (1-byte value) |
    +---+---+---+---+---+---+---+---+
  4 | file_type      (1-byte value) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  |
  6 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  7 | storage_type   (1-byte value) |
    +---+---+---+---+---+---+---+---+
  8 | create_date          (byte 0) |
  9 | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
  A | create_time          (byte 0) |
  B | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+




 4.4.2 DESTROY ($C1)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.4.3 RENAME ($C2)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | new_pathname           (low)  |
  4 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.4.4 SET_FILE_INFO ($C3)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 7               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access         (1-byte value) |
    +---+---+---+---+---+---+---+---+
  4 | file_type      (1-byte value) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  |
  6 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  7 |                               |
  8 | null_field          (3 bytes) |
  9 |                               |
    +---+---+---+---+---+---+---+---+
  A | mod_date             (byte 0) |
  B | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
  C | mod_time             (byte 0) |
  D | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+




 4.4.5 GET_FILE_INFO ($C4)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = $A              |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access        (1-byte result) |
    +---+---+---+---+---+---+---+---+
  4 | file_type     (1-byte result) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  | *
  6 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
  7 | storage_type  (1-byte result) |
    +---+---+---+---+---+---+---+---+
  8 | blocks used            (low)  | *
  9 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
  A | mod_date             (byte 0) |
  B | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
  C | mod_time             (byte 0) |
  D | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
  E | create_date          (byte 0) |
  F | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
 10 | create_time          (byte 0) |
 11 | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+

 * When file information about a
   volume directory is requested,
   the total number of blocks on
   the volume is returned in the
   aux_type field and the total
   blocks for all files is returned
   in blocks_used.




 4.4.6 ON_LINE ($C5)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.4.7 SET_PREFIX ($C6)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.4.8 GET_PREFIX ($C7)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | data_buffer            (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.5.1 OPEN ($C8)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | io_buffer              (low)  |
  4 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  5 | ref_num       (1-byte result) |
    +---+---+---+---+---+---+---+---+




 4.5.2 NEWLINE ($C9)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | enable_mask    (1-byte value) |
    +---+---+---+---+---+---+---+---+
  3 | newline_char   (1-byte value) |
    +---+---+---+---+---+---+---+---+




 4.5.3 READ ($CA)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 4               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | request_count          (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  6 | trans_count            (low)  |
  7 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+




 4.5.4 WRITE ($CB)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 4               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | request_count          (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  6 | trans_count            (low)  |
  7 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+




 4.5.5 CLOSE ($CC)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+




 4.5.6 FLUSH ($CD)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+




 4.5.7 SET_MARK ($CE)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | position       (3-byte value) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+




 4.5.8 GET_MARK ($CF)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | position      (3-byte result) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+



 4.5.9 SET_EOF ($D0)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | EOF            (3-byte value) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+




 4.5.10 GET_EOF ($D1)

      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | EOF           (3-byte result) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+




 4.5.11 SET_BUF ($D2)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | io_buffer              (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.5.12 GET_BUF ($D3)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | io_buffer              (low)  |
  3 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+




 4.6.2 ALLOC_INTERRUPT ($40)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | int_num       (1-byte result) |
    +---+---+---+---+---+---+---+---+
  2 | int_code               (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+




 4.6.3 DEALLOC_INTERRUPT ($41)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | int_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+




 4.7.1 READ_BLOCK ($80)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | block_num              (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+




 4.7.2 WRITE_BLOCK ($81)


      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | block_num              (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+

</PRE>