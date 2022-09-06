import 'package:flutter/material.dart';
import '../pages/main_page_files.dart';
import '../pages/starting_page.dart';
import '../pages/main_page_text.dart';

///The root widget to display appropriate page widget depending on current page.
class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);

  @override
  State<RootWidget> createState() => _RootWidget();
}

//Application pages
enum AppPages { startPage, mainPageText, mainPageFiles }

///Class that represents state controll of root widget
class _RootWidget extends State<RootWidget> {
  //Current application page
  late AppPages appState;

  //Start page widget
  late StartPageWidget startPage;

  //Main page widget
  late MainPageWidget mainPageText;

  //Main page with files widget
  late MainPageFilesWidget mainPageFiles;
  @override
  void initState() {
    super.initState();

    //The inital page is start page
    appState = AppPages.startPage;

    //Create start page widget, and listen for uploading event
    startPage = createStartPage();

    //Create main page widget
    mainPageText = createMainPage();
    mainPageFiles = createMainFilesPage();
  }

  //123
  @override
  Widget build(BuildContext context) {
    //Depending on current application page load appropriate page widget
    switch (appState) {
      case AppPages.startPage:
        return startPage;
      case AppPages.mainPageText:
        return mainPageText;
      case AppPages.mainPageFiles:
        return mainPageFiles;
    }
  }

  ///Creates starting page with required properties
  StartPageWidget createStartPage() {
    return StartPageWidget(
      onFileUploaded: (requests, mode) {
        setState(() {
          //When user uploads files switch to main page
          appState =
              mode == "text" ? AppPages.mainPageText : AppPages.mainPageFiles;

          //Recreate pages to update values
          mainPageText = createMainPage();
          mainPageFiles = createMainFilesPage();

          //Provide all requests made in start page to main page
          mainPageText.addManyAnalyses(requests);
          mainPageFiles.addManyAnalyses(requests);
        });
      },
    );
  }

  ///Creates text main page with required properties
  MainPageWidget createMainPage() {
    return MainPageWidget(
      rollbackAction: () {
        setState(() {
          appState = AppPages.startPage;
        });
      },
    );
  }

  ///Creates files main page with required properties
  MainPageFilesWidget createMainFilesPage() {
    return MainPageFilesWidget(
      rollbackAction: () {
        setState(() {
          appState = AppPages.startPage;
        });
      },
    );
  }
}
