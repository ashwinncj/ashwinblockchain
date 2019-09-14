#!/bin/bash

mode=$1

case "$mode" in
    create)
        echo "Create case"
    ;;
    *)
        echo "default"
    ;;
esac

#shift $((OPTIND -1))
