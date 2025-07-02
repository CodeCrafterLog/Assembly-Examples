# Introduction

## What is Assembly
Assembly is the most low-level programming language in the world. <br>
It has a very low use in daily programming life. But it is strong.

## Assembly vs C
C is built using assembly so there are something that you cannot do the using C but can be achieved with assembly.
1. OS development
2. Device usage (Changing the activiy of GPU, keyboard and etc)
3. Having fun!

# Build and Run
## 1. Using `run.sh` file
You can build and run the `.asm` files using the `run.sh` by just simply using `./run.sh example` <br>
* When using the `run.sh` file, it will first assemble it using NASM and then run it
* Note: Do not use the `.asm` file extension when running the build, it will place it automatically

## 2. Manual build
Use NASM. This files are desinged for NASM so if you want to execute them without needing to modify them, just use NASM with the following command 
`nasm -f elf {file name}.asm`<br>
For example:
`nasm -f elf hello.asm`<br>
Then you have to link it using a simple linker like ld. Just run the following command:
`ld -m elf_i386 -s -o {file name} {file name}.o`<br>
For example:
`ld -m elf_i386 -s -o hello hello.o`<br>
Now that you have the excecutable file, just run it by using:
`./{filename}`<br>
For example: 
`./hello`<br>
Although the `run.sh` file will do all of this automatically.
