import 'package:flutter/material.dart';
import 'package:flutter_gank/page/idle_reading_widget.dart';
import 'package:flutter_gank/page/today_widget.dart';
import 'package:flutter_gank/page/welfare_widget.dart';

void main() => runApp(new GankApp());

class GankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '干货',
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  _MainPageState() {
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(controller: _tabController, children: [
        new TodayPage(),
        new IdleReadingPage(),
        new WelfarePage()
      ]),
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(
          controller: _tabController,
          tabs: [
            new Tab(
              text: "今天",
              icon: Icon(Icons.home),
            ),
            new Tab(
              text: "闲读",
              icon: Icon(Icons.book),
            ),
            new Tab(
              text: "妹子",
              icon: Icon(Icons.face),
            ),
          ],
          indicator: BoxDecoration(),
        ),
      ),
    );
  }
}

class Tab extends StatelessWidget {
  static const double _kTabHeight = 46.0;
  static const double _kTextAndIconTabHeight = 60.0;

  const Tab({
    Key key,
    this.text,
    this.icon,
    this.child,
  })  : assert(text != null || child != null || icon != null),
        assert(!(text != null && null != child)),
        super(key: key);

  final String text;

  final Widget child;

  final Widget icon;

  Widget _buildLabelText() {
    return child ?? Text(text, softWrap: false, overflow: TextOverflow.fade);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double height;
    Widget label;
    if (icon == null) {
      height = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null) {
      height = _kTabHeight;
      label = icon;
    } else {
      height = _kTextAndIconTabHeight;
      label = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: icon,
            ),
            _buildLabelText()
          ]);
    }

    return SizedBox(
      height: height,
      child: Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }
}
