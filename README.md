# piano-in-sed

A sed script to play a text musical notation.

(Proof-of-concept.)

Usage:
```sh
cat jingle-bells.notes | ./music.sed > /dev/dsp
# or
cat jingle-bells.notes | ./music.sed | aplay -Dplug:default
# or
cat jingle-bells.notes | ./music.sed | sox -t raw -r 8k -c 1 -e unsigned -b 8 - -d gain -h
```
