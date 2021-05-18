# Hola!
This repo is a demo which shows the use of Llama Swift
with Terminal.Gui.

Llama is my exploratory project to compile "other languages"
for .NET using LLVM.  See my blog for more info:

    https://ericsink.com/tocs/llama.html

Terminal.Gui (aka "gui.cs") is a "Console-based user interface toolkit for .NET applications.".  
See its repo and nuget page for more info:

    https://github.com/migueldeicaza/gui.cs
    https://www.nuget.org/packages/Terminal.Gui

## Temporary cross-platform problem

All my development thus far has been on Windows.  In
principle, everything here should be cross-platform,
but I haven't tried it on Mac (or Linux) yet, so it
probably doesn't work there.  I plan to fix this soon.

## Try it

You should be able to just `cd` into the `termgui` directory
and type `dotnet run`.  The necessary nuget packages for
this demo are in the `nupkgs` directory, which is configured
using a nuget config file.

You should get something like this:

![Screenshot](/screenshot.png?raw=true "Screenshot")

Comments in the code (`Program.swift`) explain various
pending issues.

