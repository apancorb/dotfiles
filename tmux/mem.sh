#! /bin/sh

awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf("%3.1f%%", 100-100*a/t)}' /proc/meminfo
