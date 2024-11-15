import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DocumentViewerScreen extends StatefulWidget {
  final String? url;

  const DocumentViewerScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  // final Map<String, String> document_url;

  // const DocumentViewerScreen({
  //   Key? key,
  //   required this.document_url,
  // }) : super(key: key);

  @override
  _DocumentViewerScreenState createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  String? _filePath;
  bool _isLoading = true;
  bool _isPDF = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
    });

    // Replace these URLs with your actual document URLs
    String pdfUrl =
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
    String imageUrl = 'https://picsum.photos/200/300';

    // Decide which type of document to load (PDF or image)
    bool loadPDF = true; // Set this to false to load an image instead

    if (loadPDF) {
      await _loadPDF(pdfUrl);
    } else {
      await _loadImage(imageUrl);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPDF(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/temp_document.pdf';
    final file = File(tempDocumentPath);
    await file.writeAsBytes(bytes);

    setState(() {
      _filePath = tempDocumentPath;
      _isPDF = true;
    });
  }

  Future<void> _loadImage(String url) async {
    setState(() {
      _filePath = url;
      _isPDF = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
            Navigator.of(context).pop();
          },
        ),
        title: Text('Supporting Document'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filePath == null
              ? Center(child: Text('Error loading document'))
              : Container(
                  color: Colors.grey[200],
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: _isPDF
                        ? PDFView(
                            filePath: _filePath!,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                          )
                        : Image.network(
                            _filePath!,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
    );
  }
}
