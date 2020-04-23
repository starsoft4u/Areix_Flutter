import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommonPage extends StatefulWidget {
  // Actionbar
  final String title;
  final bool isAppBarTransparent;
  final List<Widget> actions;

  // Body
  final EdgeInsetsGeometry padding;
  final Widget child;

  // Footer
  final bool hasFloatButton;
  final bool expandBottom;

  // Indicator
  final bool showIndicator;

  CommonPage({
    Key key,
    String title,
    this.isAppBarTransparent = false,
    List<Widget> actions,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    this.hasFloatButton = true,
    bool expandBottom,
    this.showIndicator = false,
    @required this.child,
  })  : assert(child != null),
        actions = actions ?? [],
        title = title ?? (isAppBarTransparent ? '' : 'Areix'),
        expandBottom = expandBottom ?? !hasFloatButton,
        padding = (expandBottom ?? !hasFloatButton) ? padding : padding.add(EdgeInsets.only(bottom: 80)),
        super(key: key);

  @override
  _CommonPageState createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  @override
  Widget build(BuildContext context) {
    final _padding = widget.isAppBarTransparent ? widget.padding.add(EdgeInsets.only(top: 24)) : widget.padding;
    List<Widget> children = [
      Container(
        constraints: BoxConstraints.expand(),
        color: darkColor,
        child: Image.asset('assets/bg_page.png', fit: BoxFit.fill),
      ),
      Scaffold(
        extendBodyBehindAppBar: widget.isAppBarTransparent,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.isAppBarTransparent ? Colors.transparent : Colors.white.withOpacity(0.05),
          elevation: widget.isAppBarTransparent ? 0 : 4,
          toolbarOpacity: 0.75,
          actions: widget.actions,
        ),
        body: Padding(
          padding: _padding,
          child: widget.child,
        ),
        floatingActionButton: _floatingButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    ];

    if (widget.showIndicator) {
      children.add(_activityIndicator());
    }

    // dismiss keyboard on navigation
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Stack(children: children),
    );
  }

  Widget _floatingButton(BuildContext context) {
    if (!widget.hasFloatButton) {
      return null;
    }

    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      foregroundColor: Colors.blue,
      child: Image.asset('assets/ic_float.png'),
      onPressed: () => popToRoot(context),
    );
  }

  Widget _activityIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: primaryColor.withOpacity(0.3),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.none,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
