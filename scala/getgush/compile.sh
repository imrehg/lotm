#!/bin/bash

if [ -d bin ]; then
  rm -rf bin
fi
mkdir bin

if [ ! -f scala-library.jar ]; then
  cp /usr/share/scala/lib/scala-library.jar .
fi


scalac -sourcepath src -d bin src/ApplyTo.scala

cd bin
jar -cfm ../getgush.jar ../MANIFEST.MF *
cd ..

java -jar getgush.jar
