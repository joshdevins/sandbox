#!/bin/bash

####
# Scrape an InfoQ presentation with video and slides.
# Prerequisites:
#  - Load up the presentation page on InfoQ with FireBug enabled
#  - Press play on the flash player and grab the URL that the flv is downloaded from
#
# December 22, 2009
# Josh Devins <info@joshdevins.net>
####

# GET OPTION FLAGS
proxyFlag=

while getopts 'p:' OPTION
do
  case $OPTION in
  p)    proxyFlag=1
        proxyVal="$OPTARG"
        ;;
  esac
done
shift $(($OPTIND - 1))

REQUIRED_ARGS=2
TMP_FILE=/tmp/infoq-presentation-scrape.html

# CHECK REQUIRED ARGS
if [ $# -lt $REQUIRED_ARGS ]
then
  printf "Usage: %s: [-p proxy] <InfoQ presentation URL> <FLV URL>\n" $(basename $0) >&2

  exit 2;
fi

PRESENTATION_URL=$1
FLV_URL=$2

if [ "$proxyFlag" ]
then
  PROXY="--proxy ${proxyVal}"
fi

CURL="curl $PROXY -C - -O"

# grab the page and get properties out of it
echo "Downloading presentation page..."
curl $PROXY -o $TMP_FILE $PRESENTATION_URL

# test for success
if [ -e "$TMP_FILE" ]
then
  echo -n ""  
else
  echo "Failed to download presentation page!"
  exit 1;
fi

# title
TITLE=`cat $TMP_FILE | head -16 | tail -n 1 | awk '{sub(/^[ \t]+/, "")};1' | awk '{sub(/[ \r\n]+$/, "")};1'`

mkdir "$TITLE"
cd "$TITLE"

# download all sides
echo -n "Downloading all slides..."
SLIDES=`grep "var slides" $TMP_FILE | awk '{ print (substr($3, 7, length($3) - 10)) }' | sed -e "s/,/ /g;s/'//g"`

for resource in $SLIDES ; do
  echo -n "."
  $CURL -s "http://www.infoq.com${resource}"
done
echo ""

# download flv
echo "Downloading presentation video..."
$CURL $FLV_URL

# cleanup
rm -rf $TMP_FILE
