import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/BannerEntity.dart';
import 'package:flutter_app/bean/SimpleBean.dart';
import 'package:flutter_app/common/StringUtils.dart';
import 'package:flutter_app/view/AutoScrollPageView.dart';

//监听点击事件
typedef void OnBannerPos(int postion);

class TemplateView extends StatefulWidget {
  final List<BannerEntity> lists;
  final OnBannerPos onBannerPos;

  //动画间隔时间
  final Duration intervalDuration;

  //动画持续时间
  final Duration animationDuration;

  //banner 宽高
  final double bannerWidth;

  final double bannerHeight;

  const TemplateView(
    this.lists, {
    Key key,
    this.onBannerPos,
    this.intervalDuration = const Duration(milliseconds: 5000),
    this.animationDuration = const Duration(milliseconds: 1000),
    this.bannerWidth = 0,
    this.bannerHeight = 0,
  }) : super(key: key);

  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  //指示器下标
  int _indicatorIndex = 0;

  double width;

  double height;

  //页面改变
  void onPageChanged(int index) {
    setState(() {
      _indicatorIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = width / 2;
    if (widget.bannerWidth > 0) {
      width = widget.bannerWidth;
    }
    if (widget.bannerHeight > 0) {
      height = widget.bannerHeight;
    }
    return Column(
      children: <Widget>[_bannerView(context)],
    );
  }

  Widget _bannerView(BuildContext context) {
    List<Widget> swiperWidgetList = [];
    //默认图片
    Widget defaultImage = Image.asset(
      "images/default_cover.png",
      fit: BoxFit.cover,
      width: width,
    );
    //绘制图片
    widget.lists.forEach((item) {
      Widget bannerView = defaultImage;

      if (!StringUtils.isEmpty(item.bannerUrl)) {
        bannerView = Image.network(
          item.bannerUrl,
          fit: BoxFit.cover,
          width: width,
        );
      }

      Stack stack = Stack(
        children: <Widget>[
          bannerView,
          Material(
            child: InkWell(
              onTap: () {
                print("点击:$_indicatorIndex");
                widget.onBannerPos(_indicatorIndex);
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
        AutoScrollPageView(
          swiperWidgetList,
          onPageChanged: onPageChanged,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _getSwiperIndicator(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Text(
              widget.lists[_indicatorIndex].bannerTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  decoration: TextDecoration.none),
            ),
          ),
        )
      ],
    );

    return Container(
      width: width,
      height: height,
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
    for (int i = 0; i < widget.lists.length; i++) {
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
