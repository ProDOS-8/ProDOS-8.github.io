---
layout: page
title: MiniBas
permalink: /minibas/
---


* Written by **Steve Nickolas** _(<a href="https://twitter.com/theusotsuki">@Usotsuki</a>)_
* Great for compilation disks, this tiny program can be used instead of Basic.System.
* This is NOT a BASIC interpreter but a ProDOS wedge for BASIC
* Requires only 1 block on disk vs 21 blocks for Basic.System
* Loads and runs Binary and Basic programs launched by Bitsy Bye.
* Provides two commands:
  * `&"Filename"` runs a Binary or Basic program.
  * `&` by itself will quit back to ProDOS.

* Minibas was created to supply a small launcher for **BAS** and **BIN** programs on top of **Bitsy Bye**.
* Minibas' `BASIC.SYSTEM` can execute BASIC/BIN programs, *and* it quits to the monitor automagically when started.
* Minibas **is not** a full-fledged `BASIC.SYSTEM`, but it works enough for ProDOS 2.4.1+.
* Minibas automatically exits to the menu system, and the menu system chains it when it needs to
load a non-SYS program.
