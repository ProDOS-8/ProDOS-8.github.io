---
layout:      'page'
title:       'GS/OS Technical Note #8'
description: 'GS/OS #8 - Filenames With More Than CAPS and Numerals'
permalink:   '/docs/technote/gsos/08/'
---

<h3>Written by Matt Deatherage (July 1989)</h3>

<p>This Technical Note discusses the problems some applications may have when dealing with filenames containing lowercase letters for the first time.</p>

<hr />

<p>With System Software 5.0, lowercase filenames enter GS/OS en masse for the first time. Lowercase filenames are inherent to the AppleShare filing system and have been added to the ProDOS filing system through the ProDOS FST. However, since Apple II filing systems never had lowercase characters in filenames before, this change undoubtedly causes problems for some applications. This Note gives general guidelines to help developers avoid such problems.</p>

<h2>How the ProDOS FST Does It</h2>

<p>"Wait," you say (not for any particular reason, other than a general fondness for monosyllables). "If you put lowercase characters in the ProDOS directory entry, it's going to cause all kinds of problems. What's gonna' happen on ][+ machines?"</p>

<p>Two previously unused bytes in each file's directory entry are now used to indicate the case of a filename. The bytes are at relative locations +$1C and +$1D in each directory entry, and were previously labeled version and min_version. Since ProDOS 8 never actually used these bytes for version checking (except in one case, discussed below), they are now used to store lowercase information. (In the Volume header, bytes +$1A and +$1B are used instead.)</p>

<p>If version is read as a word value, bit 7 of min_version would be the highest bit (bit 15) of the word. If that bit is set, the remaining 15 bits of the word are interpreted as flags that indicate whether the corresponding character in the filename is uppercase or lowercase, with set indicating lowercase. For example, the filename Desk.Accs has a value in this word of $B9C0, or binary 1011 1001 1100 0000. The following illustration shows the relationship between the bits and the filename:</p>

<pre>

        Bits in WORD:                  1011100111000000
        Filename:                       Desk.Accs
        Uppercase or Lowercase:         ULLLUULLL

</pre>

<p>Note that the period (.) is considered an uppercase character.</p>

<h2>What it Means</h2>

<p>Because no lowercase ASCII characters are actually stored in the filename fields of the directory entries, all ProDOS 8 software should continue to work correctly with disks containing files with lowercase characters in the filenames. Neither ProDOS 8 nor the ProDOS FST are case sensitive when searching for filenames: ProDOS is the same file as PRODOS is the same file as prodos.</p>

<p>The main trouble applications have is when a filename has been "processed" by the application before passing it to GS/OS. For example, if a command shell automatically converts filenames to all uppercase characters before passing them to ProDOS 16, the chosen uppercase and lowercase combination for the filename will never be seen by the user without any apparent reason. Some developers have considered it okay to ignore lowercase considerations, thinking that they would only apply to file systems other than ProDOS (and file systems which would not be available on the Apple II for a long time, if ever). These developers were mistaken.</p>

<p>A more pressing problem is that of an application that is looking for a specific file, perhaps a data file or a configuration file. If the application simply passes a pathname to GS/OS and asks for that file to be opened, it will be opened if it exists. The case of the filename is irrelevant since file systems are not case sensitive. However, if the application makes GetDirEntry calls on a specific directory, looking for the filename in question, there could be trouble: the application won't find the file unless its string comparison routine is not case sensitive. If the user has renamed the file MyApp.Config, and the string comparison is looking for MYAPP.CONFIG, then the application will report that the file does not exist.</p>

<p>It is repeated here that when dealing with normal OS considerations, it's almost always better to ask for something and respond intelligently if it's not there than it is to go looking for it yourself. The OS already has a lot of code to look for things (or expand pathnames, or examine access privileges, etc.), and reinventing the wheel is not only tedious, it can be detrimental to future compatibility.</p>

<h2>The One Exception</h2>

<p>In the past, ProDOS 8 did look at the version bytes when opening a subdirectory. The code to do this has been removed from ProDOS 8 V1.8. Please be aware that earlier versions of ProDOS 8 will be unable to scan subdirectories with lowercase characters in the directory name, even to find files in those directories.</p>

<h2>Conclusion</h2>

<p>Most user-input routines (including the Standard File tool set) return filenames or pathnames that can be passed directly to GS/OS without preprocessing. Doing so may return "pathname syntax errors" more often than not doing so, but it also enables applications to take advantage of future versions of the System Software that loosen the restrictions on syntax (or new file systems that never had such restrictions). Under GS/OS, even ProDOS disks aren't what they used to be.</p>


<h2>Further Reference</h2>

<ul>
<li>GS/OS Reference</li>
</ul>

<hr />

{% include technote_credit.html %}
