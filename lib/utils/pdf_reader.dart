import 'package:syncfusion_flutter_pdf/pdf.dart';

///Class to convert PDF (in bytes format) to solid text
///Usage: PDFToRawTextConverter(bytes).result -> returns String
class PDFToRawTextConverter {
  final List<int> bytes;

  ///Constructs PDF to text converter. Requires pdf data in byte format [bytes].
  ///Text can be extracted by
  ///
  ///```dart
  ///String text = PDFToRawTextConverter(bytes).convertToText();
  ///```
  PDFToRawTextConverter(this.bytes);

  Future<String> convertToText() async {
    //Load the PDF document by bytes
    PdfDocument document = PdfDocument(inputBytes: bytes);

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    String result = extractor.extractText().replaceAll("\n", "");
    //Dispose document
    document.dispose();

    return result;
  }
}
