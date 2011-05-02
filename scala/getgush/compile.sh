#!/bin/bash

# Flush the contents of the bin directory
if [ -d bin ]; then
  rm -rf bin
fi
mkdir bin

# Get the Scala library if missing
# hardcoded location to Arch Linux
if [ ! -f scala-library.jar ]; then
  cp /usr/share/scala/lib/scala-library.jar .
fi

# Scala compilation
scalac -sourcepath src -d bin src/ApplyTo.scala

# Packaging up
cd bin
jar -cfm ../getgush.jar ../MANIFEST.MF *
cd ..

# Run that thing
java -jar getgush.jar
