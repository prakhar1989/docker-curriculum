#!/bin/bash

### Generates the HTML using ADI's template files

TITLE_TMP="README"
OUTPUTFILE="index.html"

# copy over all needed files into build/
cd build
cp "../$TITLE_TMP.md" .
cp template.css "$TITLE_TMP.css"

# run md2html
python md2html.py "$TITLE_TMP.md"

# copy output to the root dir, and delete intermediate files
mv "$TITLE_TMP.html" ../$OUTPUTFILE
rm -f "$TITLE_TMP.css" "$TITLE_TMP.md"
