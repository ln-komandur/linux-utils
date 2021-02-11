if [ $# -eq 0 ]
then
    echo "Give the name of the folder to place OCR-ed files as an argument. Exiting"
    exit 1
fi

mkdir -p $1
mkdir -p raw-pdfs

for file in *.pdf
do
    echo "Running OCR on - " $file
    ocrmypdf -l eng+san --output-type pdf --optimize 3 --deskew --remove-background --force-ocr "$file" "./$1/${file%.pdf}_OCR.pdf"
    mv "$file" "./raw-pdfs/$file"
    echo "Moved " $file " to " "./raw-pdfs/$file"
done


for file in *.PDF 
do
    echo "Running OCR on - " $file
    ocrmypdf -l eng+san --output-type pdf --optimize 3 --deskew --remove-background --force-ocr "$file" "./$1/${file%.PDF}_OCR.pdf"
    mv "$file" "./raw-pdfs/$file"
    echo "Moved " $file " to " "./raw-pdfs/$file"
done
