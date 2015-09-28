# Split View Shortcut

This is a hacky but effective solution to the lack of a keyboard shortcut to trigger OS X's new *Split View* action.

## What do you mean hacky?

The utility finds the zoom button using Accessibility, and then creates a click-and-hold mouse event to start Split View. If there's a better way to do this let me know, I'll keep a list here of things I looked for:

* A method on `NSWindow` to toggle Split View like [`toggleFullScreen`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSWindow_Class/#//apple_ref/occ/instm/NSWindow/toggleFullScreen:).

* An accessibility object action for starting Split View found using [`AXUIElementCopyActionNames`](https://developer.apple.com/library/mac/documentation/ApplicationServices/Reference/AXUIElement_header_reference/index.html#//apple_ref/c/func/AXUIElementPerformAction) on the window's zoom button.

* A way to trigger click-and-hold mouse event other than `sleep` and `CGEventCreateMouseEvent`s

## Why not Spectacle or other window management apps?

[Spectacle](https://github.com/eczarny/spectacle/issues/282) and other apps cannot achieve true fullscreen because the Dock reserves pixels along the edge. They're still a lot more customizable and worth checking out if you haven't though.

## Disclaimer

Use this at your own risk and please submit bugs, features, or pull requests. This is my first Swift project, my first Accessibility scripting project, and also even my first native Desktop application in a long time. There are things like Sparkle and Homebrew I might look into later if necessary.
