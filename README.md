# ECE109 - Summer 2021

PennSim is a Java-based LC-3 Simulator developed at the University of Pennsylvania. We will use this simulator to assemble and run our LC-3 programs. This repository will be used to provide example code for ECE109 Summer 2021. It also contains a copy of the official documentation from University of Pennsylvania.  

## Documentation Overview

The guide provides a quick reference while the PennSim Manual provides a more thorough discussion of the simulator. Start with the guide and follow the steps to install Java and the simulator.  

PennSim Guide - https://www.cis.upenn.edu/~milom/cse240-Fall06/pennsim/pennsim-guide.html  
PennSim Manual - https://www.cis.upenn.edu/~milom/cse240-Fall06/pennsim/pennsim-manual.html  

**Documentation Clones:**  
PennSim Guide - https://mjdargen.github.io/ece109_sum21/guide.html  
PennSim Manual - https://mjdargen.github.io/ece109_sum21/manual.html  
PennSim Release - https://mjdargen.github.io/ece109_sum21/dist.html

## Repository Overview
```
|-- docs                 -   Directory for PennSim LC3 Simulator documentation
|   |-- code             -   Directory with code in docs
|       |-- lc3os.asm    -   LC-3 OS code
|       |-- p0.asm       -   Problem 0 code
|   |-- dist.html        -   PennSim Releases Page
|   |-- guide.html       -   PennSim Quick Guide
|   |-- manual.html      -   PennSim Manual
|   |-- pennsim.png      -   PennSim Screenshot
|-- exp                  -   Directory with example code from class
|-- p0                   -   Directory for Program 0
|-- p1                   -   Directory for Program 1
|-- p2                   -   Directory for Program 2
|-- p3                   -   Directory for Program 3
|-- cleanup.py           -   Python script to remove all .sym & .obj files
|-- lc3os.asm            -   LC-3 OS - handles i/o and runs your program
|-- lc3os.obj            -   LC-3 OS object file
|-- lc3os.sym            -   LC-3 OS symbol file
|-- lc3os_v2.asm         -   LC-3 OS v2 - corrected OS, (implements protected memory)
|-- lc3os_v2.obj         -   LC-3 OS v2 object file
|-- lc3os_v2.sym         -   LC-3 OS v2 symbol file
|-- PennSim.jar          -   LC-3 Simulator, Java executable
|-- README.md            -   Repo Overview
```

## Code Editors
While we will use PennSim to execute our code, you will need an editor to write the code. There are many, many different options for a text editor for developing code. Far be it from me to recommend a code editor only for you to blame your ECE109 professor later on when you find an editor more suitable for your purposes. Each editor has its pros and cons; it is really based on personal preference and how you will use it. Below I have listed some free-and-open-source, cross-platform options:  
* Notepad++ - https://notepad-plus-plus.org/ - A very lightweight code editor. Use this if you want to get up and running quickly and don't care about future proofing and packages that will allow you to add all sorts of other features for future classes and development efforts.
* Atom - https://atom.io/ - A not as lightweight code editor; however, it has numerous packages that you can install to assist you with all sorts of development. I use Atom and have packages that allow me to run/debug Python code, compile/run/debug C/C++ code, develop/preview full websites, and more.
* VScode - https://code.visualstudio.com/ - A not as lightweight code editor. Includes a lot of features. I have not really used it; however, I do know a lot of people are moving to using it more and more.
* Note: there are other great options like Sublime Text; however, they come with a price tag but some users prefer them!  

## Miscellaneous  
* Git & GitHub learning resources: https://docs.github.com/en/github/getting-started-with-github/quickstart/git-and-github-learning-resources
* Atom LC-3 Language Package - https://github.com/CalebAlbers/language-lc3
* Sublime Text LC-3 Syntax Package - https://github.com/stevenhan2/Sublime-LC3
