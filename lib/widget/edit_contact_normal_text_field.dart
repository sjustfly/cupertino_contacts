/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 新建联系人-默认输入框
class EditContactNormalTextField extends StatelessWidget {
  final EditableContactInfo info;

  const EditContactNormalTextField({
    Key key,
    @required this.info,
  })  : assert(info != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: CupertinoTextField(
        controller: info.controller,
        placeholder: info.name,
        placeholderStyle: TextStyle(
          color: CupertinoDynamicColor.resolve(
            placeholderColor,
            context,
          ),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemBackground,
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 10,
        ),
        clearButtonMode: OverlayVisibilityMode.editing,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}