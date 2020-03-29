/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/26.
///
/// 联系人列表item
class ContactItemWidget extends StatelessWidget {
  final Contact contact;
  final double height;

  const ContactItemWidget({
    Key key,
    @required this.contact,
    @required this.height,
  })  : assert(contact != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var phones = contact.phones;
    var phone;
    if (phones != null && phones.isNotEmpty) {
      phone = phones.first.value;
    }
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      color: CupertinoDynamicColor.resolve(
        itemColor,
        context,
      ),
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.start,
        spacing: 10,
        children: <Widget>[
          CupertinoCircleAvatar.memory(
            bytes: contact.avatar,
            assetName: Images.ic_default_avatar,
            size: 65,
          ),
          Expanded(
            child: WidgetGroup.spacing(
              alignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              direction: Axis.vertical,
              spacing: 8,
              children: <Widget>[
                Text(
                  contact.displayName ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.label,
                      context,
                    ),
                  ),
                ),
                Text(
                  phone ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondaryLabel,
                      context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
