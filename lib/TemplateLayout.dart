import 'package:flutter/material.dart';
import 'package:flutter_app/view/TemplateView.dart';

import 'bean/SimpleBean.dart';

class TemplateLayout extends StatefulWidget {
  @override
  _TemplateLayoutState createState() => _TemplateLayoutState();
}

class _TemplateLayoutState extends State<TemplateLayout> {
  List<SimpleBean> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < 5; i++) {
      SimpleBean simpleBean = SimpleBean(
          "https://uploads.5068.com/allimg/1802/153-1P203142408.jpg",
          "banner$i");
      list.add(simpleBean);
    }
  }

  @override
  Widget build(BuildContext context) {
    TemplateView templateView = TemplateView(
      list,
      onBannerPos: OnBannerPos,
    );
    return Container(
      child: templateView,
    );
  }

  OnBannerPos(pos) {
    print("点击回调$pos");
  }
}
