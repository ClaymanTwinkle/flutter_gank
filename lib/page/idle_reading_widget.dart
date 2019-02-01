import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/net/model/idle_reading_model.dart';
import 'package:flutter_gank/net/gank_api.dart';
import 'package:url_launcher/url_launcher.dart';

class IdleReadingPage extends StatefulWidget {
  @override
  _IdleReadingPageState createState() => new _IdleReadingPageState();
}

class _IdleReadingPageState extends State<IdleReadingPage> {
  static const String _TITLE = "闲读";
  List<Category> _data;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    GankApi.getXianDuCategories().then((Map<String, dynamic> value) {
      CategoriesResponse response = new CategoriesResponse.fromJson(value);
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
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      // empty data loading
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(_TITLE),
        ),
        body: new Center(
          child: new Text('加载中...'),
        ),
      );
    } else {
      List<Tab> tabList = new List<Tab>();

      _data.forEach((category) {
        tabList.add(new Tab(
          text: category.name,
        ));
      });

      return DefaultTabController(
        length: _data.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabList,
              isScrollable: true,
            ),
            title: Text(_TITLE),
          ),
          body: new _IdleReadingTabBarView(_data),
        ),
      );
    }
  }
}

class _IdleReadingTabBarView extends StatelessWidget {
  final List<Category> _categoryData;

  _IdleReadingTabBarView(this._categoryData);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();

    this._categoryData.forEach((category) =>
        children.add(new _IdleReadingCategoryListViewWidget(category.enName)));

    return new TabBarView(
      children: children,
    );
  }
}

class _IdleReadingCategoryListViewWidget extends StatefulWidget {
  final String _enName;

  _IdleReadingCategoryListViewWidget(this._enName);

  @override
  State<StatefulWidget> createState() {
    return new _IdleReadingCategoryListViewWidgetState(_enName);
  }
}

class _IdleReadingCategoryListViewWidgetState
    extends State<_IdleReadingCategoryListViewWidget> {
  final String _enName;

  List<SubCategory> _data;

  bool _isDisposed = false;

  _IdleReadingCategoryListViewWidgetState(this._enName);

  @override
  void initState() {
    super.initState();
    GankApi.getXianDuSubCategory(_enName).then((value) {
      SubCategoriesResponse response =
          new SubCategoriesResponse.fromJson(value);
      if (!response.error && !_isDisposed) {
        setState(() {
          this._data = response.results;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        itemBuilder: buildItem);
  }

  //ListView的Item
  Widget buildItem(BuildContext context, int index) {
    SubCategory subCategory = _data[index];
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: subCategory.icon == null ? "" : subCategory.icon,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 200),
        placeholder: Container(
          color: Colors.grey,
          width: 50.0,
          height: 50.0,
        ),
        errorWidget: Container(
          color: Colors.grey,
          width: 50.0,
          height: 50.0,
        ),
      ),
      title: Text(subCategory.title),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new IdleReadingArticleListPage(
                subCategory.id, subCategory.title),
          ),
        );
      },
    );
  }
}

class IdleReadingArticleListPage extends StatelessWidget {
  final String _id;
  final String _title;

  IdleReadingArticleListPage(this._id, this._title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: new _IdleReadingArticleContentWidget(_id),
    );
  }
}

class _IdleReadingArticleContentWidget extends StatefulWidget {
  final String _id;

  _IdleReadingArticleContentWidget(this._id);

  @override
  State<StatefulWidget> createState() {
    return new _IdleReadingArticleContentWidgetState(_id);
  }
}

class _IdleReadingArticleContentWidgetState
    extends State<_IdleReadingArticleContentWidget> {
  final String _id;
  bool _isDispose = false;

  int _page = 1;
  int _count = 20;

  bool _isEndPage = false;

  List<Article> _data = new List(0);

  ScrollController _scrollController = new ScrollController();

  _IdleReadingArticleContentWidgetState(this._id) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          !_isEndPage) {
        // 上拉刷新做处理
        print('load more ...');
        GankApi.getXianDuPage(_id, _page++, _count).then((value) {
          ArticleResponse response = ArticleResponse.fromJson(value);
          if (!response.error && !_isDispose) {
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _isDispose = true;
  }

  Future<void> _pullToRefresh() async {
    _page = 1;
    _isEndPage = false;
    return GankApi.getXianDuPage(_id, _page++, _count).then((value) {
      ArticleResponse response = ArticleResponse.fromJson(value);
      if (!response.error && !_isDispose && response.results != null) {
        setState(() {
          _data = response.results;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data.length == 0) {
      return Center(
        child: Text("加载中..."),
      );
    } else {
      return RefreshIndicator(
        child: new ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          shrinkWrap: true,
          itemCount: _data.length + 1,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: _buildItem,
          controller: _scrollController,
        ),
        onRefresh: _pullToRefresh,
      );
    }
  }

  Widget _buildItem(context, index) {
    if (index < _data.length) {
      return _getListViewItem(context, index);
    }

    return _buildLoadMoreView();
  }

  Widget _getListViewItem(context, index) {
    List<Widget> children = new List<Widget>();
    Article article = _data[index];
    children.add(Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: CachedNetworkImage(
        imageUrl: article.cover == null ? "" : article.cover,
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
          color: Colors.grey,
          width: 100,
          height: 100,
        ),
      ),
    ));

    children.add(Expanded(
      child: Text(
        article.title,
      ),
    ));

    return GestureDetector(
      onTap: () async {
        if (await canLaunch(article.url)) {
          await launch(article.url);
        }
      },
      child: Row(children: children),
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
          padding: EdgeInsets.all(10.0),
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
