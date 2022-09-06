import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swp/widgets/file_list.dart';
import '../utils/analysis_data.dart';
import '../utils/moofiy_color.dart';
import '../widgets/analyzed_text_widget.dart';
import '../utils/api_interactions.dart';
import 'package:file_picker/file_picker.dart';

///Main page widget. Works with futures to show text analyses
class MainPageFilesWidget extends StatefulWidget {
  //List with all analyses that user has
  final List<Future<AnalyzedText>> analysisRequests = [];
  final VoidCallback rollbackAction;

  MainPageFilesWidget({Key? key, required this.rollbackAction})
      : super(key: key);

  ///Adds new analysis to list. Needs future of AnalysisData [request]
  void addNewAnalysis(Future<AnalyzedText> request) {
    analysisRequests.add(request);
  }

  ///Adds multiple analysis to list. Needs list of futures of AnalysisData [request]
  void addManyAnalyses(List<Future<AnalyzedText>> requests) {
    for (Future<AnalyzedText> request in requests) {
      analysisRequests.add(request);
    }
  }

  @override
  State<MainPageFilesWidget> createState() => _MainPageFilesWidget();
}

///Class that represents state control of TextPageWidget
class _MainPageFilesWidget extends State<MainPageFilesWidget> {
  FileListController fileController = FileListController();
  AnalyzedTextController analyzedTextController = AnalyzedTextController();

  bool canUpdateText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_sharp,
              color: MoofiyColors.colorPrimaryRedCaramel,
              size: 34,
            ),
            onPressed: () {
              widget.analysisRequests.clear();
              widget.rollbackAction();
            },
          ),
          title: const Center(
            child: Text(
              'Fix My English',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 37),
            ),
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                fit: BoxFit.cover,
                "assets/clouds_2.svg",
                color: const Color.fromARGB(255, 222, 207, 180),
              ),
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      ///decoration: const BoxDecoration(),
                      //color: const Color(0xFFFBFDF7),
                      padding: const EdgeInsets.all(12),
                      //margin: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: AnalyzedTextWidget(
                        analysis: widget.analysisRequests.first,
                        controller: analyzedTextController,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Container(
                              alignment: Alignment.topRight,
                              //widget.analysisRequests.first
                              child: FileListWidget(
                                controller: fileController,
                                sequentialRequests: widget.analysisRequests,
                                onSelected: (AnalyzedText analyzedText) {
                                  analyzedTextController
                                      .changeDirectCallback(analyzedText);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                                allowMultiple: true,
                                                type: FileType.custom,
                                                allowedExtensions: ['pdf']);
                                        if (result != null) {
                                          fileController.addNewFiles(
                                              await sendFilesToIExtract(
                                                  result));
                                        }
                                      },
                                      label: const Text(
                                        "Upload more",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      icon: const Icon(Icons.upload, size: 40),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        for (var curAnalysis
                                            in fileController.allAnalyzes) {
                                          if (curAnalysis != null) {
                                            curAnalysis.saveAsCSV();
                                          }
                                        }
                                      },
                                      label: const Text(
                                        "Export ALL to CSV",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      icon: const Icon(Icons.arrow_downward,
                                          size: 40),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
