# Godot Plugin: Window-B-Gone for 4.x
### Check branches for the AssetLib source
Auto-minimize `AlwaysOnTop` and `ExclusiveFullscreen` windows when crashing or using a breakpoint. Will reopen upon continuing from breakpoint.

This is useful, because those two window modes will lock up for a time, covering and interfering with the Godot editor. They are otherwise annoying to make disapear.

This plugin comes with modes you can edit from the autoload, or the `wbg_autoload.gd` file:
- `STANDARD`, Will always minimize `AlwaysOnTop` or `ExclusiveFullscreen` windows.
- `DETECT_OVERLAP`, Will auto-detect if the game would be on top of the editor, before doing the above.
- `FORCE_MINIMIZE`, Will force a minimize no matter what window flags.

You can also remove `AlwaysOnTop` or `ExclusiveFullscreen` from `STANDARD`'s white list.
