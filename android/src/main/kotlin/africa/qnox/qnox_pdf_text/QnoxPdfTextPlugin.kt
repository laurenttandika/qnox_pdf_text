package africa.qnox.qnox_pdf_text

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.text.PDFTextStripper
import java.io.File

class QnoxPdfTextPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "qnox_pdf_text")
    channel.setMethodCallHandler(this)
    PDFBoxResourceLoader.init(binding.applicationContext)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    try {
      val args = call.arguments as? Map<*, *> ?: emptyMap<String, Any>()
      when (call.method) {
        "extractText" -> {
          val path = args["filePath"] as? String ?: return result.error("ARG","filePath required",null)
          result.success(extractAllText(path))
        }
        "extractPageText" -> {
          val path = args["filePath"] as? String ?: return result.error("ARG","filePath required",null)
          val idx = (args["pageIndex"] as? Int) ?: 0
          result.success(extractPageText(path, idx))
        }
        "pageCount" -> {
          val path = args["filePath"] as? String ?: return result.error("ARG","filePath required",null)
          result.success(pageCount(path))
        }
        else -> result.notImplemented()
      }
    } catch (e: Exception) {
      result.error("ERR", e.message, null)
    }
  }

  private fun load(path: String): PDDocument {
    val f = File(path)
    require(f.exists()) { "File not found: $path" }
    return PDDocument.load(f)
  }

  private fun extractAllText(path: String): String =
    load(path).use { doc -> PDFTextStripper().getText(doc) }

  private fun extractPageText(path: String, pageIndex: Int): String =
    load(path).use { doc ->
      val n = doc.numberOfPages
      require(pageIndex in 0 until n) { "pageIndex out of range (0..${n - 1})" }
      val s = PDFTextStripper()
      s.startPage = pageIndex + 1
      s.endPage = pageIndex + 1
      s.getText(doc)
    }

  private fun pageCount(path: String): Int =
    load(path).use { it.numberOfPages }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}