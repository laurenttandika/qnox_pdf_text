import Flutter
import PDFKit

public class QnoxPdfTextPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "qnox_pdf_text", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(QnoxPdfTextPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "ARG", message: "Arguments missing", details: nil)); return
    }
    switch call.method {
    case "extractText":
      guard let path = args["filePath"] as? String else { result(FlutterError(code:"ARG", message:"filePath required", details:nil)); return }
      result(extractAllText(path))
    case "extractPageText":
      guard let path = args["filePath"] as? String, let idx = args["pageIndex"] as? Int else {
        result(FlutterError(code:"ARG", message:"filePath/pageIndex required", details:nil)); return
      }
      result(extractPageText(path, idx))
    case "pageCount":
      guard let path = args["filePath"] as? String else { result(FlutterError(code:"ARG", message:"filePath required", details:nil)); return }
      result(pageCount(path))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func doc(_ path: String) -> PDFDocument? { PDFDocument(url: URL(fileURLWithPath: path)) }

  private func extractAllText(_ path: String) -> String {
    guard let d = doc(path) else { return "" }
    var out = ""
    for i in 0..<d.pageCount { out += d.page(at: i)?.string ?? ""; out += "\n" }
    return out
  }

  private func extractPageText(_ path: String, _ idx: Int) -> String {
    guard let d = doc(path), idx >= 0, idx < d.pageCount else { return "" }
    return d.page(at: idx)?.string ?? ""
  }

  private func pageCount(_ path: String) -> Int { doc(path)?.pageCount ?? 0 }
}