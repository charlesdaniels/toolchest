#!/bin/sh
#
# preinstall script for pdfutils

# check that supported OCR software is present on the system; warn, but do not
# fail if it is not.

PDFPENPRO_PATH="/Applications/PDFpenPro.app/Contents/MacOS/PDFpenPro"
PDFPEN_PATH="/Applications/PDFpen.app/Contents/MacOS/PDFpen"
FOUND="no"

if [ -e "$PDFPEN_PATH" ] ; then
  FOUND="yes"
fi

if [ -e "$PDFPENPRO_PATH" ] ; then
  FOUND="yes"
fi

if [ "$FOUND" != "yes" ] ; then
  echo "WARNING: no suported OCR software is installed, pdf-ocr may not work correctly"
fi