#!opencode:1.0

INPUT_FILE = $1
if len(INPUT_FILE) == 0 {
  print "usage: ash refine-task.ash <requirement.md>"
  exit 1
}

IDX = 0
exec cat ${INPUT_FILE}
IDEA = ${stdout}

session {
  evaluate {
    IDX = $_attempt
    PREV_IDX = $_attempt - 1
    do @"prompt-produce.md" using deepseek/deepseek-v4-pro
  } by @"prompt-assess.md" using deepseek/deepseek-v4-pro
    accept by 75
    upto 5
}
if $accepted {
  exec "cp tmp/task-definition_${IDX}.md tasks/ready/${INPUT_FILE}"
  print "Accepted — score $score"
  exit 0
} else {
  print "Rejected — final score $score"
  exit 1
}
