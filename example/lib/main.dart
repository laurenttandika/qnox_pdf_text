import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:qnox_pdf_text/qnox_pdf_text.dart';

void main() =>
    runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Demo()));

class Demo extends StatefulWidget {
  const Demo({super.key});
  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final api = QnoxPdfText();

  // Source state
  String? _localPath; // local file path if picked
  String? _sourceLabel; // file name or url host/last segment
  final _urlCtrl = TextEditingController();

  // Extraction state
  int _pages = 0;
  int _currentPage = 0; // 0-based
  String _text = '';

  // UI state
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  bool get _usingUrl {
    final s = _urlCtrl.text.trim();
    return s.startsWith('http://') || s.startsWith('https://');
  }

  Future<void> _pickLocal() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      final path = res?.files.single.path;
      if (path == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final pages = await api.pageCount(path);
      final first = pages > 0 ? await api.extractPageText(path, 0) : '';
      if (!mounted) return;
      setState(() {
        _localPath = path;
        _sourceLabel = File(path).uri.pathSegments.last;
        _pages = pages;
        _currentPage = 0;
        _text = first;
        _loading = false;
        _urlCtrl.clear(); // switch to local mode
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadFromUrl() async {
    final raw = _urlCtrl.text.trim();
    if (raw.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pages = await api.pageCountFromUrl(raw);
      final first = pages > 0 ? await api.extractPageTextFromUrl(raw, 0) : '';
      if (!mounted) return;

      final uri = Uri.tryParse(raw);
      final nice = uri == null
          ? raw
          : (uri.pathSegments.isNotEmpty
                ? '${uri.host}/${uri.pathSegments.last}'
                : uri.toString());

      setState(() {
        _localPath = null; // source is URL-backed
        _sourceLabel = nice;
        _pages = pages;
        _currentPage = 0;
        _text = first;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _extractAll() async {
    if (_pages <= 0) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final all = _usingUrl
          ? await api.extractTextFromUrl(_urlCtrl.text.trim())
          : await api.extractText(_localPath ?? '');
      if (!mounted) return;
      setState(() {
        _text = all;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _extractPage(int pageIndex) async {
    if (_pages <= 0) return;
    setState(() {
      _loading = true;
      _error = null;
      _currentPage = pageIndex;
    });
    try {
      final pageText = _usingUrl
          ? await api.extractPageTextFromUrl(_urlCtrl.text.trim(), pageIndex)
          : await api.extractPageText(_localPath ?? '', pageIndex);
      if (!mounted) return;
      setState(() {
        _text = pageText;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    final sourceName = _sourceLabel ?? 'No source selected';
    return Scaffold(
      appBar: AppBar(title: const Text('qnox_pdf_text demo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickLocal,
        icon: const Icon(Icons.folder_open),
        label: const Text('Pick local PDF'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URL input and Load button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlCtrl,
                      decoration: const InputDecoration(
                        labelText: 'PDF URL (http/https)',
                        hintText: 'https://example.com/sample.pdf',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.url,
                      onSubmitted: (_) => _loadFromUrl(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _loadFromUrl,
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Load URL'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Source + page count
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sourceName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (_pages > 0) Text('Pages: $_pages'),
                ],
              ),
              const SizedBox(height: 8),

              // Controls
              Row(
                children: [
                  if (_pages > 0) ...[
                    const Text('Page:'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _currentPage,
                      items: List.generate(
                        _pages,
                        (i) =>
                            DropdownMenuItem(value: i, child: Text('${i + 1}')),
                      ),
                      onChanged: (v) {
                        if (v != null) _extractPage(v);
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _pages > 0
                          ? () => _extractPage(_currentPage)
                          : null,
                      icon: const Icon(Icons.text_snippet),
                      label: const Text('Extract page'),
                    ),
                  ],
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _pages > 0 ? _extractAll : null,
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Extract all'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _text.isEmpty ? null : _copy,
                    tooltip: 'Copy',
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (_loading) const LinearProgressIndicator(),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],

              const SizedBox(height: 8),

              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _text.isEmpty
                        ? const Center(
                            child: Text(
                              'Pick a PDF or load from URL to extract text',
                            ),
                          )
                        : SingleChildScrollView(
                            child: SelectableText(
                              _text,
                              textAlign: TextAlign.left,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
