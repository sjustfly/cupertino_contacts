/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(CupertinoContactsApp());
}

class CupertinoContactsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    return CupertinoApp(
      title: '通讯录',
      theme: themeData.copyWith(
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        textTheme: textTheme.copyWith(
          textStyle: textTheme.textStyle.copyWith(
            height: 1.5,
          ),
        ),
      ),
      home: CupertinoContactsPage(),
    );
  }
}
