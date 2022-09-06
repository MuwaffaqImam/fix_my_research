import 'package:flutter/material.dart';

import '../utils/moofiy_color.dart';

class IExtractLogo extends StatelessWidget {
  const IExtractLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: const TextSpan(
            text: 'Fix My English',
            style: TextStyle(
                color: MoofiyColors.colorPrimaryRedCaramel,
                fontSize: 77,
                height: 0.8,
                fontFamily: 'Eczar',
                fontWeight: FontWeight.bold),
            children: [
          TextSpan(
            text: '\npowered by IExtract',
            style: TextStyle(
                color: MoofiyColors.colorPrimaryRedCaramel,
                fontSize: 22,
                height: 0.1,
                fontFamily: 'Eczar',
                fontWeight: FontWeight.bold),
          )
        ]));
  }
}
