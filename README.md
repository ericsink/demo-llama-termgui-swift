# Hola!
This repo is a demo which shows the use of Llama Swift
with Terminal.Gui.

Llama is my exploratory project to compile "other languages"
for .NET using LLVM.  It is at the "proof of concept"
stage.  See my blog for more info:

https://ericsink.com/tocs/llama.html

Terminal.Gui (aka "gui.cs") is a "Console-based user interface toolkit for .NET applications.".  
See its repo and nuget page for more info:

https://github.com/migueldeicaza/gui.cs

https://www.nuget.org/packages/Terminal.Gui

## Try it

First, let me apologize to folks on a Mac, which means
"almost all Swift developers".  :-(

All my recent development has been on Windows.  In
principle, everything here should be cross-platform.
Llama generally works on Windows, Mac, and Linux.
But I haven't tried Llama Swift on Mac (or Linux) yet, so it
probably doesn't work there.  I plan to fix this soon.

Anyway, if you are on Windows and have Swift 5.4 installed,
you should be able to just:

```
cd termgui
dotnet run
```

The necessary nuget packages for
this demo are in the `nupkgs` directory, which is configured
using a nuget config file.

You should see something like this:

![Screenshot](/screenshot.png?raw=true "Screenshot")

Comments in the code explain various pending issues.

