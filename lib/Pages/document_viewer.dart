import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:woxsen/Values/subjects_list.dart';
import 'dart:convert';

class DocumentViewerScreen extends StatefulWidget {
  final String? url;
  final String? filename;
  final String? userId;

  const DocumentViewerScreen({
    Key? key,
    required this.url,
    required this.filename,
    required this.userId,
  }) : super(key: key);

  @override
  _DocumentViewerScreenState createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  String? _filePath;
  bool _isLoading = false;
  bool _isPDF = true;
  // List store = ListStore();

  @override
  void initState() {
    super.initState();
    // _loadDocument();
    getDetails();
  }

  ListStore store = ListStore();

  Future<void> getDetails() async {
    try {
      final response = await http.post(
        Uri.parse('${store.woxUrl}/api/st_leave_get_doc'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'doc_is': 'document_url',
          'user_id': '${widget.userId}',
        }),
      );

      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final tempDocumentPath = '${tempDir.path}/${widget.filename}';
      final file = File(tempDocumentPath);
      await file.writeAsBytes(bytes);

      setState(() {
        _filePath = tempDocumentPath;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Supporting Document'),
      ),
      body: _isLoading || _filePath == null
          ? const Center(child: CircularProgressIndicator())
          : _filePath == null || _filePath!.isEmpty
              ? const Center(child: Text('Error loading document'))
              : Container(
                  color: Colors.grey[200],
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: _isPDF
                        // ? PDFView(
                        //     filePath: _filePath!,
                        //     enableSwipe: true,
                        //     swipeHorizontal: false,
                        //     autoSpacing: true,
                        //     pageFling: true,
                        //     pageSnap: true,
                        //     onRender: (pages) {
                        //       print(pages);
                        //     },
                        //     onError: (error) {
                        //       print(error.toString());
                        //     },
                        //     onPageError: (page, error) {
                        //       print('$page: ${error.toString()}');
                        //     },
                        //   )
                        // : Image.file(
                        //     File(_filePath!),
                        //     fit: BoxFit.contain,
                        //   ),
                        ? (Platform.isWindows
                            ? ElevatedButton(
                                onPressed: () {
                                  // Open PDF with the default application
                                  Process.run(
                                      'cmd', ['/c', 'start', '', _filePath!],
                                      runInShell: true);
                                },
                                child: const Text('Open PDF'))
                            : PDFView(
                                filePath: _filePath,
                                enableSwipe: true,
                                swipeHorizontal: true,
                                autoSpacing: false,
                                pageFling: false,
                              ))
                        : Image.file(
                            File(_filePath!),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
    );
  }
}
