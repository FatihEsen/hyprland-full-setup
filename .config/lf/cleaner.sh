#!/bin/sh
# Kitty resim protokolü ile ekrandaki resmi temizle
kitten icat --clear --stdin=no --silent --transfer-mode=memory < /dev/null > /dev/tty
