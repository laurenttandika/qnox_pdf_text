import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qnox_pdf_text/qnox_pdf_text_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelQnoxPdfText platform = MethodChannelQnoxPdfText();
  const MethodChannel channel = MethodChannel('qnox_pdf_text');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
