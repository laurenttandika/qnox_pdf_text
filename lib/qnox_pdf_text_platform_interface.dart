import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qnox_pdf_text_method_channel.dart';

abstract class QnoxPdfTextPlatform extends PlatformInterface {
  /// Constructs a QnoxPdfTextPlatform.
  QnoxPdfTextPlatform() : super(token: _token);

  static final Object _token = Object();

  static QnoxPdfTextPlatform _instance = MethodChannelQnoxPdfText();

  /// The default instance of [QnoxPdfTextPlatform] to use.
  ///
  /// Defaults to [MethodChannelQnoxPdfText].
  static QnoxPdfTextPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QnoxPdfTextPlatform] when
  /// they register themselves.
  static set instance(QnoxPdfTextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // Methods to implement
  Future<String> extractText(String filePath) {
    throw UnimplementedError('extractText() has not been implemented.');
  }

  Future<String> extractPageText(String filePath, int pageIndex) {
    throw UnimplementedError('extractPageText() has not been implemented.');
  }

  Future<int> pageCount(String filePath) {
    throw UnimplementedError('pageCount() has not been implemented.');
  }
}
