#!/bin/bash
#
# Edit local path in config.sh #
echo ""
echo ">>> Editing local path in config.sh, before sourcing"
mv config.sh tmp.sh
cat tmp.sh | awk -v pwd="$PWD" -F '=' '{if($1=="LOCAL_TOP") print $1 "=\"" pwd "\""; else print $0}' > config.sh
rm -f tmp.sh
chmod u+x config.sh
#
