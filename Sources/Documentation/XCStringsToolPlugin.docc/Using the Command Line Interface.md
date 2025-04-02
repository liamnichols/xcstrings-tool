# Using the Command Line Interface

How to use the `xcstrings-tool` Command Line Interface directly

## Overview

The quickest way to get started with XCStrings Tool is by using the Build Tool Plugin, but if you need more control over the strings generation, you can also use the `xcstrings-tool` command directly.

### Installation

#### Swift Package Manager

```bash
$ git clone https://github.com/liamnichols/xcstrings-tool
$ cd xcstrings-tool
$ swift run xcstrings-tool --help
```

### Mint

[https://github.com/yonaskolb/Mint](https://github.com/yonaskolb/Mint)

```bash
$ mint run liamnichols/xcstrings-tool xcstrings-tool --help
```

### Mise

[https://mise.jdx.dev](https://mise.jdx.dev)

```bash
$ mise use -g spm:liamnichols/xcstrings-tool
$ xcstrings-tool --version
```

### GitHub Release

A file called **xcstrings-tool.artifactbundle.zip** is attached to each [GitHub Release](https://github.com/liamnichols/xcstrings-tool/releases). You can download this file and install the binary within manually.

### Examples

The following examples assume that the `xcstrings-tool` binary exists in your PATH.

#### Check the Version

You might want to check that you have the correct version of xcstrings-tool installed.

```bash
$ xcstrings-tool --version
1.0.0
```

#### Generate

The `generate` command should be run once for each Strings Table that you wish to generate Swift source code for.

##### Strings Catalog

Assuming the following setup:

Strings Catalog: **./Repo/App/Resources/Localizable.xcstrings**  
Source Directory: **./Repo/App/Sources/**

To generate Swift source code for **Localizable.xcstrings**, run the following command:

```bash
$ xcstrings-tool generate \ 
  ./App/Resources/Localizable.xcstrings 
  --access-level public \
  --output ./App/Sources/Localizable.swift

note: Output written to ‘./App/Sources/Localizable.swift‘
```

##### Legacy Strings Files

Assuming the following setup:

Strings File: **./App/Resources/en.lproj/Localizable.strings**  
Strings Dictionary File: **./App/Resources/en.lproj/Localizable.stringsdict**  
Source Directory: **./App/Sources/**

```bash
$ xcstrings-tool generate \
  ./App/Resources/en.lproj/Localizable.strings \
  ./App/Resources/en.lproj/Localizable.stringsdict \
  --access-level public \
  --output ./App/Sources/Localizable.swift

note: Output written to ‘./App/Sources/Localizable.swift‘
```

> You should only specify the input files for the source language.
>
> If you specify input files for other languages, you must also ensure that they are property embedded within  ***.lproj** directories and that you specify the `--development-language` argument so that inputs are filtered.
>
> This is because unlike the Strings Catalog format, the development language is not part of the legacy inputs.


##### Help Information

To view the complete set of available options, specify the `--help` flag:

```bash
$ xcstrings-tool generate --help

USAGE: xcstrings-tool generate <inputs> ... --output <output> [--config <config>] [--access-level <access-level>] [--development-language <development-language>] [--verbose]

ARGUMENTS:
  <inputs>                Path to xcstrings String Catalog file
        You can also pass multiple file paths to the same Strings Table. For
        example, a path to Localizable.strings as well as
        Localizable.stringsdict. An error will be thrown if you pass inputs to
        multiple different Strings Tables.

OPTIONS:
  -o, --output <output>   Path to write generated Swift output
  -c, --config <config>   File path to a xcstrings-tool-config.yml configuration file
  -a, --access-level <access-level>
                          Modify the Access Control for the generated source
                          code (values: internal, public, package)
  -d, --development-language <development-language>
                          The development language (defaultLocalization in
                          Package.swift) used when filtering legacy .strings
                          and .stringsdict files from the input paths
  -v, --verbose
  --version               Show the version.
  -h, --help              Show help information.
```
