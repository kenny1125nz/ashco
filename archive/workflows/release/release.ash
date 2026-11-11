tag = ${1}

include "prepare.ash"

do @"generate-release-notes.md" with opencode

include "publish.ash"
