#!/usr/bin/env bash

DIR="./Git-Concat"
FILE="$DIR/script.rb"
FINAL="./.git/hooks/pre-commit"
CONCAT_FILE="./.gitconcat"

if [ ! -d ./.git ]; then
  echo "Git-Concat: Git repo in this directory is non existant."
  exit 0
fi

if [ -f $FINAL ]; then
  echo "Git-Concat: pre-commit file already exists in $FINAL."
  exit 0
fi

git clone git://github.com/matsko/Git-Concat.git $DIR

if [ ! -f $FILE ]; then
  echo "Git-Concat: Git pull operation failed."
  exit 0
fi

chmod +x ./$FILE
mv ./$FILE ./.git/hooks/pre-commit

rm -fr $DIR

if [ ! -f $FINAL ]; then
  echo "Git-Concat: Unable to movie pre-commit file to $FINAL."
  exit 0
fi

echo "Git-Concat: Installation successful."

if [ ! -f $CONCAT_FILE ]; then
  touch $CONCAT_FILE
  echo "Git-Concat: .gitconcat file created."
fi
