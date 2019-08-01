---
layout: page
title: Bitsy Boot
permalink: /bitsy-boot/
---


<p><img src="/pix/prodos24/ProDOS-2.4-Bitsy-Boot.png"></p>

* Bitsy Boot is a small system program which allows quick and easy booting of Apple II devices in various slots.

* Displays all slots which contain active ProDOS devices.
* Allows one-press booting of slots 1-7.
* The most recently-used ProDOS device can be booted using Return or Space.
* If GS/OS was previously booted and is dormant, {% OpenAppleButton %}{% QAppleButton %} _(Open-Apple-Q)_ or {% OpenAppleButton %}{% EscAppleButton %} _(Open-Apple-Escape)_ will quit back to GS/OS.
* Bitsy Boot takes only 1 block on disk. Code and data are under 400 bytes.



<a name="using-prosel-with-bitsy-boot" />

## Using ProSel with Bitsy Boot

* ProDOS will **always** launch the first program with a suffix of `.SYSTEM` and a file type of `SYS`

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
3. **BITSY.BOOT** will then launch the next `.SYSTEM` file on the disk.<br />If you want **BASIC.SYSTEM** to be the first **SYS** file in the disk catalog, copy it _before_ QUIT.SYSTEM.<br />To make the system launch **ProSel** on boot, copy it **BEFORE** QUIT.SYSTEM or BASIC.SYSTEM.







