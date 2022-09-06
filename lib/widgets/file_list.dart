import 'package:flutter/material.dart';
import 'package:swp/utils/moofiy_color.dart';
import '../utils/analysis_data.dart';

class FileListController {
  late Function(List<Future<AnalyzedText>>) addNewFiles;
  List<AnalyzedText?> allAnalyzes = [];

  void addFiles(List<Future<AnalyzedText>> filesWithAnalysis) {
    addNewFiles(filesWithAnalysis);
  }
}

class FileListWidget extends StatefulWidget {
  final Function(AnalyzedText analysis) onSelected;

  final FileListController controller;
  final List<Future<AnalyzedText>> sequentialRequests;

  const FileListWidget(
      {Key? key,
      required this.controller,
      required this.sequentialRequests,
      required this.onSelected})
      : super(key: key);

  @override
  State<FileListWidget> createState() => _FileListWidget();
}

class _FileListWidget extends State<FileListWidget> {
  late List<AnalyzedText?> analyzedTexts;
  AnalyzedText? selected;

  @override
  void initState() {
    super.initState();
    analyzedTexts = [];
    widget.controller.allAnalyzes = analyzedTexts;
    for (var req in widget.sequentialRequests) {
      req.then((value) {
        selected ??= value;
        int nullIndex = analyzedTexts.indexOf(null);
        analyzedTexts.insert(nullIndex, value);
        analyzedTexts.remove(null);
        setState(() {});
      });
      analyzedTexts.add(null);
    }
    widget.controller.addNewFiles = _addNewFiles;
  }

  void _addNewFiles(List<Future<AnalyzedText>> filesWithAnalysis) {
    for (var fileAnalysis in filesWithAnalysis) {
      widget.sequentialRequests.add(fileAnalysis);
      fileAnalysis.then((value) {
        int nullIndex = analyzedTexts.indexOf(null);
        analyzedTexts.insert(nullIndex, value);
        analyzedTexts.remove(null);
        setState(() {});
      });
      analyzedTexts.add(null);
    }
    setState(() {});
  }

  void _removeFile(AnalyzedText textToRemove) {
    analyzedTexts.remove(textToRemove);
    if (selected == textToRemove && analyzedTexts.isNotEmpty) {
      selected = analyzedTexts.first;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(12),
        color: const Color(0xFFFBFDF7),
        child: analyzedTexts.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: const Icon(
                              Icons.upload_file,
                              size: 60,
                              color: MoofiyColors.colorTextSmoothBlack,
                            ),
                          )),
                      Expanded(
                        flex: 5,
                        child: Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              "Upload files to view analyses.",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Merriweather",
                                  color: MoofiyColors.colorTextSmoothBlack),
                            )),
                      ),
                    ]),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (analyzedTexts[index] == null) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text(
                        "Loading...",
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Merriweather"),
                      ),
                    );
                  } else {
                    return Card(
                        color: (analyzedTexts[index] == selected)
                            ? const Color.fromARGB(255, 205, 231, 201)
                            : MoofiyColors.colorSecondaryLightGreenPlant,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected = analyzedTexts[index];
                            });
                            widget.onSelected(analyzedTexts[index]!);
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.picture_as_pdf,
                              size: 30,
                              color: (analyzedTexts[index] == selected)
                                  ? const Color.fromARGB(255, 23, 54, 35)
                                  : MoofiyColors.colorSecondaryGreenPlant,
                            ),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  size: 30,
                                  color: (analyzedTexts[index] == selected)
                                      ? const Color.fromARGB(255, 23, 54, 35)
                                      : MoofiyColors.colorSecondaryGreenPlant,
                                ),
                                onPressed: () {
                                  analyzedTexts[index]!.saveAsCSV();
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: (analyzedTexts[index] == selected)
                                      ? const Color.fromARGB(255, 23, 54, 35)
                                      : MoofiyColors.colorSecondaryGreenPlant,
                                ),
                                onPressed: () {
                                  _removeFile(analyzedTexts[index]!);
                                },
                              ),
                            ]),
                            title: Text(
                              analyzedTexts[index]!.filename!,
                              style: TextStyle(
                                  color: (analyzedTexts[index] == selected)
                                      ? const Color.fromARGB(255, 23, 54, 35)
                                      : MoofiyColors.colorSecondaryGreenPlant,
                                  fontSize: 18,
                                  fontFamily: "Merriweather"),
                            ),
                          ),
                        ));
                  }
                },
                itemCount: analyzedTexts.length,
              ),
      ),
    );
  }
}
