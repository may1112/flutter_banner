import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void OnPageChanged(int index);

class AutoScrollPageView extends StatefulWidget {
  //滚动的widget
  final List<Widget> widgetList;

  //初始化下标
  final int initIndex;

  //动画间隔时间
  final Duration intervalDuration;

  //动画持续时间
  final Duration animationDuration;

  //动画模式
  final Curve curve;

  final OnPageChanged onPageChanged;

  AutoScrollPageView(
    this.widgetList, {
    Key key,
    this.initIndex = 0,
    this.intervalDuration = const Duration(milliseconds: 5000),
    this.animationDuration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _AutoScrollPageViewState createState() => new _AutoScrollPageViewState();
}

class _AutoScrollPageViewState extends State<AutoScrollPageView> {
  //自动滚动的布局
  List<Widget> _autoScrollWidgetList = [];

  Duration _intervalDuration;

  PageController _pageController;

  int _currentIndex = 0;

  //上次下标
  int _lastIndex = 0;

  //计时器
  Timer _timer;

  //是否手指滚动
  bool _isFingerScroll = false;

  //是否手指触摸
  bool _isTouch = false;

  //缓冲页面的页数
  final int _bufferPageLen = 3;

  @override
  void initState() {
    super.initState();

    _autoScrollWidgetList.addAll(this.widget.widgetList);
    //添加重复的头和尾
    for (int i = 0; i < _bufferPageLen; i++) {
      int lastIndex = widget.widgetList.length - 1 - i;
      //print("Index----->$lastIndex");
      if (widget.widgetList.length < _bufferPageLen) {
        lastIndex = lastIndex.abs() % widget.widgetList.length;
      }
      _autoScrollWidgetList.insert(0, widget.widgetList[lastIndex]);
      _autoScrollWidgetList
          .add(widget.widgetList[i % widget.widgetList.length]);
    }

    _currentIndex = widget.initIndex + _bufferPageLen;

    _intervalDuration = widget.intervalDuration;
    _pageController = PageController(initialPage: _currentIndex);

    Function timerCallback = (Timer timer) {
      if (!mounted || _isTouch || _isFingerScroll) {
        return;
      }
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: widget.animationDuration,
        curve: widget.curve,
      );
//                    .whenComplete(()
//            {
//                //print("whenComplete-------------------------->$_currentIndex");
//                _correctionCurrentIndex();
//            });
    };
    _timer = new Timer.periodic(_intervalDuration, timerCallback);
  }

  ///获取时间戳
//    int _getTimestamp()
//    {
//        return new DateTime.now().millisecondsSinceEpoch;
//    }

  @override
  Widget build(BuildContext context) {
    Widget pageView = new PageView.builder(
      itemBuilder: (context, index) {
        Widget widget = _autoScrollWidgetList[index];
        return widget;
      },
      controller: _pageController,
      itemCount: _autoScrollWidgetList.length,
      onPageChanged: (index) {
        _currentIndex = index;
        //print("_currentIndex----------------------------->$_currentIndex");
      },
      physics: new ClampingScrollPhysics(),
    );

    return new NotificationListener(
      child: GestureDetector(
        child: pageView,
        onTapDown: (details) {
          _isTouch = true;
          //print("onTapDown----------------------------->$_isTouch");
        },
        onTapUp: (details) {
          _isTouch = false;
          //print("onTapUp----------------------------->$_isTouch");
        },
        onTapCancel: () {
          _isTouch = false;
          //print("onTapCancel----------------------------->$_isTouch");
        },
      ),
      onNotification: (notification) {
        this._handleScrollNotification(notification);
      },
    );
  }

  ///校正下标
  void _correctionCurrentIndex() {
    if (_currentIndex < _bufferPageLen) {
      _currentIndex =
          _currentIndex % widget.widgetList.length + widget.widgetList.length;
      _pageController.jumpToPage(_currentIndex);
    } else if (_currentIndex >
        _autoScrollWidgetList.length - 1 - _bufferPageLen) {
      _currentIndex = _currentIndex % widget.widgetList.length;
      if (_currentIndex == 0) {
        _currentIndex = widget.widgetList.length;
      }
      _pageController.jumpToPage(_currentIndex);
    }
    int tempIndex = _currentIndex - _bufferPageLen;
    //print("当前页数---------------------------->${_currentIndex - _bufferPageLen}");
    if (tempIndex != _lastIndex) {
      _lastIndex = tempIndex;
      if (widget.onPageChanged != null) {
        widget.onPageChanged(tempIndex);
      }
    }
  }

  //处理滚动监听
  void _handleScrollNotification(Notification notification) {
    //处理用户手指滚动事件
    void _handleUserScroll(UserScrollNotification notification) {
      UserScrollNotification userScrollNotification = notification;
      if (userScrollNotification.direction == ScrollDirection.idle) {
        //print("${_getTimestamp()}--------------------------------->用户手动滑动结束");
        _isFingerScroll = false;
      } else {
        //print("${_getTimestamp()}--------------------------------->用户手动滑动开始");
        _isFingerScroll = true;
      }
    }

//        void _handleOtherScroll(ScrollUpdateNotification notification)
//        {
//            print("_handleOtherScroll---------------------->$notification");
//            ScrollUpdateNotification scrollUpdateNotification = notification;
//            //_resetWhenAtEdge(scrollUpdateNotification.metrics);
//        }

    //print("notification---------------------->$notification");
    if (notification is UserScrollNotification) {
      _handleUserScroll(notification);
    } else if (notification is ScrollUpdateNotification) {
      //_handleOtherScroll(notification);
    } else if (notification is ScrollStartNotification) {
    } else if (notification is ScrollEndNotification) {
      _correctionCurrentIndex();
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _timer.cancel();
    super.dispose();
  }
}
