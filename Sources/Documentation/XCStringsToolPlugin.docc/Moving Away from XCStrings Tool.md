# Moving Away from XCStrings Tool

Tips on how to move your project away from XCStrings Tool if it's not working out.

## Overview

If XCStrings Tool isn't for you, or you can no longer rely on the tool for whatever reason, it can be useful to know how you can stop depending on the build tool plugin without having to rewrite all of the existing constants. 

### Finding the generated source code

Whenever you run a clean build for a target that implements the Build Tool Plugin, it will generate a Swift source file based on each Strings Catalog that contains the constants that you access in your own code.

This source file is written to a special folder in your Derived Data directory so it's not immediately obvious where you can find this. 

To find the source code, open **Report navigator**, select the last build and review the build log for your target. You should spot a message similar to **Run custom shell script 'XCStringsTool: Generate Swift code for ‘Localizable.xcstrings‘'**:

![A screenshot of the build tool plugin output in the Xcode report navigator](Xcode-BuildLog)

You can then open the file at the path printed in the plugin output:

![A screenshot of the generated Localizable.swift file](Xcode-Generated)

### Moving the generated source code

If you no longer wish to use the Build Tool Plugin, you can go ahead and copy the generated source code into your own target manually. 

> Note: While you can place this source code into any target, the localized strings lookup will only work if the target contains the resource bundle that contains the Strings Catalog with your localized strings. 

Now that the source code is managed manually within your control, you can remove the Build Tool Plugin from your targets Build Phases (for Xcode Project targets) or the Package.swift definition (for Swift Package targets).

Be aware that you may need to clean the build folder (<kbd>⇧</kbd> + <kbd>⌘</kbd> + <kbd>K</kbd>) before you rebuild your project for the first time.

From here, you can either manually maintain the generated constants, or you can gradually refactor your code to move away from being dependant on them.
