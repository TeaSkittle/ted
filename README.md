# ted
A line based text editor written for POSIX shells, using as few core utilities as possible.

## Why?
I have always wanted to write my own text editor, but after trying to learn curses and GNU Readline,  
I decided to write something more similar to ed (the standard editor). It just so happened that  
around the time I began poking around various text editors, I also started learning to pure SH  
scripts. This is by no means meant to be a text editor to replace any other out there, it was a simple  
learning excersize for myself. It is useful for making quick edits though, but I would not recommend  
doing any heavy editing with it.

### Dependencies
* POSIX shell
* sed

### How to run
* Basic command is `./ted.sh`
* Useful to set as shell alias: `alias ted="./ted.sh"`

### Notes
* Worth mentioning that this has been written and tested on OpenBSD
* Uses ANSI escape codes for color, may cause problems with certain terminal emulators.
* Tested with XTerm
* This README.md file was written with ted!
* To view large files use: `./ted.sh -o file-name | less -r`

### Screenshot
![scrot](scrot.png)
