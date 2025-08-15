# qnox_pdf_text

A Flutter plugin for extracting text from PDF documents on **Android** (using [pdfbox-android](https://github.com/TomRoush/PdfBox-Android)) and **iOS** (using [PDFKit](https://developer.apple.com/documentation/pdfkit)).  
Supports both **local PDFs** and **online PDFs** via a simple API.

---

## ✨ Features
- Extract all text from a PDF
- Extract text from a specific page
- Get total page count
- Works with local file paths and remote URLs (HTTP/HTTPS)

---

## 📦 Installation
Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  qnox_pdf_text: ^0.1.0
```

## Then run:
```bash
    flutter pub get
```

## 🚀 Usage
```bash
    import 'package:qnox_pdf_text/qnox_pdf_text.dart';

    final pdf = QnoxPdfText();

    // From local file
    final pages = await pdf.pageCount('/path/to/file.pdf');
    final pageText = await pdf.extractPageText('/path/to/file.pdf', 0);

    // From online URL
    final urlPages = await pdf.pageCountFromUrl('https://example.com/sample.pdf');
    final allText = await pdf.extractTextFromUrl('https://example.com/sample.pdf');
```

## 📱 Platform Notes

- Android
	•	Requires mavenCentral() in Gradle
	•	Uses pdfbox-android internally

- iOS
	•	Minimum iOS 13.0
	•	Uses native PDFKit

## 📄 License

MIT License. See LICENSE for details.