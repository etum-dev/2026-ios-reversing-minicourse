# Patching a binary
## String patching
Try your hands at the small chall in exercises/Patchouli.ipa. If stuck, you can return here.
The challenge was tested with Cutter/r2 on a mac, but you should be able to use Ghidra or ida pro with a patching plugin (untested, be my guest <3)
Codesigning on linux could possibly be done with xtool. 

Hint: Unless you're up for an extra challenge, don't patch to a string longer than the one present.

### Solution:
In cutter, go to Strings, and search for the string to patch.
- Select it and go to hex view.
- Right click, Edit the string: But be wary of lengths! 
- Shorter string = Pad with 00.

- Longer string: 
To use a longer string, we need to point this new long string to an address space that has a bunch of nullbytes.
https://alon-alush.github.io/injection/codecaves/

One tool that might help:
https://github.com/zeropio/Steve/blob/main/src/main.py
