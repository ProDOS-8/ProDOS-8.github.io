---
layout: page
title: Bitsy Bye
permalink: /bitsy-bye/
---

## _aka: **QUIT.SYSTEM**_


<p><img src="/pix/prodos24/ProDOS-2.4-Bitsy-Bye.png"></p>

* A new program launcher with many features.
* Runs on all Apple II computers and CPUs: _6502, 65c02 or 65816._
* Allows drives to be selected directly by slot using number keys 1-7.
* Allows files to be selected by typing the first letter of their filename.
* Displays and quickly scrolls through up to 2,733 files per directory.
* Displays and allows selection of all files on a drive, not just System files and directories like previous launchers.
* Displays file types and allows launching Applesoft Basic, Binary, Text exec, and GS/OS S16 files via Basic.System.
* Displays the slot and drive of each device.
* Does not abort on drive errors, but instead lists and allows launching of all readable files.
* The code and data size for Bitsy Bye is less than 1KB, with room to spare (thanks qkumba).
* **Bitsy Bye** is only `$300` bytes long yet _**hides an Easter egg**_.<br />Look for it in `QUIT.SYSTEM` on the **ProDOS 2.4**, _and later,_ disks.


<a name="how-the-system-launches-bitsy-bye-on-boot" />

## How the system launches Bitsy Bye _(QUIT.SYSTEM)_ on boot

* ProDOS will **always** launch the first program with a suffix of `.SYSTEM` and a file type of `SYS`
* The order is determined by the placement in the disk catalog, not by the spelling.
* To launch **QUIT.SYSTEM** when ProDOS starts up, it must be the first `.SYSTEM` file in the catalog.

<!-- `$ff!` -->

1. Format a blank ProDOS disk _(also include the boot sector / loader )_
2. Files need to be in this order in the catalog ...
  - 2.1. copy **PRODOS**
  - 2.2. copy **BITSY.BOOT**
  - 2.3. copy **QUIT.SYSTEM**
  - 2.4. copy **BASIC.SYSTEM**

* **BITSY.BOOT** should be the first **SYS** file.

### When Booting:

1. The boot sector searches the volume for and loads **PRODOS**
2. PRODOS searches for the first **SYS** file, which is **BITSY.BOOT**.
3. **BITSY.BOOT** will then launch the next `.SYSTEM` file on the disk.<br />If you want **BASIC.SYSTEM** to be the first **SYS** file in the disk catalog, copy it _before_ QUIT.SYSTEM.<br />To make the system launch **Bitsy Bye** on boot, copy QUIT.SYSTEM **BEFORE** BASIC.SYSTEM.


## The benefit of using **QUIT.SYSTEM** vs. Something like **ProSel**

* It allows you to also have `BASIC.SYSTEM` in the root dir.
* **Bitsy Bye** needs `BASIC.SYSTEM` if you want to use Bitsy to run **BAS**, **BIN**, or **TXT** _(exec)_ files. 


## Can Bitsy-Bye operate in 80-column mode?

* Bitsy-Bye is a super lean piece of assembly code.
* `Line 1` of the code for Bitsy-Bye **enables 40-column mode**,<br />followed by `line 2` which **disables 80-column mode**.

* A feature request for a version of **Bitsy-Bye** with 80-column mode support has been submitted, however there is **no 80-column support** version of **Bitsy-Bye** available at this time.



