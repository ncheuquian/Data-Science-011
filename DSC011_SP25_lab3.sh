#!/bin/sh
date > `whoami`.history.txt
whoami >> `whoami`.history.txt
echo $I >> `whoami`.history.txt
echo $HP >> `whoami`.history.txt
