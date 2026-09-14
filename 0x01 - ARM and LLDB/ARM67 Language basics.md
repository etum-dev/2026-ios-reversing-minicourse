before i get :nerd: erm akshually'd :nerd: , when i write ARM i mean ARM64/AArch64, not ARM32

In case you don't know assembly *at all*, this is a good (and hopefully not secretly AIgen) introduction to it:
https://youtu.be/PxiMLtsuGO0

## Basic syntax
Let's learn just enough syntax to be comfortable with seeing the lldb output later. You'll likely not have to memorize it or write it in detail, or do, its pretty cozy, but some parts should be essential to understand:

The basic syntax is:
`<OPERATION> <LOCATION> <VALUE>` 
There may be additional parameters depending on operation, like some mathematical operations etc.

### Security levels
ARM follows a permission model where highest level (EL3) is the highest privilege.
EL0 = Userspace
EL1 = OS Kernel
EL2 = Hypervisor
EL3 = Secure Monitor

### Registers

If you don't know what a register is, you can kind of see it as a little space of memory for the CPU process to keep track of values.

ARM has 31 general purpose registers (from x0 to x30), and about 13k instructions.

iOS interestingly has a few hidden instructions too, such as APRR and KTRR. yay, Easter eggs!


And these are typically operated on: 
- x0-x7 - General purpose
- x8 - Results
- x9-x15 - temp/scratch
- x16-x17
- x18 - Reserved, i want to know what happens when i write to this lol.
This is a "forbidden" register according to Apples ARM docs.



## Addresses
Knowing how and where to access addresses is useful, especially when doing PWNs. 

Some addressess we typically want to know is the entry address, and addressess of functions in memory.

## Minimal ARM program example
The following is a very barebones ARM. I wrote it on my x64 PC and compiled with aarch64-gnu tools. To run it, you can use eg qemu.
```
.global panda

panda:
	mov x0, #67
	mov x8, #93
	svc #0 
```
The first line, .global defines an entry symbol for the GNU assembler, so its not really ARM. You technically dont need it here, but you get warnings otherwise.
In this example I dont (think) a linker is necessary, but since its typically used to make an executable file as it connects libraries. [^1]

We then specify the symbol name. Can be anything, the cuter animal the better.
We then use the MOV operation to put 67 in the x0 register. Note the `#` (number sign, not hashtag, you zoomer) before the number. This is to avoid the assembler interpreting it in the wrong way. (The number sign is actually optional as of ARMv8 though, but i think it makes things clearer to use it)

Then, we MOV over to the result value. X8 is a register used for Indirect results, as specified in [The arm docs on page 11](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20Instruction%20Set%20Architecture.pdf?revision=ebf53406-04fd-4c67-a485-1b329febfb3e).
Why put 93 here? This is the arm64 syscall for exit. So we're saying that once returning/ending this function, call "exit".
There are many syscalls, this is one such list: https://arm64.syscall.sh/

Finally, we use "SVC", which is "Supervisor call". This performs a system call. We supply the value we just put in x0, that is 67. :six: :woman_shrugging: :seven:
The return code is now 67!

1. After having the ARM code ready, we can compile and run it in 3 steps:
ARM code typically have the .s extension.
`aarch64-linux-gnu-as smol.s -o smolASS.o`

2. Link it:
`aarch64-linux-gnu-ld smolASS.o -e panda -o smoll #Without -e, again you get an error as if you didnt use the .global`

3. To then run the final binary:
`qemu-aarch64 ./smoll`
`echo $? #returns 67`

## Identifying common functions in ARM
Here are just some common calls in ARM and its code equivalent. idk maybe its helpful to quickly identify typical functions when reversing actual apps later.


The following example is a side-by-side of some Swift code and it's disassembled equivalent. The first is the disassembled program, the former is the code. Toggled to partially test yourself, partially to save space. 
<details>
<summary>Hopper disassembly 1</summary>
DATA section:

### aILikeCats:
```
db    "i like cats!", 0
aN:
db    "\n", 0
asc:
db    " ", 0
db    0x00
db    0x00
```
```
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

```
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
```
push {r4-r7, lr} // save LR, R7, R4-R6 
add r7, sp, #12 // adjust R7 to point to saved R7 
push {r8, r10, r11} // save remaining GPRs (R8, R10, R11) 
vstmdb sp!, {d8-d15} // save VFP/Advanced SIMD registers
D8 sub sp, sp, #36 // allocate space for local storage
```


## Tips
No arm device? try https://www.unicorn-engine.org/. Sample usage: https://gist.github.com/strazzere/c0798205b0aa9bb50c1237a660a61282

You can also specify and send ARM asm bytes with PWNtools, despite not having ARM architecture. Sample:
```
#!/usr/bin/env python3
from pwn import *
context.arch = 'aarch64'

# X1 = 0x1337
# Set register value
asm_bytes = asm("""
  mov x1, #0x1337
  """)

```

## Some exercises (opt)
### Writing own ARM program
1. See section on "minimal arm program" and use references from eg official ARM docs to write your own helloworld in Arm.
   

## Additional reading
I can also recommend https://pwn.college/xnu/intro-to-arm/. It was really fun :)

List of syscalls:
https://arm64.syscall.sh/

Use register x18 and see hwat happens idk https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms


https://github.com/firmianay/Life-long-Learner/blob/master/practical-reverse-engineering/RE_Learning_ARM.md

Arm has had their fair share of identity crisis:
https://stackoverflow.com/questions/28669905/what-is-the-difference-between-the-arm-thumb-and-thumb-2-instruction-encodings

ARM64 ASM only software for android:
https://github.com/VegaASM/VAIS

Some ARM syntax sanity checks: https://www.davespace.co.uk/arm/introduction-to-arm/immediates.html

List of all teh instructions: https://support.arm.com/documentation/ddi0596/2021-03/Base-Instructions?lang=en

________
[^1]: https://passlab.github.io/ITSC3181/notes/lecture02_CompilationAssemblingLinkingProgramExecution.pdf
