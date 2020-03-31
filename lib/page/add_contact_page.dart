/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/add_contact_choose_ring_tone_button.dart';
import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_button.dart';
import 'package:cupertinocontacts/widget/add_contact_info_text_field.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_text_field.dart';
import 'package:cupertinocontacts/widget/add_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
class AddContactPage extends StatefulWidget {
  const AddContactPage({Key key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('新建联系人'),
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        border: null,
        leading: CupertinoButton(
          child: Text('取消'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        trailing: CupertinoButton(
          child: Text('完成'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return 64.0;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: AddContactPersistentHeaderDelegate(),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            AddContactGroupContainer(
              itemCount: 3,
              itemBuilder: (context, index) {
                return AddContactNormalTextField();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactChooseRingToneButton(),
            SizedBox(
              height: 40,
            ),
            AddContactChooseRingToneButton(),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactGroupContainer(
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index < 1) {
                  return AddContactInfoTextField();
                }
                return AddContactInfoButton();
              },
            ),
            SizedBox(
              height: 40,
            ),
            AddContactRemarksTextField(),
            SizedBox(
              height: 40,
            ),
            CupertinoButton(
              minSize: 44,
              padding: EdgeInsets.only(
                left: 16,
                right: 10,
              ),
              borderRadius: BorderRadius.zero,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '添加信息栏',
                  style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(
                        fontSize: 15,
                      ),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
