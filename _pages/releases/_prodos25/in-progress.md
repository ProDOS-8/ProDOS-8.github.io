<div class="vertical-spacer"></div>

## In-Progress Features

* Modify Global Page so it's easier to turn on/off features without changing the machine type.<br />_Features like the large-date support or the lowercase filenames could then easily be disabled to support apps which do not play nice with those features._
* Modify COPY+ and Cat Doctor to support lowercase filenames and the longer-date.<br />_When COPY+ doesn't see a normal ProDOS filename it assumes that the disk is DOS3.3 and tries to use the DOS3.3 parser._


<div class="vertical-spacer"></div>
### Conversion of ProDOS source code to [Merlin32](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)

- Some **initial** R&D work to convert the ProDOS source code from Apple's MPW AsmIIGS cross-assembler syntax into Merlin32 syntax.
- _[Merlin 32 is a multi-pass Cross Assembler running under Windows, Linux and Mac OS X targeting 8 bit processors in the 6502 series (such as 6502 and 65c02) and the 16 bit 65c816 processor.](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)_
- The goal is to _eventually_ have one build environment and assembly syntax for the ProDOS kernel, [Bitsy Bye](/bitsy-bye/), the new loader, and the new drivers.
- _This is a long term goal and may not be included in the ProDOS 2.5 release._

