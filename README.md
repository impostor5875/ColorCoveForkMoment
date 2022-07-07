<p align="center">
  <img align="center" src="art/sign logo.png">
</p>
<p align="center">
  A simplistic indie game by <a href="https://www.github.com/DillyzThe1">DillyzThe1</a>.
</p>
<p align="center">
  Originally made for a mini-jam hosted by <a href="https://matthew-schlauderaff.itch.io/">Matthew Schlauderaff</a>.
</p>



# ColorCove

[![](https://img.shields.io/github/downloads/DillyzThe1/Colorcove/total.svg)](../../releases) [![](https://img.shields.io/github/v/release/DillyzThe1/ColorCove)](../../releases/latest) [![](https://img.shields.io/github/repo-size/DillyzThe1/ColorCove)](../../archive/refs/heads/main.zip)
A colorful game across the side of a street.
Your goal is to get the boring monochrome outliers to stop trying to make it boring!

## How To Play

For windows builds, go [here](https://github.com/DillyzThe1/ColorCove/releases) & download the zip.
For (semi-mobile-compatible) web builds, go to [this link](https://github.com/DillyzThe1/ColorCove/releases) instead.

You can click/tap any UI element you need, but you also have some standard controls:
* Escape (Exiting a menu/popup)
* Enter (Pausing)
And some unique ones for debug builds:
* 9 (Offset State, accessed from Menu State)
* 1 (Last animation in Offset State)
* 2 (Next animation in Offset State)
* Space (Play animation in Offset State)
* Arrow Keys (Change animation offset in Offset State)

## How To Compile (Windows Only)
<i>NOTE: IF you publish a public modification to this game, you <b>MUST</b> open source it on github & add a link to the source code.</i>

Download Haxe [4.2.4 64-bit](https://haxe.org/download/file/4.2.4/haxe-4.2.4-win64.exe/) or [4.2.4 32-bit](https://haxe.org/download/file/4.2.4/haxe-4.2.4-win.exe/).
Download the [source code of this repository](https://www.github.com/DillyzThe1/ColorCove/archive/refs/heads/main.zip) or the [source code of the latest release](https://www.github.com/DillyzThe1/ColorCove/releases/latest).
Extract the zip file and open the folder.
Run setup.bat and let it automatically install.
<i>* NOTE: Do NOT let it open the example repositories it installs.</i>
Once that finishes, run build.bat and decided if you want to compile a debug or release build.
The game should then compile, letting you re-run build.bat at any time to mod the game.

<i>Note: Visual Studio Code is recommended for programming new features. Please install the appropiate plugins for haxeflixel in VSC.</i>