# Auto Nicknamer

#### Gen 3 Ironmon-Tracker Extension by Mixone

This extension allows you to set nicknames to be auto-assigned from a list of them in nicknames.txt

![image](https://raw.githubusercontent.com/Mixone-FinallyHere/AutoNicknamer-IronmonExtension/main/Functionality.gif)

## Requirements:
- [Ironmon-Tracker v7.3.0](https://github.com/besteon/Ironmon-Tracker) or higher

## Install:
1) Download the [latest release](https://github.com/Mixone-FinallyHere/AutoNicknamer-IronmonExtension/releases/latest) of this extension from the GitHub's Releases page
2) Extract the contents of the `.zip` file into a new folder
3) Copy all files & folders from the extracted folder into the "**extensions**" folder found inside your Tracker folder
   - The file(s) should appear as: `[YOUR_TRACKER_FOLDER]/extensions/AutoNicknamerExtension.lua`

## Enable the Extension:
1) On the Tracker settings menu (click the gear icon on the Tracker window), click the "**Extensions**" button
2) In the Extensions menu, enable "**Allow custom code to run**" (if it is currently disabled)
3) Click the "**Refresh**" button at the bottom to check for newly installed extensions
   - If you don't see anything in the extensions list, double-check the extension files are installed in the right location. Refer to the Tracker wiki documentation (at the bottom) if you need additional help
4) Click on the "**Auto Nicknamer**" extension button to view the extension
5) From here, you can turn it on or off, as well as check for updates

## Usage:
- While enabled, this extension automatically nicknames caught Pokemon based on the list of names supplied in `nicknames.txt`.
- It does not currently nickname the starter Pokemon.
- If you manually give the Pokemon a nickname it will keep that instead of giving it a new one.
- **IMPORTANT:** Special characters are NOT supported, please only use english alphabet characters (i.e. no special German, French, Spanish, etc... characters) and numbers!

## Custom Extensions Wiki:
https://github.com/besteon/Ironmon-Tracker/wiki/Tracker-Add-ons#custom-code-extensions