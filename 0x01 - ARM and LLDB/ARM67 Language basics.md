before i get :nerd: erm akshually'd :nerd: , when i write ARM i mean ARM64/AArch64, not ARM32

In case you don't know assembly *at all*, this is a good (and hopefully not secretly AIgen) introduction to it:
https://youtu.be/PxiMLtsuGO0

## Basic syntax
Let's learn just enough syntax to be comfortable with seeing the lldb output later. You'll likely not have to memorize it or write it in detail, or do, its pretty cozy, but some parts should be essential to understand:

### Registers
The most fundamental ones to know about:
SP - Stack pointer
PC - Program Counter, this holds addresses for the next instruction.

x0-x7 - General purpose
x18 - Reserved, i want to know what happens when i write to this lol. This is a "forbidden" register according to Apples ARM docs.



## Addresses
Knowing how and where to access addresses is useful, especially when doing PWNs. 


## Identifying common functions in ARM
Here are just some common calls in ARM and its code equivalent. idk maybe its helpful to quickly identify typical functions when reversing actual apps later.


The following example is a side-by-side of some Swift code and it's disassembled equivalent. The first is the disassembled program, the former is the code. Toggled to partially test yourself, partially to save space. 
<details>
<summary>Hopper disassembly 1</summary>
DATA section:

### aILikeCats:
db    "i like cats!", 0
aN:
db    "\n", 0
asc:
db    " ", 0
db    0x00
db    0x00

### Core arm:
sub    sp, sp, #0x40
stp    fp, lr, [sp, #0x30]
add    fp, sp, #0x30
mov    w8, #0x1
mov    x0, x8
adrp   x8, #0x100004000
ldr    x8, [x8, #0x28]
add    x1, x8, #0x8
str    x1, [sp, #0x30 + var_28]
bl     imp_stubs$ss27_allocateUninitializedArrayySayxG_BptBwlF
str    x0, [sp, #0x30 + var_30]
adrp   x0, #0x100000000
add    x0, x0, #0x994
mov    w8, #0xc
mov    x1, x8
mov    w8, #0x1
and    w2, w8, #0x1
bl    imp\_stubssSS21\_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
mov    x9, x0
ldr    x0, [sp, #0x30 + var_30]
mov    x8, x1
ldr    x1, [sp, #0x30 + var_28]
adrp   x10, #0x100004000
ldr    x10, [x10, #0x8]
str    x10, [x0, #0x38]
str    x9, [x0, #0x20]
str    x8, [x0, #0x28]


</details>
BTW a stub is basically something that acts as a placeholder. i personally identify with them 

<details>
<summary>Source 1</summary>

```swift
import Foundation

func printMessage(){
	print("I like cats!")
}
```



</details>

Another thing to keep track of are function prologues and epilogues. Those are executed as the name suggests, between functions.
push {r4-r7, lr} // save LR, R7, R4-R6 
add r7, sp, #12 // adjust R7 to point to saved R7 
push {r8, r10, r11} // save remaining GPRs (R8, R10, R11) 
vstmdb sp!, {d8-d15} // save VFP/Advanced SIMD registers
D8 sub sp, sp, #36 // allocate space for local storage

## Some exercises
No arm device? try https://www.unicorn-engine.org/

I can also recommend https://pwn.college/xnu/intro-to-arm/. It was really fun :)

Use register x18 and see hwat happens idk https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms