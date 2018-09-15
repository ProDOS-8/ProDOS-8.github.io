---
layout:      page
title:       TechRef - Appendix - The ProDOS Machine Language Exerciser (MLE)
description: ProDOS 8 Technical Reference Manual The ProDOS Machine Language Exerciser
permalink:   /docs/techref/the-prodos-machine-language-exerciser/
---

<A NAME="D"><H1>Appendix D<br />The ProDOS Machine Language Exerciser</H1></A><a name="page179"></a>

<P>The ProDOS Exerciser program is a menu-driven program that allows<br />
you to practice calls to the ProDOS Machine Language Interface<br />
without writing a system program.  It is useful for learning how the<br />
various ProDOS MLI calls work.  Using it, you can test the behavior of<br />
a ProDOS-based program before writing any code.</P><A NAME="D.1"><H2>D.1 - How to Use It</H2></A><P>To start up the Exerciser program from BASIC, type</P><P>-/EXERCISER/EXER.SYSTEM</P><P>and press [RETURN].</P><P>This causes the Exerciser (which is a machine-language program, but<br />
not a system program) to be loaded at $2000, and then relocated to the<br />
highest available spot in memory.  On a 64K system, it occupies<br />
memory from $7400 on.</P><P>The Exerciser main menu displays all the MLI calls and their call<br />
numbers, as well as a few other commands.  To select an MLI call,<br />
simply type the call number followed by [RETURN].  To select one of<br />
the other commands, type the displayed letter followed by [RETURN].</P><P>When you select either a call or a command, a list of parameters for<br />
that call is displayed.  The parameters for each MLI call are displayed<br />
almost exactly as they would have to be coded in a ProDOS-based<br />
application.  The only difference is that a true parameter list would<br />
contain a two-byte pointer to a pathname, whereas the Exerciser<br />
displays the pathname itself.  The meanings of the parameters for each<br />
ProDOS call are described in Chapter 4 in the section describing that<br />
call.</P><P>The default values for each of the parameters are displayed.  The<br />
cursor pauses at each of the parameters that requires a value to be<br />
entered.  You may accept the default value by pressing [RETURN] or<br />
change the value by typing the new value followed by [RETURN].  All<br />
values are displayed and entered in hexadecimal.</P><P>When you have entered values for all required parameters, press<br />
[RETURN].  The call is executed, values returned by the call are<br />
displayed, and an error message is displayed.  If error <B><TT>$00</TT></B> is indicated<br />
the call was successful.  If the call was unsuccessful, the Apple II<br />
beeps as it displays the error message.</P><P>Errors are discussed at the end of<br />
Chapter 4.</P><a name="page180"></a>

<A NAME="D.2"><H2>D.2 - Modify Buffer</H2><P>The Modify Buffer command can be used to examine or edit the<br />
Contents of memory.  It asks you for a data buffer address; this is the<br />
address at which you wish to start editing.  You can then page forward<br />
or backward through memory using [&#62;] and [&#60;], respectively.</P><P>Each screen displays the values of 256 consecutive bytes, arranged in<br />
16 rows of eight bytes each.  The ASCII characters associated with<br />
these bytes are displayed at the right of the screen (as printed with<br />
the high bits set).  On a standard Apple II, lowercase ASCII codes are<br />
converted to the corresponding uppercase codes.  Each row is preceded<br />
by the address of the first byte in that row (just like the LIST<br />
command in the Apple II Monitor).</P><P>To move the cursor to a different byte on the screen, use [I], [J],<br />
[K], and [M], or the arrow keys.  To change a byte of memory, simply<br />
type the new value right over the old one.  The value is updated in<br />
memory as well as on the screen.  The Modify Buffer command<br />
remembers the original values of the last 16 bytes you changed.  To<br />
restore up to sixteen changed bytes, press <B><TT>U</TT></B> (for Undo) once for each<br />
value to be restored.</P><P>If a memory page is marked in the system bit map as used by the<br />
system, the editor displays the message <B><TT>MEMORY PAGE<br />
PROTECTED</TT></B> and it does not allow you to change a value in that<br />
page.</P><H3>screen shot from front cover</H3><PRE>
 +-----------------------------------------+
 | * * * * * * * * * * * * * * * * * * * * |
 | *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PRODOS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * |
 | *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MACHINE LANGUAGE INTERFACE&nbsp;&nbsp;&nbsp;&nbsp; * |
 | *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SYSTEM CALL EXERCISER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * |
 | * * * * * * * * * * * * * * * * * * * * |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C0-CREATE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $CB-WRITE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C1-DESTROY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $CC-CLOSE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C2-RENAME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $CD-FLUSH&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C3-SET FILE INFO&nbsp;&nbsp;&nbsp; $CE-SET MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C4-GET FILE INFO&nbsp;&nbsp;&nbsp; $CF-GET MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C5-ON LINE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $D0-SET EOF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C6-SET PREFIX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $D1-GET EOF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C7-GET PREFIX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $D2-SET BUF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C8-OPEN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $D3-GET BUF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | $C9-NEWLINE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $80-READ BLOCK&nbsp;&nbsp;&nbsp;&nbsp; |
 | $CA-READ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $81-WRITE BLOCK&nbsp;&nbsp;&nbsp; |
 | _______________________________________ |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | L - LIST DIRECTORY&nbsp;&nbsp; Q - QUIT&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | M - MODIFY BUFFER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SELECT COMMAND:&nbsp; $C0_&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 +-----------------------------------------+
</PRE><a name="page181"></a>

