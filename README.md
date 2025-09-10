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
  qnox_pdf_text: ^0.1.2
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
```
MIT License

Copyright (c) 2025 Qnox Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```