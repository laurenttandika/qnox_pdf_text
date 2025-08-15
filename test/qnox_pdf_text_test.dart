import 'package:flutter_test/flutter_test.dart';
import 'package:qnox_pdf_text/qnox_pdf_text.dart';
import 'package:qnox_pdf_text/qnox_pdf_text_platform_interface.dart';
import 'package:qnox_pdf_text/qnox_pdf_text_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQnoxPdfTextPlatform
    with MockPlatformInterfaceMixin
    implements QnoxPdfTextPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final QnoxPdfTextPlatform initialPlatform = QnoxPdfTextPlatform.instance;

  test('$MethodChannelQnoxPdfText is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQnoxPdfText>());
  });

  test('getPlatformVersion', () async {
    QnoxPdfText qnoxPdfTextPlugin = QnoxPdfText();
    MockQnoxPdfTextPlatform fakePlatform = MockQnoxPdfTextPlatform();
    QnoxPdfTextPlatform.instance = fakePlatform;

    expect(await qnoxPdfTextPlugin.getPlatformVersion(), '42');
  });
}
