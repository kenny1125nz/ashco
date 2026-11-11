# Product Execute — runs development cycle per discovered feature
# Discover phase outputs feature briefs into workspace/02-product/01-discover/feature-briefs/
# This script loops over them and runs the full development cycle for each
use opencode

FEATURES_DIR = "workspace/02-product/01-discover/feature-briefs"
exec mkdir -p "${FEATURES_DIR}"

FEATURES = exec "find ${FEATURES_DIR} -maxdepth 1 -name '*.md' -type f"

for FEATURE in FEATURES {
  print "=== Developing feature: ${FEATURE} ==="
  FEATURE_FILE = FEATURE
  do @"development/" with opencode
}

print "=== All features developed ==="
