import 'dart:io';

import 'package:flutter/foundation.dart';

import 'qnox_pdf_text_platform_interface.dart';

class QnoxPdfText {
  Future<String?> getPlatformVersion() {
    return QnoxPdfTextPlatform.instance.getPlatformVersion();
  }

  /// Extracts all text from the PDF at [filePath].
  Future<String> extractText(String filePath) {
    return QnoxPdfTextPlatform.instance.extractText(filePath);
  }

  /// Extracts text from a specific page [pageIndex] (0-based).
  Future<String> extractPageText(String filePath, int pageIndex) {
    return QnoxPdfTextPlatform.instance.extractPageText(filePath, pageIndex);
  }

  /// Returns the number of pages in the PDF.
  Future<int> pageCount(String filePath) {
    return QnoxPdfTextPlatform.instance.pageCount(filePath);
  }

  // ----------------------------
  // URL helpers (no native changes)
  // ----------------------------

  /// Extract all text from a PDF at [url] by downloading to a temp file first.
  Future<String> extractTextFromUrl(String url) async {
    final local = await _ensureLocal(url);
    return extractText(local);
  }

  /// Extract text from a specific page (0-based) from a PDF at [url].
  Future<String> extractPageTextFromUrl(String url, int pageIndex) async {
    final local = await _ensureLocal(url);
    return extractPageText(local, pageIndex);
  }

  /// Get page count for a PDF at [url].
  Future<int> pageCountFromUrl(String url) async {
    final local = await _ensureLocal(url);
    return pageCount(local);
  }

  // If [pathOrUrl] is http/https, download to a temp file and return its path.
  // Otherwise assume it's already a local file path.
  Future<String> _ensureLocal(String pathOrUrl) async {
    final uri = Uri.tryParse(pathOrUrl);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return _downloadToTemp(uri);
    }
    return pathOrUrl;
  }

  Future<String> _downloadToTemp(Uri url) async {
    final httpClient = HttpClient();
    try {
      final req = await httpClient.getUrl(url);
      final resp = await req.close();
      if (resp.statusCode != 200) {
        throw Exception('Failed to download PDF (${resp.statusCode})');
      }
      final bytes = await consolidateHttpClientResponseBytes(resp);
      final tmpPath =
          '${Directory.systemTemp.path}/qnox_${DateTime.now().microsecondsSinceEpoch}.pdf';
      final file = File(tmpPath);
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } finally {
      httpClient.close(force: true);
    }
  }
}
