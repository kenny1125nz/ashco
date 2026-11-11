#!opencode:1.0

exec mkdir -p ./tmp

exec node @fetch-defects.js

RESULT = $(cat "./tmp/defects.json")
if RESULT == "[]" {
  exit 0
}

do @"analyze-and-fix.md"

exec node @mark-fixed.js

exec node @deploy.js
