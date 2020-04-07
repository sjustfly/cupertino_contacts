/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';
import 'dart:typed_data';

import 'package:cupertinocontacts/constant/selection.dart' as selection;
import 'package:cupertinocontacts/enums/contact_item_type.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/collections.dart';
import 'package:cupertinocontacts/widget/edit_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';

class EditContactPresenter extends Presenter<EditContactPage> implements EditContactOperation {
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  final baseInfos = List<EditableContactInfo>();
  final itemMap = LinkedHashMap<ContactItemType, ContactInfo>();

  Uint8List _avatar;

  Contact _initialContact;

  @override
  Uint8List get avatar => _avatar;

  @override
  bool get isChanged => _initialContact != value || !Collections.equals(_avatar, _initialContact.avatar);

  @override
  void initState() {
    _initialContact = widget.contact ?? Contact();
    _initialContact.familyName ??= '';
    _initialContact.givenName ??= '';
    _initialContact.company ??= '';
    _initialContact.phones ??= [];
    _initialContact.emails ??= [];
    _initialContact.urls ??= [];
    _initialContact.note ??= '';

    _avatar = _initialContact.avatar;

    baseInfos.add(EditableContactInfo(
      name: '姓氏',
      value: _initialContact.familyName,
    ));
    baseInfos.add(EditableContactInfo(
      name: '名字',
      value: _initialContact.givenName,
    ));
    baseInfos.add(EditableContactInfo(
      name: '公司',
      value: _initialContact.company,
    ));
    itemMap[ContactItemType.phone] = ContactInfoGroup<EditableItem>(
      name: '电话',
      items: _initialContact.phones?.map((e) {
        return EditableItem(
          label: e.label,
          value: e.value,
        );
      })?.toList(),
      selections: selection.phoneSelections,
    );
    itemMap[ContactItemType.email] = ContactInfoGroup<EditableItem>(
      name: '电子邮件',
      items: _initialContact.emails?.map((e) {
        return EditableItem(
          label: e.label,
          value: e.value,
        );
      })?.toList(),
      selections: selection.emailSelections,
    );
    itemMap[ContactItemType.phoneRinging] = DefaultSelectionContactInfo(
      name: '电话铃声',
    );
    itemMap[ContactItemType.smsRinging] = DefaultSelectionContactInfo(
      name: '短信铃声',
    );
    itemMap[ContactItemType.url] = ContactInfoGroup<EditableItem>(
      name: 'URL',
      items: _initialContact.urls?.map((e) {
        return EditableItem(
          label: e.label,
          value: e.value,
        );
      })?.toList(),
      selections: selection.urlSelections,
    );
    itemMap[ContactItemType.address] = ContactInfoGroup<EditableItem>(
      name: '地址',
      items: List<EditableItem>(),
      selections: selection.addressSelections,
    );
    itemMap[ContactItemType.birthday] = ContactInfoGroup<EditableItem>(
      name: '生日',
      items: List<EditableItem>(),
      selections: selection.birthdaySelections,
    );
    itemMap[ContactItemType.date] = ContactInfoGroup<EditableItem>(
      name: '日期',
      items: List<EditableItem>(),
      selections: selection.dateSelections,
    );
    itemMap[ContactItemType.relatedParty] = ContactInfoGroup<EditableItem>(
      name: '关联人',
      items: List<EditableItem>(),
      selections: selection.relatedPartySelections,
    );
    itemMap[ContactItemType.socialData] = ContactInfoGroup<EditableItem>(
      name: '个人社交资料',
      items: List<EditableItem>(),
      selections: selection.socialDataSelections,
    );
    itemMap[ContactItemType.instantMessaging] = ContactInfoGroup<EditableItem>(
      name: '即时信息',
      items: List<EditableItem>(),
      selections: selection.instantMessagingSelections,
    );
    itemMap[ContactItemType.remarks] = MultiEditableContactInfo(
      name: '备注',
      value: _initialContact.note,
    );
    itemMap[ContactItemType.addInfo] = NormalSelectionContactInfo(
      name: '添加信息栏',
    );

    baseInfos.forEach((element) => element.addListener(notifyListeners));
    itemMap.values.forEach((element) => element.addListener(notifyListeners));
    super.initState();
  }

  @override
  void dispose() {
    _listeners = null;
    baseInfos.forEach((element) => element.dispose());
    itemMap.values.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  onEditAvatarPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        EditContactAvatarPage(
          avatar: _avatar,
        ),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      if (Collections.equals(_avatar, value)) {
        return;
      }
      _avatar = value;
      notifyDataSetChanged();
      notifyListeners();
    });
  }

  @override
  onCancelPressed() {
    if (!isChanged) {
      Navigator.maybePop(context);
    } else {
      showGriveUpEditDialog(context).then((value) {
        if (value ?? false) {
          Navigator.maybePop(context);
        }
      });
    }
  }

  @override
  onDonePressed() {
    Future<Contact> future;
    if (value.identifier == null) {
      future = Contacts.addContact(value);
    } else {
      future = Contacts.updateContact(value);
    }
    future.then((value) {
      if (widget.contact != null) {
        Navigator.pop(context, value);
      } else {
        Navigator.pushReplacement(
          context,
          RouteProvider.buildRoute(
            ContactDetailPage(
              identifier: value.identifier,
              contact: value,
            ),
          ),
        );
      }
    }).catchError((error) {
      showText(error.toString(), context);
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners?.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners?.remove(listener);
  }

  @override
  Contact get value {
    var phones = _convert(itemMap[ContactItemType.phone]);
    var emails = _convert(itemMap[ContactItemType.email]);
    var urls = _convert(itemMap[ContactItemType.url]);
    final contactMap = {
      'identifier': _initialContact.identifier,
      'avatar': _avatar,
      'prefix': _initialContact.prefix,
      'suffix': _initialContact.suffix,
      'middleName': _initialContact.middleName,
      'displayName': _initialContact.displayName,
      'familyName': baseInfos[0].value ?? '',
      'givenName': baseInfos[1].value ?? '',
      'company': baseInfos[2].value ?? '',
      'jobTitle': _initialContact.jobTitle,
      'phones': phones,
      'emails': emails,
      'urls': urls,
      'note': itemMap[ContactItemType.remarks].value ?? '',
    };
    var contact = Contact.fromMap(contactMap);
    contact.displayName = _initialContact.displayName;
    contact.dates = _initialContact.dates;
    contact.lastModified = _initialContact.lastModified;
    contact.socialProfiles = _initialContact.socialProfiles;
    contact.postalAddresses = _initialContact.postalAddresses;
    return contact;
  }

  List<Map> _convert(ContactInfoGroup<EditableItem> infoGroup) {
    return infoGroup.value.where((element) {
      return element.value != null && element.value.isNotEmpty;
    }).map((e) {
      return {"label": e.label, "value": e.value};
    }).toList();
  }

  @protected
  @visibleForTesting
  void notifyListeners() {
    if (_listeners != null) {
      final List<VoidCallback> localListeners = List<VoidCallback>.from(_listeners);
      for (final VoidCallback listener in localListeners) {
        try {
          if (_listeners.contains(listener)) listener();
        } catch (exception) {}
      }
    }
  }
}
