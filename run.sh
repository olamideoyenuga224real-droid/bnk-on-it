#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
javac *.java
java Bank
