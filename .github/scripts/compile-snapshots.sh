#!/usr/bin/env bash

echo "Swift Version:"
xcrun swift --version
echo ""

for snapshot in Tests/XCStringsToolTests/__Snapshots__/**/*.swift; do
  echo "Compiling ‘$(basename $snapshot)‘"

  if xcrun swiftc "$snapshot" -package-name "MyPackage" -o /dev/null ; then
    echo "  Success"
  else
    exit $?
  fi
done
