/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_item_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

class ContactPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MapEntry<String, List<Contact>> contactEntry;
  final double indexHeight;
  final double dividerHeight;
  final double itemHeight;

  const ContactPersistentHeaderDelegate({
    @required this.contactEntry,
    @required this.indexHeight,
    @required this.dividerHeight,
    @required this.itemHeight,
  })  : assert(contactEntry != null),
        assert(indexHeight != null),
        assert(dividerHeight != null),
        assert(itemHeight != null);

  Widget _buildIndex(BuildContext context, String index) {
    return Container(
      height: indexHeight,
      alignment: Alignment.centerLeft,
      color: CupertinoDynamicColor.resolve(
        labelColor,
        context,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Text(
        index,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.label,
            context,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Contact> contacts) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(
          itemColor,
          context,
        ),
        border: Border(
          bottom: BorderSide(
            width: dividerHeight,
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
          ),
        ),
      ),
      child: WidgetGroup.separated(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            borderRadius: BorderRadius.zero,
            child: ContactItemWidget(
              contact: contact,
              height: itemHeight,
            ),
            onPressed: () {
              Navigator.pushNamed(context, RouteProvider.contactDetail);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
            height: dividerHeight,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var index = contactEntry.key;
    var contacts = contactEntry.value;
    return WidgetGroup(
      alignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      direction: Axis.vertical,
      divider: Container(
        color: CupertinoDynamicColor.resolve(
          separatorColor,
          context,
        ),
        height: dividerHeight,
      ),
      children: <Widget>[
        _buildIndex(context, index),
        ClipRect(
          child: Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            heightFactor: 1.0 - (shrinkOffset / _contentHeight).clamp(0.0, 1.0),
            child: _buildContent(context, contacts),
          ),
        ),
      ],
    );
  }

  int get _contactCount => contactEntry.value.length;

  double get _contentHeight => (itemHeight + dividerHeight) * _contactCount;

  @override
  double get maxExtent => minExtent + _contentHeight;

  @override
  double get minExtent => indexHeight + dividerHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
