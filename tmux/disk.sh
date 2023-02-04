#! /bin/sh

df | awk '/ \/$/{printf("%3.1f%%", $5)}'
