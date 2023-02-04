#! /bin/sh

(grep 'cpu ' /proc/stat; sleep 0.1; grep 'cpu ' /proc/stat) \
  | awk -v RS="" '{printf("%3.1f%%", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5))}'
