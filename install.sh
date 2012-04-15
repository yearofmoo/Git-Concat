#!/usr/bin/env bash

DIR="./Git-Concat"
FILE="$DIR/pre-commit.rb"
FINAL="./.git/hooks/pre-commit"

if [ ! -d ./.git ]; then
  echo "Git-Concat: Git repo in this directory is non existant"
  exit 0
fi

if [ -f $FINAL ]; then
  echo "Git-Concat: pre-commit file already exists in $FINAL"
  exit 0
fi

git clone git://github.com/matsko/Git-Concat.git $DIR

if [ ! -f $FILE ]; then
  echo "Git-Concat: Git pull operation failed"
  exit 0
fi

chmod +x ./$FILE
mv ./$FILE ./.git/hooks/pre-commit

rm -fr $DIR

if [ ! -f $FILE ]; then
  echo "Git-Concat: Git pull operation failed"
  exit 0
fi

touch "./.gitconcat"

echo "Git-Concat installed."
echo ".gitconcat file created"
