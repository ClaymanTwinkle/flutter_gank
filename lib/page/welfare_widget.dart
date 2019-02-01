import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:flutter_gank/net/model/welfare_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _WelfarePageState();
  }
}

class _WelfarePageState extends State<WelfarePage> {
  static const String _DATA_TYPE = "福利";

  bool _isDisposed = false;

  int _page = 1;
  int _count = 20;
  bool _isEndPage = false;

  List<Welfare> _data = new List<Welfare>(0);

  ScrollController _scrollController = new ScrollController();

  _WelfarePageState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          !_isEndPage &&
          _data.length > 0) {
        print('load more ...');
        GankApi.getDataByType(_DATA_TYPE, _page++, _count).then((value) {
          WelfareResponse response = WelfareResponse.fromJson(value);
          if (!response.error && !_isDisposed) {
            if (response.results == null || response.results.length == 0) {
              setState(() {
                _isEndPage = true;
              });
            } else {
              setState(() {
                _data.addAll(response.results);
              });
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pullToRefresh();
  }

  Future<void> _pullToRefresh() async {
    _page = 1;
    _isEndPage = false;
    return GankApi.getDataByType(_DATA_TYPE, _page++, _count).then((value) {
      WelfareResponse response = WelfareResponse.fromJson(value);
      if (!response.error && !_isDisposed) {
        setState(() {
          _data = response.results;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    if (_data.length > 0) {
      bodyWidget = RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: <Widget>[
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        _buildItem(context, index),
                    childCount: _data.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
              ),
              new SliverToBoxAdapter(
                child: _buildLoadMoreView(),
              )
            ],
          ),
        ),
        onRefresh: _pullToRefresh,
      );
    } else {
      // 没有数据...
      bodyWidget = Center(
        child: Text("加载中..."),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("妹子"),
      ),
      body: bodyWidget,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Welfare welfare = _data[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new LookBigImagePage(welfare.url),
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: welfare.url == null ? "" : welfare.url,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 200),
        placeholder: new Container(
          color: Colors.grey,
        ),
        errorWidget: new Container(
          child: Center(
            child: new Text("图片加载失败"),
          ),
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLoadMoreView() {
    if (_isEndPage) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              '我是有底线的',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
                height: 18.0,
                width: 18.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  '加载中...',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class LookBigImagePage extends StatelessWidget {
  final String _url;

  const LookBigImagePage(this._url);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                CacheManager.getInstance().then((cacheManager) {
                  cacheManager.getFile(_url).then((file) {
                    print(file.path);
                  });
                });
              })
        ],
      ),
      body: Center(
        child: CachedNetworkImage(
          placeholder: new CircularProgressIndicator(),
          imageUrl: _url ?? "",
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 200),
          errorWidget: Center(
            child: new Text("图片加载失败"),
          ),
        ),
      ),
    );
  }
}
