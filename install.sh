#!/usr/bin/env bash

DIR="./Git-Concat"

if [ ! -d ./.git ]
  echo "Git-Concat: Git repo in this directory is non existant"
  exit 1
fi

git clone git://github.com/matsko/Git-Concat.git $DIR

FILE="$DIR/pre-commit.rb"

if [ ! -f $FILE ]
  echo "Git-Concat: Git pull operation failed"
  exit 1
fi

chmod +x ./$FILE
mv ./$FILE ./.git/hooks/pre-commit

rm -fr $DIR

touch "./.gitconcat"

echo "Git-Concat installed."
echo ".gitconcat file created"
