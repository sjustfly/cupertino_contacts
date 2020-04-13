/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/13.
///
/// 自定义标签列表
const Duration _kDuration = Duration(milliseconds: 300);

class CustomLabelGroupWidet extends StatefulWidget {
  final List<Selection> selections;
  final SelectionType selectionType;
  final FocusNode queryFocusNode;
  final Selection selectedSelection;
  final bool hasQueryText;
  final bool isEditMode;

  const CustomLabelGroupWidet({
    Key key,
    @required this.queryFocusNode,
    @required this.selectionType,
    @required this.selections,
    this.selectedSelection,
    this.hasQueryText = false,
    this.isEditMode = false,
  })  : assert(selectionType != null),
        assert(selections != null),
        assert(hasQueryText != null),
        super(key: key);

  @override
  _CustomLabelGroupWidetState createState() => _CustomLabelGroupWidetState();
}

class _CustomLabelGroupWidetState extends State<CustomLabelGroupWidet> with SingleTickerProviderStateMixin {
  final _customLabelFocusNode = FocusNode();
  final _customLabelController = TextEditingController();

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    widget.queryFocusNode.addListener(_onQueryFocusChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: _kDuration,
      value: _isHideAddCustomLabelButton ? 0.0 : 1.0,
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        setState(() {});
      }
    });
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _customLabelFocusNode.addListener(() {
      setState(() {});
      var text = _customLabelController.text;
      if (!_customLabelFocusNode.hasFocus && text != null && text.isNotEmpty) {
        _customLabelController.clear();
        var selection = selections.addCustomSelection(widget.selectionType, text);
        if (selection != null && !widget.selections.contains(selection)) {
          widget.selections.insert(0, selection);
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(CustomLabelGroupWidet oldWidget) {
    if (widget.queryFocusNode != oldWidget.queryFocusNode) {
      oldWidget.queryFocusNode.removeListener(_onQueryFocusChanged);
      widget.queryFocusNode.addListener(_onQueryFocusChanged);
    }
    if (widget.hasQueryText != oldWidget.hasQueryText || widget.isEditMode != oldWidget.isEditMode) {
      _onQueryFocusChanged();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.queryFocusNode.removeListener(_onQueryFocusChanged);
    _customLabelController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _isHideAddCustomLabelButton {
    return widget.queryFocusNode.hasFocus || widget.hasQueryText || widget.isEditMode;
  }

  _onQueryFocusChanged() {
    if (_isHideAddCustomLabelButton) {
      _animationController.animateTo(0.0);
    } else {
      _animationController.animateTo(1.0);
    }
  }

  List<Widget> _buildCustomLabelHeaders() {
    var status = _animationController.status;
    var value = _animationController.value;
    if ((status == AnimationStatus.completed || status == AnimationStatus.dismissed) && value == 0) {
      return null;
    }
    final inEditMode = _customLabelFocusNode.hasFocus;
    return [
      SizeTransition(
        sizeFactor: _animation,
        axisAlignment: -1,
        child: AnimatedCrossFade(
          firstChild: LabelItemButton(
            text: '添加自定标签',
            onPressed: () {
              _customLabelFocusNode.requestFocus();
            },
          ),
          secondChild: CustomLabelTextField(
            controller: _customLabelController,
            focusNode: _customLabelFocusNode,
            onEditingComplete: _onEditingComplete,
          ),
          crossFadeState: inEditMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: _kDuration,
        ),
      ),
    ];
  }

  _onEditingComplete() {
    var text = _customLabelController.text;
    if (text != null && text.isNotEmpty) {
      _customLabelController.clear();
      var selection = selections.addCustomSelection(widget.selectionType, text);
      if (selection != null) {
        Navigator.pop(context, selection);
      }
    } else {
      _customLabelFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DeleteableSelectionGroupWidget(
      selections: widget.selections,
      selectedSelection: widget.isEditMode ? null : widget.selectedSelection,
      headers: _buildCustomLabelHeaders(),
      hasDeleteButton: widget.isEditMode,
      onItemPressed: (value) {
        if (widget.isEditMode) {
          return;
        }
        Navigator.pop(context, value);
      },
      onDeletePressed: (value) {
        selections.removeCustomSelection(widget.selectionType, value);
        widget.selections.remove(value);
        setState(() {});
      },
    );
  }
}