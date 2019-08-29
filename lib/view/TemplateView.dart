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

  const TemplateView(
    this.lists, {
    Key key,
    this.onBannerPos,
    this.intervalDuration = const Duration(milliseconds: 5000),
    this.animationDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  //指示器下标
  int _indicatorIndex = 0;

  //页面改变
  void onPageChanged(int index) {
    setState(() {
      _indicatorIndex = index;
      onPageChanged(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _bannerView(context);
  }

  Widget _bannerView(BuildContext context) {
    List<Widget> swiperWidgetList = [];
    double width = MediaQuery.of(context).size.width;
    //默认图片
    Widget defaultImage = Image.asset(
      "images/default_cover.png",
      fit: BoxFit.cover,
      width: width,
    );
    //绘制图片
    widget.lists.forEach((item) {
      double width = MediaQuery.of(context).size.width;
      Widget defaultImage = Image.asset(
        "images/default_cover.png",
        fit: BoxFit.cover,
        width: width,
      );
      Widget image = defaultImage;
      if (!StringUtils.isEmpty(item.bannerUrl)) {
        image = CachedNetworkImage(
                width: width,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) {
                  return defaultImage;
                },
                errorWidget: (BuildContext context, String url, Object error) {
                  return defaultImage;
                },
                imageUrl: item.bannerUrl);
      }

      Stack stack = Stack(
        children: <Widget>[
          image,

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
          alignment: Alignment.topRight,
          child: _getSwiperIndicator(),
        ),
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
