#!/bin/sh

read -r -d '' OAUTH_CREDENTIALS << HERE
3rJxxxxxxxxxxxxxxxxxx,5jPxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx,3170000000-V9rxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx,u9zxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
HERE

export OAUTH_CREDENTIALS

./bin/parenbot daemon


