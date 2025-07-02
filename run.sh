#!/bin/bash

# Check if a filename is provided
if [ -z "$1" ]; then
  echo "Usage: ./runasm.sh <filename>"
  exit 1
fi

# Assemble the .asm file
nasm -f elf "$1.asm" -o "$1.o"
if [ $? -ne 0 ]; then
  echo "Assembly failed."
  exit 1
fi

# Link the object file
ld -m elf_i386 -s -o "$1" "$1.o"
if [ $? -ne 0 ]; then
  echo "Linking failed."
  exit 1
fi

# Run the executable
./"$1"
