import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swp/utils/moofiy_color.dart';
import '../utils/analysis_data.dart';
import '../widgets/analyzed_text_widget.dart';
import '../utils/api_interactions.dart';

///Main page widget. Works with futures to show text analyses
class MainPageWidget extends StatefulWidget {
  //List with all analyses that user has
  final List<Future<AnalyzedText>> analysisRequests = [];
  final VoidCallback rollbackAction;

  MainPageWidget({Key? key, required this.rollbackAction}) : super(key: key);

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
  State<MainPageWidget> createState() => _MainPageWidget();
}

///Class that represents state control of TextPageWidget
class _MainPageWidget extends State<MainPageWidget> {
  bool canUpdateText = true;

  @override
  Widget build(BuildContext context) {
    AnalyzedTextController analyzedTextController = AnalyzedTextController();
    TextEditingController textEditingController = TextEditingController();

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
                              child: FutureBuilder(
                                future: widget.analysisRequests.first,
                                builder: (BuildContext context,
                                    AsyncSnapshot<AnalyzedText> snapshot) {
                                  if (snapshot.hasData) {
                                    if (canUpdateText) {
                                      textEditingController.text =
                                          snapshot.data!.rawText;
                                      canUpdateText = false;
                                    }
                                    return Card(
                                      elevation: 6,
                                      child: TextFormField(
                                        controller: textEditingController,
                                        minLines: null,
                                        maxLines: null,
                                        expands: true,
                                        keyboardType: TextInputType.multiline,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Merriweather',
                                        ),
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(2.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                style: BorderStyle.solid),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(2.0)),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                style: BorderStyle.solid),
                                          ),
                                          border: const OutlineInputBorder(),
                                          hintText:
                                              "Enter the text for analysis...",
                                        ),
                                        cursorColor:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      color: const Color(0xFFFBFDF7),
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    );
                                  }
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
                                      onPressed: () {
                                        analyzedTextController
                                            .changeAnalysisFuture(
                                          sendToIExtract(
                                              textEditingController.text),
                                        );
                                      },
                                      label: const Text(
                                        "Analyze the text",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      icon: const Icon(Icons.short_text,
                                          size: 40),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (analyzedTextController
                                                .currentAnalysis !=
                                            null) {
                                          analyzedTextController
                                              .currentAnalysis!
                                              .saveAsCSV();
                                        }
                                      },
                                      label: const Text(
                                        "Export CSV",
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
