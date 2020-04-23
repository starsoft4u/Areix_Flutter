import 'package:areix/components/outline-round-button.dart';
import 'package:areix/screens/common.dart';
import 'package:areix/utils/constants.dart';
import 'package:areix/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final _dotSize = 5.0;
  String _username;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _username = 'Jason';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonPage(
      title: 'Profile',
      hasFloatButton: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app, color: primaryColor),
          onPressed: _showLogoutAlert,
        ),
      ],
      child: Column(children: <Widget>[
        // Summary
        _top(),

        // Greetings
        SizedBox(height: 24),
        Text(
          'Hang on, $_username\nYou\'re doing great!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
        ),

        // Graph
        SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _graph(),
          ),
        ),

        // Note
        SizedBox(height: 16),
        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          _dot(accentColor, true),
          SizedBox(width: 8),
          Text('Saving growth'),
          SizedBox(width: 48),
          _dot(primaryColor, true),
          SizedBox(width: 8),
          Text('Wealth growth'),
        ]),

        // Buttons
        SizedBox(height: 16),
        OutlineRoundButton(
          title: 'Manage social account',
          width: 240,
          onPressed: () => navigate(context, '/profile/social'),
        ),
        OutlineRoundButton(
          title: 'Subscription & referral',
          width: 240,
          onPressed: () => navigate(context, '/profile/subscription'),
        ),
        SizedBox(height: 16),
      ]),
    );
  }

  void _showLogoutAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to log out?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Logout', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove(KEY_SOCIAL_ACCOUNTS);
                Navigator.of(context).pushNamedAndRemoveUntil('/', (x) => !x.isCurrent);
              },
            )
          ],
        );
      },
    );
  }

  Widget _top() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 48, right: 48, top: 16, bottom: 24),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/bg_cell_clip.png'), fit: BoxFit.fill),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Image.asset('assets/logo_x.png', width: 96, height: 96, fit: BoxFit.contain),
        SizedBox(width: 24),
        Text('Status : ', style: const TextStyle(fontWeight: FontWeight.w400)),
        SizedBox(width: 16),
        Expanded(child: Text('Free', style: const TextStyle(color: primaryColor))),
      ]),
    );
  }

  Widget _graph() {
    return LayoutBuilder(builder: (context, constraint) {
      double width = constraint.maxWidth;
      double height = constraint.maxHeight;
      final viewRatio = width / height;
      final logoRatio = 676.0 / 430.0;
      double x = 0.0;
      double y = 0.0;

      if (viewRatio > logoRatio) {
        width = height * logoRatio;
        x = (constraint.maxWidth - width) / 2;
      } else {
        height = width / logoRatio;
        y = (constraint.maxHeight - height) / 2;
      }

      final children = <Widget>[
        Positioned.fill(
          child: Opacity(
            opacity: 0.3,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),
        ),
      ];

      // Draw lines
      children.add(Positioned(
        left: x,
        top: y,
        width: width,
        height: height,
        child: CustomPaint(
          painter: _LinePainter(points1: _savingDots, points2: _wealthDots, dotSize: _dotSize + 2),
        ),
      ));

      // Draw dots
      final dots = List.from(_savingDots)
        ..addAll(_wealthDots)
        ..toSet()
        ..toList();

      children.addAll(dots
          .map((item) => Positioned(
                left: x + width * item.dx - _dotSize,
                top: y + height * item.dy - _dotSize,
                child: _dot(primaryColor.withAlpha(96), false),
              ))
          .toList());

      // Saving
      // dot
      var source = _savingDots.map((item) => Offset(x + width * item.dx, y + height * item.dy)).toList();
      var offset = Offset.zero;
      if (_saving <= 1.0) {
        offset = source[0];
      } else if (_saving < 50.0) {
        offset = _graphVal(start: source[0], end: source[1], percent: _saving / 50.0);
      } else if (_saving == 50.0) {
        offset = source[1];
      } else if (_saving < 75.0) {
        offset = _graphVal(start: source[1], end: source[2], percent: (_saving - 50.0) / 25.0);
      } else if (_saving == 75.0) {
        offset = source[2];
      } else if (_saving < 100.0) {
        offset = _graphVal(start: source[2], end: source[3], percent: (_saving - 75.0) / 25.0);
      } else {
        offset = source[3];
      }
      children.add(Positioned(
        left: offset.dx - _dotSize,
        top: offset.dy - _dotSize,
        child: _dot(accentColor, true),
      ));
      // label
      var labelWidth = width * 0.45;
      var offsetX = labelWidth * (_saving - 100.0) / 100.0;
      children.add(Positioned(
        left: offset.dx + offsetX - _dotSize,
        top: offset.dy - _dotSize - 14.0,
        child: Tooltip(
          message: 'Save an average \$2,000 more...',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: labelWidth,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: accentColor, width: 0.5)),
            ),
            child: Text(
              'Top $_saving%',
              textAlign: _saving < 50.0 ? TextAlign.left : TextAlign.right,
              style: const TextStyle(color: accentColor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ));

      // Wealth
      // dot
      source = _wealthDots.map((item) => Offset(x + width * item.dx, y + height * item.dy)).toList();
      if (_wealth <= 1.0) {
        offset = source[0];
      } else if (_wealth < 50.0) {
        offset = _graphVal(start: source[0], end: source[1], percent: _wealth / 50.0);
      } else if (_wealth == 50.0) {
        offset = source[1];
      } else if (_wealth < 75.0) {
        offset = _graphVal(start: source[1], end: source[2], percent: (_wealth - 50.0) / 25.0);
      } else if (_wealth == 75.0) {
        offset = source[2];
      } else if (_wealth < 100.0) {
        offset = _graphVal(start: source[2], end: source[3], percent: (_wealth - 75.0) / 25.0);
      } else {
        offset = source[3];
      }
      children.add(Positioned(
        left: offset.dx - _dotSize,
        top: offset.dy - _dotSize,
        child: _dot(primaryColor, true),
      ));

      // Labels
      offsetX = labelWidth * _wealth / 100.0;
      children.add(Positioned(
        left: offset.dx - offsetX - _dotSize,
        top: offset.dy - _dotSize - 14.0,
        child: Tooltip(
          message: 'Save an average \$2,000 more...',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: labelWidth,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: primaryColor, width: 0.5)),
            ),
            child: Text(
              'Top $_wealth%',
              textAlign: _wealth > 50.0 ? TextAlign.left : TextAlign.right,
              style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ));

      return Stack(children: children);
    });
  }

  Offset _graphVal({Offset start, Offset end, double percent}) {
    final dx = start.dx - end.dx;
    final dy = start.dy - end.dy;
    final a = dx / dy;
    final y = dy * percent;
    final x = a * y;

    return Offset(start.dx - x, start.dy - y);
  }

  Widget _dot(Color color, bool fill) {
    BoxDecoration decoration = fill
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color.withAlpha(96), blurRadius: 5)],
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color),
          );

    return Container(
      width: _dotSize * 2,
      height: _dotSize * 2,
      decoration: decoration,
    );
  }

  final _savingDots = <Offset>[
    Offset(0.5, 0.2162790698),
    Offset(0.2825443787, 0.5558139535),
    Offset(0.1360946746, 0.7930232558),
    Offset(0.0325443787, 0.9511627907),
  ];
  final _wealthDots = <Offset>[
    Offset(0.5, 0.2162790698),
    Offset(0.7174556213, 0.5558139535),
    Offset(0.8639053254, 0.7930232558),
    Offset(0.9674556213, 0.9511627907),
  ];
  final double _saving = 32.0;
  final double _wealth = 8.0;
}

// Paint p1-p2, p2-p3
class _LinePainter extends CustomPainter {
  final List<Offset> points1, points2;
  final double dotSize;

  _LinePainter({this.points1, this.points2, this.dotSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = primaryColor.withAlpha(96);

    final w = size.width;
    final h = size.height;
    var path = Path();

    for (int i = 1; i < points1.length; i++) {
      path.moveTo(w * points1[i - 1].dx - dotSize / 2, h * points1[i - 1].dy + dotSize / 2);
      path.lineTo(w * points1[i].dx + dotSize / 2, h * points1[i].dy - dotSize / 2);

      path.moveTo(w * points2[i - 1].dx + dotSize / 2, h * points2[i - 1].dy + dotSize / 2);
      path.lineTo(w * points2[i].dx - dotSize / 2, h * points2[i].dy - dotSize / 2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => true;
}
