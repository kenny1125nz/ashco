#!opencode:1.0

exec "rm -f tmp/prioritized-ideas.md && mkdir -p tmp"

evaluate {
  do @"prompt-prioritize.md" using deepseek/deepseek-v4-pro  
} by @"prompt-assess-priorities.md" using deepseek/deepseek-v4-pro
   accept by 75
   upto 5

if $accepted {
  print "Prioritisation accepted (score ${score})"
  print ""
  exec cp tmp/prioritized-ideas.md ideas/
  exit 0
} else {
  print "Prioritisation rejected (final score ${score})"
  exit 1
}
