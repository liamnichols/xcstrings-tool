#!/usr/bin/env bash

echo "Toolchain:"
echo "=========="
xcrun swift --version
echo ""

vers=${SWIFT_VERSION:-5}
echo "Swift Language Mode:"
echo "===================="
echo "Swift $vers"
echo ""

echo "Compiling Snapshots:"
echo "===================="
for snapshot in Tests/XCStringsToolTests/__Snapshots__/**/*.swift; do
  echo "Compiling ‘$(basename $snapshot)‘"

  if xcrun swiftc "$snapshot" -package-name "MyPackage" -swift-version "$vers" -o /dev/null ; then
    echo "  Success"
  else
    exit $?
  fi
done
