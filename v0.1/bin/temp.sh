#!/bin/bash

 
while getopts ":a:b:c:" opt; do
  case $opt in
    a) opt_a=$OPTARG >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
echo $opt_a
