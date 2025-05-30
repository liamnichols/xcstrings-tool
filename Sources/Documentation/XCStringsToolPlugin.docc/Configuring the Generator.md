# Configuring the Generator

Create a configuration file to control the behavior of the generator.

## Overview

In most cases, XCStringsTool will generate source code automatically for you without the need for any configuration. In scenarios where you do need to provide further instructions to the generator, you can define a configuration file.

## Create a configuration file

The configuration file must be named **xcstrings-tool-config.yml**, **xcstrings-tool-config.yaml** or **xcstrings-tool-config.json** and must exist in the target source directory.

> For Xcode Project targets, the configuration file must define the Target under it's Target Membership

```text
.
├── Package.swift
└── Sources
    └── MyTarget
        ├── MyCode.swift
        ├── xcstrings-tool-config.yml <-- place the file here
        └── Localizable.xcstrings
```

The configuration file has the following keys:

- `accessLevel` (optional): a string. Customises the visibility of generated code
  - `public`: Generated code is accessible from other modules and other packages (if included in a product).
  - `package`: Generated code is accessible from other modules within the same package or project.
  - `internal`: Generated code is accessible from the containing module only (the default).
- `convertFromSnakeCase` (optional): a boolean. Used to convert string keys containing snake case to camel case in code.
- `importsUseExplicitAccessLevel`: Generated code specifies the appropriate access level on module imports as per [SE-0409](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md).
- `developmentLanguage` (optional): a string. Used to filter input files when working with legacy localizable .strings and .stringsdict files. This value should match the value of the `DEVELOPMENT_LANGUAGE` build setting (in Xcode projects) or the `defaultLocalization` (in Swift Packages)
- `verbose` (optional): a boolean. Used to enable verbose logging when invoking the generator and can help to configuration issues.

### Example config files

##### To generate code that can be accessed from other modules or packages:

**xcstrings-tool-config.yaml**

```yaml
accessLevel: public
```

**xcstrings-tool-config.json**

```json
{
    "accessLevel": "public"
}
```

##### To convert snake case as camel case:

**xcstrings-tool-config.yaml**

```yaml
convertFromSnakeCase: true
```

**xcstrings-tool-config.json**

```json
{
    "convertFromSnakeCase": true
}
```

##### To generate code for legacy .strings files:

**xcstrings-tool-config.yaml**

```yaml
# NOTE: This value should match the defaultLocalization setting defined in the Package.swift
developmentLanguage: en
```

**xcstrings-tool-config.json**

```json
{
    "developmentLanguage": "en"
}
```

##### To enable verbose logging:

**xcstrings-tool-config.yaml**

```yaml
accessLevel: package
verbose: true
```

**xcstrings-tool-config.json**

```json
{
    "accessLevel": "package",
    "verbose": true
}
```
