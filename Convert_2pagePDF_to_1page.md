### Rotate the pages clockwise by 90 degrees "if required" with
`pdftk Sleeping.pdf cat 1-endeast output Standing.pdf`

### Break the PDF into separate images of each page
Can also try `pdftoppm -mono` or `pdftoppm -png` if those gives better outputs. Try without neither for color

`mkdir double-page-images`

`pdftoppm -gray Standing.pdf ./double-page-images/R-and-L-page`

`cd double-page-images/`
 
### Split the double-page-images into 2 separate single page images
`unpaper --layout double --output-pages 2  R-and-L-page-%02d.pgm single-page%02d.pgm`
 
### Rename all pgm files so that the numbering with order the pages properly when using img2pdf command later
`rename 's/single-page(\d\d)\.p(.+)/single-page-0$1.p$2/g' *`

### Manually reorder pages if needed
There is no command for this
  
### Make a book with single pages
`img2pdf single-page*.* -o Book-v1.pdf`


### If you originally generated PNG files (using `pdftoppm -png`), the following step can be skipped. You can directly go to whiten the background
 
### Split the book again to get png files for each page as below
`mkdir png-images`

`pdftoppm -png Book-v1.pdf ./png-images/PageNo`

`cd png-images/`

### Whiten the background
Create a directory to store images without background / white background 
`mkdir whitebkgnd`
 
### Convert every file to remove background using a shell script
`./removebkgnd.sh`

```
#This shell script has only the below
for file in *.png
do
    echo "Removing background on - " $file
    convert "$file" -background white -alpha remove -alpha off "./whitebkgnd/$file"
done
```
Also use any other means to enhance these png images now. e.g. using shotwell, gimp etc.

### Insert any new png files if needed. i.e. there may be some pages that may need to be in color. e.g. cover page
### Make a PDF book again from png files which have white/no background
`cd whitebkgnd/`

`img2pdf PageNo*.* -o Book-v2-nobkgnd.pdf`

### OCR that PDF 
`ocrmypdf --lang eng+tam+san --sidecar english-tamil-sanskrit-text.txt --optimize 3 --deskew Book-v2-nobkgnd.pdf Book-final-nobkgnd-OCR.pdf`
