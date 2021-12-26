// https://www.egao-inc.co.jp/programming/flutter_custom_dialog/
import 'package:flutter/material.dart';
import 'package:out_lights/extention_color.dart';

/*
 * モーダルオーバーレイ
 */
class ModalOverlay extends ModalRoute<void> {
// ダイアログ内のWidget
  final Widget contents;

// Androidのバックボタンを有効にするか
  final bool isAndroidBackEnable;

  ModalOverlay(this.contents, {this.isAndroidBackEnable = true}) : super();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => false;
  @override
  Color get barrierColor => Colors.transparent;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      color: Colors.black.stackOnTop(Colors.yellow.shade500.withOpacity(0.5)),
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return WillPopScope(
      child: contents,
      onWillPop: () {
        return Future(() => isAndroidBackEnable);
      },
    );
  }
}
