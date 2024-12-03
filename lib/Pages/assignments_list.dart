// import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:woxsen/Values/subjects_list.dart';

class AssignmentsList extends StatelessWidget {
  final List<File> pdfs;
  final String params;

  AssignmentsList({super.key, required this.pdfs, required this.params});

  // Remove the initState method

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> paramsMap = jsonDecode(params);

    print('params are $paramsMap');
    print('objects are $pdfs');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Assignments', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFF9999),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Engineering Mathematics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'B. Tech, Semester 3',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pdfs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading:
                        const Icon(Icons.picture_as_pdf, color: Colors.black),
                    title: Text(pdfs[index].path.split('/').last),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerPage(
                              pdfUrl: pdfs[index].path, paramsData: paramsMap),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final Map<String, dynamic> paramsData;

  const PDFViewerPage(
      {Key? key, required this.pdfUrl, required this.paramsData})
      : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? localPdfPath;
  bool isLoading = true;
  String? errorMessage;
  String? pdfUrl;
  ListStore store = ListStore();
  bool isDownloading = false;

  get localPath => null;

  @override
  void initState() {
    super.initState();
    getPdfUrl();
  }

  Future<void> getPdfUrl() async {
    final url = widget.pdfUrl;

    final String apiUrl = '${store.woxUrl}/api/view_files';

    widget.paramsData['filename'] = url.split('/').last;

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': "application/pdf"
          },
          body: jsonEncode(widget.paramsData));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final String path = '$dir/${url.split('/').last}';
        final File file = File(path);
        await file.writeAsBytes(bytes);

        setState(() {
          pdfUrl = path;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'ERROR: $e';
        isLoading = false;
      });
    }
  }

  // void downloadPDF() async {
  //   // if (pdfUrl == null || !Uri.parse(pdfUrl!).isAbsolute) {
  //   //   print('Invalid PDF URL');
  //   //   return;
  //   // }

  //   final url = pdfUrl!;
  //   final fileName = url.split('/').last;

  //   try {
  //     String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  //     if (selectedDirectory == null) {
  //       return;
  //     }

  //     final filePath = '$selectedDirectory/$fileName';

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       print('Download completed: $filePath');
  //     } else {
  //       print('Download failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Download failed: $e');
  //   }
  // }

  void downloadPDF() async {
    if (pdfUrl == null) {
      print('PDF file path is null');
      return;
    }

    final fileName = pdfUrl!.split('/').last;

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        return;
      }

      final filePath = '$selectedDirectory/$fileName';

      final file = File(pdfUrl!);
      if (await file.exists()) {
        await file.copy(filePath);
        print('Download completed: $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download completed: $filePath'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () {
                OpenFile.open(filePath);
              },
            ),
          ),
        );
      } else {
        print('File does not exist: $pdfUrl');
      }
    } catch (e) {
      print('Download failed: $e');
    }
  }

  void uploadAssignment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      // Implement file upload logic here
      print('Uploading file: ${result.files.single.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.pdfUrl.split('/').last}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : PDFView(
                          filePath: pdfUrl!,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                          pageSnap: true,
                          onRender: (pages) {
                            print(pages);
                          },
                          onError: (error) {
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            print('$page: ${error.toString()}');
                          },
                        )),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    downloadPDF();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 95, 111),
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Download',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                // TODO : Implement assignment upload functionality
                // const SizedBox(height: 8),
                // OutlinedButton(
                //   onPressed: () {
                //     // Navigate to upload page
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => const UploadAssignmentPage(),
                //     ));
                //   },
                //   style: OutlinedButton.styleFrom(
                //     side: const BorderSide(
                //         color: Color.fromARGB(255, 255, 95, 111)),
                //     minimumSize: const Size(double.infinity, 50),
                //     padding: const EdgeInsets.symmetric(vertical: 18),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: const Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Icons.upload,
                //           color: Color.fromARGB(255, 255, 95, 111)),
                //       SizedBox(width: 8),
                //       Text('Upload Assignment',
                //           style: TextStyle(
                //               color: Color.fromARGB(255, 255, 95, 111),
                //               fontSize: 20)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadAssignmentPage extends StatefulWidget {
  const UploadAssignmentPage({Key? key}) : super(key: key);

  @override
  _UploadAssignmentPageState createState() => _UploadAssignmentPageState();
}

class _UploadAssignmentPageState extends State<UploadAssignmentPage> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'ppt', 'pptx'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  void _uploadFile() {
    // Implement file upload logic here
    print('Uploading file: $_fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Upload Assignment',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload Assignment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      _fileName ?? 'Choose File...',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '.Pdf, .Ppt Are Supported',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '(Max File Size 5MB)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _fileName != null ? _uploadFile : null,
              child: Text('Upload'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
