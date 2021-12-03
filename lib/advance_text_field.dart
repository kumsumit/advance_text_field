library advance_text_field;

import 'package:flutter/material.dart';

class AdvanceTextField extends StatefulWidget {
  /// The widget's [width] and [height].
  final double width, height;

  /// The widget's [backgroundColor] and [color].
  /// Colors of [textColor] and [textHintColor]
  final Color backgroundColor, color, textColor, textHintColor;

  /// Style of text hint[textHintStyle] and text[textStyle].
  final TextStyle textHintStyle, textStyle;

  /// Type of AdvanceTextField with two option:
  /// [AdvanceTextFieldType.EDIT],
  /// [AdvanceTextFieldType.EDIT] for initial state.
  final AdvanceTextFieldType type;

  /// a widget will using for Edit Button. it can be any Flutter [Widget]s.
  final Widget editLabel;

  /// a widget will using for Save Button. it can be any Flutter [Widget]s.
  final Widget saveLabel;

  /// an instance of [Duration] for Duration of animations.
  final Duration animationDuration;

  /// Keyboard type of [AdvanceTextField].
  final TextInputType keyboardType;

  /// Text hint and text of [AdvanceTextField].
  final String textHint, text;

  /// Text editing controller.
  final TextEditingController controller;

  /// Call when tap on [editLabel].
  final Function onEditTap;

  /// Call when tap on [saveLabel].
  final Function(String text) onSaveTap;

  const AdvanceTextField(
      {Key? key,
        required this.width,
        this.height = 60.0,
        this.backgroundColor = Colors.blueAccent,
        this.textColor = Colors.black87,
        this.textHintColor = Colors.grey,
        this.color = Colors.white,
        required this.type,
        this.animationDuration = const  Duration(milliseconds: 500),
        required this.editLabel,
        required this.saveLabel,
        this.keyboardType = TextInputType.text,
        required this.textHint,
        required this.text,
        required this.onEditTap,
        required this.onSaveTap,
        required this.controller,
        this.textHintStyle = const TextStyle(color: Colors.grey),
        this.textStyle = const TextStyle(color: Colors.black87)})
      : super(key: key);

  @override
  _AdvanceTextFieldState createState() => _AdvanceTextFieldState();
}

class _AdvanceTextFieldState extends State<AdvanceTextField> {
  /// Right widget is [widget.saveLabel] and left widget is [widget.editLabel].
  Widget _leftWidget = Container(), _rightWidget = Container();

  TextEditingController _editingController = TextEditingController();

  AdvanceTextFieldType _type = AdvanceTextFieldType.EDIT;

  /// Use when border should be fully rounded(circular).
  final _roundedCorner = 10000.0;

  /// Radius's of [AnimatedContainer] corners.
  double _topRightRadius = 10000.0;
  double _topLeftRadius =10000.0;
  double _bottomLeftRadius = 10000.0;
  double _bottomRightRadius = 10000.0;

  /// Width of [AnimatedContainer].
  double _innerContainerWidth=10.0;

  /// Width of widget container.
  double _widgetWidth=20.0;

  bool _enable =false;

  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.center;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _make(widget.type);
      _editingController.text = widget.text;
    });
    _editingController = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _widgetWidth = widget.width ;
    return SizedBox(
      width: _widgetWidth,
      height: widget.height,
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius:
                    BorderRadius.all(Radius.circular(_roundedCorner))),
              )),
          Positioned(left: 0.0, top: 0.0, bottom: 0.0, child: _leftWidget),
          Positioned(right: 0.0, top: 0.0, bottom: 0.0, child: _rightWidget),
          Positioned.fill(
              child: Row(
                mainAxisAlignment: _mainAxisAlignment,
                children: [
                  AnimatedContainer(
                    onEnd: () {
                      _make(_type);
                    },
                    margin: const EdgeInsets.all(2.0),
                    width: widget.width - 4,
                    height: widget.height,
                    duration:
                    widget.animationDuration,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.only(
                          bottomLeft:
                          Radius.circular(_bottomLeftRadius),
                          bottomRight:
                          Radius.circular(_bottomRightRadius),
                          topLeft:
                          Radius.circular(_topLeftRadius),
                          topRight:
                          Radius.circular(_topRightRadius)),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _editingController,
                        textInputAction: TextInputAction.done,
                        keyboardType: widget.keyboardType,
                        textAlign: TextAlign.center,
                        enabled: _enable,
                        onChanged: (value) {},
                        style:
                        widget.textStyle ,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.textHint,
                            hintStyle: widget.textHintStyle
                                ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  /// Change widget state to
  /// [AdvanceTextFieldType.EDIT] or [AdvanceTextFieldType.SAVE].
  _make(AdvanceTextFieldType type) {
    _type = type;
    setState(() {
      if (type == AdvanceTextFieldType.EDIT) {
        _leftWidget = _editWidget();
        _mainAxisAlignment = MainAxisAlignment.end;
        _innerContainerWidth = _widgetWidth - 55;
        _topLeftRadius = 0.0;
        _bottomLeftRadius = _roundedCorner;
        _topRightRadius = _roundedCorner;
        _bottomRightRadius = _roundedCorner;
        _enable = false;
      }
      if (type == AdvanceTextFieldType.SAVE) {
        _rightWidget = _saveWidget();
        _mainAxisAlignment = MainAxisAlignment.start;
        _innerContainerWidth = _widgetWidth - 55;
        _topLeftRadius = _roundedCorner;
        _bottomLeftRadius = _roundedCorner;
        _topRightRadius = 0.0;
        _bottomRightRadius = _roundedCorner;
        _enable = true;
      }
    });
  }

  /// Inner Container fill when change type of widget.
  fill() {
    setState(() {
      _innerContainerWidth = _widgetWidth - 4;
      _topLeftRadius = _roundedCorner;
      _bottomLeftRadius = _roundedCorner;
      _topRightRadius = _roundedCorner;
      _bottomRightRadius = _roundedCorner;
    });
  }

  /// Save widget [_rightWidget].
  Widget _saveWidget() {
    return InkWell(
      onTap: () {
        _type = AdvanceTextFieldType.EDIT;
        fill();
        widget.onSaveTap(_editingController.text);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 20.0,
        ),
        child: Center(
          child: widget.saveLabel,
        ),
      ),
    );
  }

  /// Edit widget [_leftWidget].
  Widget _editWidget() {
    return InkWell(
      onTap: () {
        _type = AdvanceTextFieldType.SAVE;
        fill();
      widget.onEditTap();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 20.0,
        ),
        child: Center(
          child: widget.editLabel,
        ),
      ),
    );
  }
}

/// Type of [AdvanceTextField] states
enum AdvanceTextFieldType { EDIT, SAVE, FILL }
