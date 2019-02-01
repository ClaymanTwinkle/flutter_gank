import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/net/model/today_model.dart';
import 'package:flutter_gank/page/welfare_widget.dart';
import 'dart:math' as math;
import 'package:flutter_swiper/flutter_swiper.dart';

class TodayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  bool _disposed = false;

  List<String> _picList = new List(0);
  List<Today> _data = new List(0);

  @override
  void initState() {
    super.initState();
    _pullToRefresh();
  }

  Future<void> _pullToRefresh() async {
    return GankApi.getToday().then((value) {
      TodayResponse response = TodayResponse.fromJson(value);
      if (!response.error && !_disposed) {
        _data = new List();
        _picList = new List();
        setState(() {
          response.results.forEach((key, value) {
            if ("福利" != key) {
              _data.addAll(value);
            } else {
              value.forEach((today)=>_picList.add(today.url));
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;
    if (_data.isEmpty) {
      contentWidget = new Center(
        child: new Text('加载中...'),
      );
    } else {
      contentWidget = RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  child: Swiper(
                    itemBuilder: _swiperBuilder,
                    itemCount: _picList.length,
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      color: Colors.black54,
                      activeColor: Colors.white,
                    )),
                    control:
                        new SwiperControl(iconNext: null, iconPrevious: null),
                    scrollDirection: Axis.horizontal,
                    autoplay: true,
                    onTap: (index) => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new LookBigImagePage(_picList[index]),
                      ),
                    ),
                  )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final int itemIndex = index ~/ 2;
                    Widget widget;
                    if (index.isEven) {
                      widget = _buildItem(context, itemIndex);
                    } else {
                      widget = new Divider();
                    }
                    return widget;
                  },
                  childCount: math.max(0, (_data.length) * 2 - 1),
                  semanticIndexCallback: (Widget _, int index) {
                    return index.isEven ? index ~/ 2 : null;
                  }),
            ),
          ],
        ),
        onRefresh: _pullToRefresh,
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("今天"),
      ),
      body: contentWidget,
    );
  }

  Widget _swiperBuilder(context, index) {
    return CachedNetworkImage(
      placeholder: new CircularProgressIndicator(),
      imageUrl: _picList[index] ?? "",
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
      errorWidget: Center(
        child: new Text("图片加载失败"),
      ),
    );
  }

  Widget _buildItem(context, index) {
    Today today = _data[index];

    List<Widget> children = new List<Widget>();
    children.add(Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _data[index].desc,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Material(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      "作者: ${today.who}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.pinkAccent,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Text(
                    today.type,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    )));

    if (today.images != null && today.images.isNotEmpty) {
      children.add(Padding(
        padding: EdgeInsets.only(left: 10),
        child: CachedNetworkImage(
          imageUrl: today.images[0] ?? "",
          width: 100,
          height: 100,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 200),
          fit: BoxFit.fill,
          placeholder: Container(
            color: Colors.grey,
            width: 100,
            height: 100,
          ),
          errorWidget: Container(
            color: Colors.red,
            width: 100,
            height: 100,
          ),
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
