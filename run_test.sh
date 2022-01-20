#!/usr/bin/env bash
set -eou pipefail
TC=$(mktemp)
SE=$(mktemp)
NAME=${NAME:-default}
SECRET=${SECRET:-JDDK4U6G3BJLEZ7Y}
DIGITS=${DIGITS:-6}
PERIOD=${PERIOD:-60}
DIGEST=${DIGEST:-sha1}

cleanup(){
  [[ -f $TC ]] && unlink $TC
  [[ -f $SE ]] && unlink $SE
   true
}
trap cleanup EXIT
cat << EOF > $TC
[$NAME]
Secret = $SECRET
Digits = $DIGITS
Algorithm = $DIGEST
Period = $PERIOD
EOF


python3 totp_client.py -t 3 -n $NAME -d -c $TC 2>$SE
ec=$?
[[ $ec != 0 ]] && { >&2 cat $SE ; exit $ec; }
