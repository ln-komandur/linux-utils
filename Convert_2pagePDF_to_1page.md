### Rotate the pages "if required"
`pdftk Sleeping.pdf cat 1-endeast output Standing.pdf # rotate clockwise by 90 degrees`

`pdftk Sleeping.pdf cat 1-endwest output Standing.pdf # rotate counter-clockwise by 90 degrees`


### Break the PDF into separate images of each page
`mkdir double-page-images`

`pdftoppm -gray Standing.pdf ./double-page-images/R-and-L-page`

Can also try `pdftoppm -mono` or `pdftoppm -png` if those gives better outputs. Try without neither option to get color outputs

### Split the double-page-images into 2 separate single page images
`cd double-page-images/`

Remember to use the right file extn i.e. `.ppm / .pgm / .png` etc. in the command below.  --no-grayfilter helps to avoid white patches in color images

`unpaper --no-grayfilter --layout double --output-pages 2  R-and-L-page-%02d.pgm single-page%02d.pgm`
 
#### Rename all ppm / pgm / png files with numbering that orders them as pages when using img2pdf command later
`rename 's/single-page(\d\d)\.p(.+)/single-page-0$1.p$2/g' *`

#### Resize or Crop pages to constant size

Refer [Ghost script based approach to cropping an entire pdf document](https://askubuntu.com/questions/124692/command-line-tool-to-crop-pdf-files)

`mkdir resized #Create a directory to store resized images`

Remember to use the right file extn i.e. `.ppm / .pgm / .png` etc. in the command below 

`file <image-name.png>` or `identify <image-name.png> #Find the existing size in pixels. e.g. 825x1275`

`./resize-pages.sh`

```
#This shell script resizes or crops pages. Choose only one convert command below in the loop based on the need.
for file in *.png
do
    echo "Resizing page to 825x1200 - " $file
    convert "$file" -resize 825x1200 "./resized/$file"
    # convert "$file" -crop 1050x1428+0+50 -resize 1000x1378 "./resized/$file"
    
done
```


#### Manually reorder pages if needed
There is no command for this
  
### Make a book with single pages
`img2pdf single-page*.* -o Book-v1.pdf`

### Whiten background
 
#### Split the book again to get png files for each page as below
If you originally generated PNG files (using `pdftoppm -png`), skip this step and directly go for whitening the background

`mkdir png-images`

`pdftoppm -png Book-v1.pdf ./png-images/PageNo`

`cd png-images/`

#### Using a shell script and process every file in the folder to remove its background, crop it, and also sharpen it
`./process-all-pngs.sh`

```
#This shell script contains the below


if [ $# -le 0 ]
then
    echo "Usage: process-all-pngs <first-level-sub-directory-name>"
    echo "Provide the first level sub-directory name to place images in. Another folder with the name sharper will be created under it"
    echo "Exiting"
    exit 1
fi

mkdir -p $1
echo "Made sub-directory " $1 " to place output files "

mkdir -p "$1/sharper"
echo "Made sub-directory " "$1/sharper" " to place output files "

for file in *.png
do
    echo "Processing - " $file ". Removing the background, cropping it, and also sharpening it."
    mogrify -crop 1050x1338+0+45 -path "./$1/sharper" -format png -unsharp 1.5x1 -background '#ffffff' -quality 100% "$file" #Sharpen the image with an unsharp mask operator

done
```
Also use any other means to enhance these png images now to crop, enhance images. e.g. using shotwell, gimp etc.

### Insert any new png files if needed. i.e. there may be some pages that may need to be in color. e.g. cover page
It is a good idea to add color cover pages as the last step (after OCR) by adding them to the pdf directly using pdftk. This produces smaller files for some reason


### Sharpen the pages if not done by the script above (which uses -unsharp rather than -sharpen
`mkdir sharper`

`mogrify -path ./sharper/ -format png -sharpen 1x1 -quality 96% PageNo*.png #Sharpen`

[in the `-sharpen 1x1` switch](http://www.graphicsmagick.org/GraphicsMagick.html#details-sharpen), the first `1` is the radius, the second `1` is the sigma factor

or 

`mogrify -path ./sharper/ -format png -unsharp 1x1 -quality 96% PageNo*.png #Sharpen the image with an unsharp mask operator`

[in the `-unsharp 1x1` switch](http://www.graphicsmagick.org/GraphicsMagick.html#details-unsharp), the first `1` is the radius, the second `1` is the sigma factor

### Make a PDF book again from png files which have white/no background
`cd whitebkgnd/sharper`

`img2pdf PageNo*.* -o Book-v2-nobkgnd.pdf` or `img2pdf single-page*.* -o Book-v2-nobkgnd.pdf`

Use any other options to define page size and include page borders too. For e.g.

`img2pdf --output Book-v2-nobkgnd.pdf --pagesize A4^T --border 2.5cm:2.5cm PageNo*.*`

### OCR that PDF 
`ocrmypdf --lang eng+tam+san --sidecar english-tamil-sanskrit-text-v2.txt --optimize 3 --deskew Book-v2-nobkgnd.pdf Book-v2-nobkgnd-OCR.pdf`
