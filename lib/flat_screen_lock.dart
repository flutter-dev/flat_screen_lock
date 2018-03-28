import 'package:flutter/material.dart';
import 'dart:async';

typedef void DeleteCode();
typedef Future<bool> CodeVerify(List<int> codes);

class FlatScreenLockPage extends StatefulWidget {
  ///解锁界面标题。
  final String title;

  ///数字密码长度。
  final int codeLength;

  ///解锁界面背景颜色。
  final Color backgroundColor;

  ///解锁界面前景色。
  final Color foregroundColor;

  ///数字密码校验回调，返回 true 表示密码验证正确，false 表示密码验证错误。
  final CodeVerify codeVerify;

  FlatScreenLockPage(
      {this.title,
      this.codeLength,
      this.backgroundColor,
      this.foregroundColor,
      this.codeVerify,})
      : assert(title != null),
        assert(codeLength > 0),
        assert(backgroundColor != null),
        assert(foregroundColor != null),
        assert(codeVerify != null);

  @override
  State<StatefulWidget> createState() {
    return new FlatScreenLockPageState();
  }
}

class FlatScreenLockPageState extends State<FlatScreenLockPage> {
  var _currentCodeLength = 0;
  var _inputCodes = <int>[];

  /// 0 输入状态
  /// 1 输入正确
  /// 2 输入错误
  var _currentState = 0;
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: widget.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Column(
        children: <Widget>[
          // 标题
          new Padding(
            padding: new EdgeInsets.only(top: 60.0),
            child: new Text(
              widget.title,
              style:
                  new TextStyle(color: widget.foregroundColor, fontSize: 20.0),
            ),
          ),
          //密码展位和删除
          new _CodePannel(
            codeLength: widget.codeLength,
            currentLength: _currentCodeLength,
            borderColor: widget.foregroundColor,
            deleteCode: _deleteCode,
            status: _currentState,
          ),

          ///数字按键
          new Row(children: <Widget>[
            _getButtonWithCode(1),
            _getButtonWithCode(2),
            _getButtonWithCode(3)
          ]),
          new Row(children: <Widget>[
            _getButtonWithCode(4),
            _getButtonWithCode(5),
            _getButtonWithCode(6)
          ]),
          new Row(children: <Widget>[
            _getButtonWithCode(7),
            _getButtonWithCode(8),
            _getButtonWithCode(9)
          ]),
          new Column(children: <Widget>[_getButtonWithCode(0)]),
        ],
      ),
    );
  }

  ///返回数字按键
  Widget _getButtonWithCode(int code) {
    return new SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 4,
      child: new FlatButton(
        child: new Text("$code",
            style:
                new TextStyle(color: widget.foregroundColor, fontSize: 25.0)),
        onPressed: () {
          _onCodeClick(code);
        },
      ),
    );
  }

  ///数字按钮响应
  _onCodeClick(int code) {
    if (_currentCodeLength < widget.codeLength) {
      setState(() {
        _currentCodeLength++;
        _inputCodes.add(code);
      });

      if (_currentCodeLength == widget.codeLength) {
        widget.codeVerify(_inputCodes).then((onValue) {
          if (onValue) {
            setState(() {
              _currentState = 1;
            });
          } else {
            _currentState = 2;
            new Timer(new Duration(milliseconds: 1000), () {
              setState(() {
                _currentState = 0;
                _currentCodeLength = 0;
                _inputCodes.clear();
              });
            });
          }
        });
      }
    }
  }

  _deleteCode() {
    setState(() {
      if (_currentCodeLength > 0) {
        _currentState = 0;
        _currentCodeLength--;
        _inputCodes.removeAt(_currentCodeLength);
      }
    });
  }
}

///数字占位及删除按钮
class _CodePannel extends StatelessWidget {
  final codeLength;
  final currentLength;
  final borderColor;
  final H = 12.0;
  final W = 12.0;
  final DeleteCode deleteCode;
  final int status;
  _CodePannel(
      {this.codeLength,
      this.currentLength,
      this.borderColor,
      this.deleteCode,
      this.status})
      : assert(codeLength > 0),
        assert(currentLength >= 0),
        assert(currentLength <= codeLength),
        assert(deleteCode != null),
        assert(status == 0 || status == 1 || status == 2);

  @override
  Widget build(BuildContext context) {
    ///数字占位
    var circles = <Widget>[];
    var color = borderColor;
    if (status == 1) {
      color = Colors.green.shade500;
    }
    if (status == 2) {
      color = Colors.red.shade500;
    }
    for (int i = 1; i <= codeLength; i++) {
      if (i > currentLength) {
        circles.add(new SizedBox(
            width: W,
            height: H,
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: color, width: 1.0)),
            )));
      } else {
        circles.add(new SizedBox(
            width: W,
            height: H,
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: color, width: 1.0),
                  color: color),
            )));
      }
    }
    var circlesRow = new SizedBox.fromSize(
        size: new Size(20.0 * codeLength, H),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: circles,
        ));

    var line = new Container(
        width: 2.0,
        height: H,
        decoration: new BoxDecoration(color: borderColor),
        margin: new EdgeInsetsDirectional.only(start: W, end: W));
    ///删除按钮
    var deleteBtn = new GestureDetector(
      child: new Icon(
        Icons.backspace,
        color: borderColor,
        size: W + 8,
      ),
      onTap: () {
        deleteCode();
      },
    );
    return new SizedBox.fromSize(
      size: new Size(MediaQuery.of(context).size.width, 80.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[circlesRow, line, deleteBtn]),
    );
  }
}
