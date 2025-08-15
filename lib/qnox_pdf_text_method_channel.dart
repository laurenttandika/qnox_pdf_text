import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qnox_pdf_text_platform_interface.dart';

/// An implementation of [QnoxPdfTextPlatform] that uses method channels.
class MethodChannelQnoxPdfText extends QnoxPdfTextPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qnox_pdf_text');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String> extractText(String filePath) async {
    final res = await methodChannel.invokeMethod<String>('extractText', {
      'filePath': filePath,
    });
    return res ?? '';
  }

  @override
  Future<String> extractPageText(String filePath, int pageIndex) async {
    final res = await methodChannel.invokeMethod<String>('extractPageText', {
      'filePath': filePath,
      'pageIndex': pageIndex,
    });
    return res ?? '';
  }

  @override
  Future<int> pageCount(String filePath) async {
    final res = await methodChannel.invokeMethod<int>('pageCount', {
      'filePath': filePath,
    });
    return res ?? 0;
  }
}
