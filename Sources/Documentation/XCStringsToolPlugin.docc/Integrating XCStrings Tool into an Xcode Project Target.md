# Integrating XCStrings Tool into an Xcode Project Target

Integrate generated Swift constants for your localized strings in an Xcode Project Target.

## Overview

The XCStrings Tool plugin integrates directly into Xcode providing a seamless integration into any of your project targets that contain Strings Catalog files.

If you haven't already, open up an Xcode project which contains the Strings Catalog files that you wish generate source code constants for.

### Adding the Package Dependency

Before integrating with any targets, you need to add the XCStrings Tool package dependency to your project.

In Xcode, click **File** → **Add Package Dependencies…** and in the search box, type **github.com/liamnichols/xcstrings-tool-plugin**

![A screenshot of the Xcode "Add Package" window after searching for the xcstrings-tool-plugin dependency](Xcode-AddPackage)

> When using the Package Plugin, it's recommended to use the [**xcstrings-tool-plugin**](https://github.com/liamnichols/xcstrings-tool-plugin) dependency instead of [**xcstrings-tool**](https://github.com/liamnichols/xcstrings-tool) to benefit from the precompiled binary executable.

Select the **xcstrings-tool-plugin** package from the list of results, ensure that **Add to Project** is correctly set to your project and click **Add Package**.

Click **Add Package** again and the dependency will be imported into your project.

### Adding the Build Tool plugin

The Build Tool plugin is the main component of XCStrings Tool. Once integrated within a target, it'll tell the build system to invoke the generator whenever the Strings Catalogs in the target are modified. The generator then writes the Swift code to your derived sources which are then available for you to use within your other source files.

To integrate the plugin, navigate to your project settings, click on your desired target and navigate to the **Build Phases** tab.

Expand the **Run Build Tool Plug-ins** group and click the **+** button. In the list under xcstrings-tool-plugin, select **XCStringsToolPlugin** and then click the **Add** button:

![A screenshot of the Build Phases screen after adding the XCStringsToolPlugin](Xcode-AddedBuildToolPlugin)

### Review your Strings Catalog

Before building the product, let's just review our Strings Catalog quickly:

![A screenshot of the Strings Catalog specifically highlighting that the phrases are set to manual](Xcode-StringsCatalog)

When working XCStrings Tool, it's recommended that each string has it's **Key** set to a lowerCamelCase identifier so that it matches the generated Swift code.

Additionally, you need to make sure that your strings have their **Managed** setting set to **Manually**. This will be the case already if you added the string with the **+** button, but if the compiler pre-populated the contents of the catalog, you might need to change this value.

### Build your Project

The first time that you build your project, you'll be presented with the following alert:

![A screenshot of the alert shown that asks you to trust the plugin before using it](Xcode-TrustPlugin)

Review the plugin and once you are ready, press **Trust & Enable All**. Your project should now build.

After building, in the left sidebar, open **Report navigator**, select the last build and review the build log for your target. You should spot a message similar to **Run custom shell script 'XCStringsTool: Generate Swift code for ‘Localizable.xcstrings‘'**:

![A screenshot of the build tool plugin output in the Xcode report navigator](Xcode-BuildLog)

If you wish, you can open the file printed in the log output to review the generated code:

![A screenshot of the generated Localizable.swift file](Xcode-Generated)

This code is compiled as part of your target, so is accessible just like code you would write yourself:

![A screenshot of the new constants being used in a SwiftUI view](Xcode-Usage)

## See Also

- <doc:Configuring-the-generator>
