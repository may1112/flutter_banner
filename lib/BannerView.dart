import 'package:flutter/material.dart';

import 'view/AutoScrollPageView.dart';

class BannerView extends StatefulWidget {
  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  //指示器下标
  int _indicatorIndex = 0;

  //页面改变
  void onPageChanged(int index) {
    setState(() {
      _indicatorIndex = index;
    });
  }

  //图片存储
  List<String> images = [];

  //标题存储 没有就不加
  List<String> titles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images.add("images/banner0.jpg");
    images.add("images/banner1.jpg");
    images.add("images/banner2.jpg");
    images.add("images/banner3.jpg");

    titles.add('banner0');
    titles.add('banner1');
    titles.add('banner2');
    titles.add('banner3');
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = ListView.builder(
      itemBuilder: _itemView,
      itemCount: 20,
    );
    return listView;
  }


  Widget _itemView(BuildContext context, int index) {
   if(index==0){
     return _bannerView(context);
   }else{
     return Container(child: Text("测试$index"),);
   }
  }
  //绘制banner
  Widget _bannerView(BuildContext context){
    List<Widget> swiperWidgetList = [];
    double width = MediaQuery.of(context).size.width;
    //绘制图片
    images.forEach((img) {
      Widget bannerView = Image.asset(
        img,
        fit: BoxFit.cover,
        width: width,
      );
      Stack stack = Stack(
        children: <Widget>[
          bannerView,
          Material(
            child: InkWell(
              onTap: () {
                print("点击:$_indicatorIndex");
              },
            ),
            type: MaterialType.transparency,
          )
        ],
      );
      swiperWidgetList.add(stack);
    });

    Stack stack = Stack(
      children: <Widget>[
        //TODO 设置图片滚动
        AutoScrollPageView(
          swiperWidgetList,
          onPageChanged: onPageChanged,
        ),
        //todo 添加白色指示器
        Align(
          alignment: Alignment.topRight,
          child: _getSwiperIndicator(),
        ),
        //todo 添加标题
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Text(
              titles[_indicatorIndex],
              style: TextStyle(color: Colors.white,fontSize: 14.0),
            ),
          ),
        )
      ],
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      child: stack,
    );
  }

  //绘制指示器
  Widget _getSwiperIndicator() {
    Widget selectedWidget = Padding(
      padding: EdgeInsets.all(3.0),
      child: CircleAvatar(
        radius: 3.0,
        backgroundColor: Colors.white,
      ),
    );
    Widget unSelectedWidget = Padding(
      padding: EdgeInsets.all(3.0),
      child: CircleAvatar(
        radius: 3.0,
        backgroundColor: Colors.black54,
      ),
    );
    List<Widget> indicatorList = [];
    for (int i = 0; i < images.length; i++) {
      if (_indicatorIndex == i) {
        indicatorList.add(selectedWidget);
      } else {
        indicatorList.add(unSelectedWidget);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: indicatorList,
    );
  }
}
