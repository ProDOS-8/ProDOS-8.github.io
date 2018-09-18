---
layout:      page
title:       TechRef - Appendix - The ProDOS Machine Language Exerciser (MLE)
description: ProDOS 8 Technical Reference Manual The ProDOS Machine Language Exerciser
permalink:   /docs/techref/the-prodos-machine-language-exerciser/
---

<A NAME="D"></A>

<a name="page179"></a>

<P>The ProDOS Exerciser program is a menu-driven program that allows you to practice calls to the ProDOS Machine Language Interface without writing a system program.  It is useful for learning how the various ProDOS MLI calls work.  Using it, you can test the behavior of a ProDOS-based program before writing any code.</P>

<A NAME="D.1"></A>

<H2>D.1 - How to Use It</H2>


<P>To start up the Exerciser program from BASIC, type</P>

<P>-/EXERCISER/EXER.SYSTEM</P>

<P>and press [RETURN].</P>

<P>This causes the Exerciser (which is a machine-language program, but not a system program) to be loaded at $2000, and then relocated to the highest available spot in memory.  On a 64K system, it occupies memory from $7400 on.</P>

<P>The Exerciser main menu displays all the MLI calls and their call numbers, as well as a few other commands.  To select an MLI call, simply type the call number followed by [RETURN].  To select one of the other commands, type the displayed letter followed by [RETURN].</P>

<P>When you select either a call or a command, a list of parameters for that call is displayed.  The parameters for each MLI call are displayed almost exactly as they would have to be coded in a ProDOS-based application.  The only difference is that a true parameter list would contain a two-byte pointer to a pathname, whereas the Exerciser displays the pathname itself.  The meanings of the parameters for each ProDOS call are described in Chapter 4 in the section describing that call.</P>

<P>The default values for each of the parameters are displayed.  The cursor pauses at each of the parameters that requires a value to be entered.  You may accept the default value by pressing [RETURN] or change the value by typing the new value followed by [RETURN].  All values are displayed and entered in hexadecimal.</P>

<P>When you have entered values for all required parameters, press [RETURN].  The call is executed, values returned by the call are displayed, and an error message is displayed.  If error <B><TT>$00</TT></B> is indicated the call was successful.  If the call was unsuccessful, the Apple II beeps as it displays the error message.</P>

<P>Errors are discussed at the end of Chapter 4.</P>

<a name="page180"></a>

<A NAME="D.2"></A>

<H2>D.2 - Modify Buffer</H2>

<P>The Modify Buffer command can be used to examine or edit the Contents of memory.  It asks you for a data buffer address; this is the address at which you wish to start editing.  You can then page forward or backward through memory using [&#62;] and [&#60;], respectively.</P>

<P>Each screen displays the values of 256 consecutive bytes, arranged in 16 rows of eight bytes each.  The ASCII characters associated with these bytes are displayed at the right of the screen (as printed with the high bits set).  On a standard Apple II, lowercase ASCII codes are converted to the corresponding uppercase codes.  Each row is preceded by the address of the first byte in that row (just like the LIST command in the Apple II Monitor).</P>

<P>To move the cursor to a different byte on the screen, use [I], [J], [K], and [M], or the arrow keys.  To change a byte of memory, simply type the new value right over the old one.  The value is updated in memory as well as on the screen.  The Modify Buffer command remembers the original values of the last 16 bytes you changed.  To restore up to sixteen changed bytes, press <B><TT>U</TT></B> (for Undo) once for each value to be restored.</P>

<P>If a memory page is marked in the system bit map as used by the system, the editor displays the message <B><TT>MEMORY PAGE PROTECTED</TT></B> and it does not allow you to change a value in that page.</P>

<H3>screen shot from front cover</H3>


<PRE>
 +-----------------------------------------+
 | * * * * * * * * * * * * * * * * * * * * |
 | *               PRODOS                * |
 | *      MACHINE LANGUAGE INTERFACE     * |
 | *        SYSTEM CALL EXERCISER        * |
 | * * * * * * * * * * * * * * * * * * * * |
 |                                         |
 | $C0-CREATE           $CB-WRITE          |
 | $C1-DESTROY          $CC-CLOSE          |
 | $C2-RENAME           $CD-FLUSH          |
 | $C3-SET FILE INFO    $CE-SET MARK       |
 | $C4-GET FILE INFO    $CF-GET MARK       |
 | $C5-ON LINE          $D0-SET EOF        |
 | $C6-SET PREFIX       $D1-GET EOF        |
 | $C7-GET PREFIX       $D2-SET BUF        |
 | $C8-OPEN             $D3-GET BUF        |
 | $C9-NEWLINE          $80-READ BLOCK     |
 | $CA-READ             $81-WRITE BLOCK    |
 | _______________________________________ |
 |                                         |
 | L - LIST DIRECTORY   Q - QUIT           |
 | M - MODIFY BUFFER                       |
 |                                         |
 |          SELECT COMMAND:  $C0_          |
 +-----------------------------------------+
</PRE>

<a name="page181"></a>

