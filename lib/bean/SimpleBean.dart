
import 'BannerEntity.dart';

class SimpleBean extends BannerEntity{

    final String url;
    final String title;

  SimpleBean(this.url, this.title);

  @override
  // TODO: implement bannerTitle
  get bannerTitle => url;

  @override
  // TODO: implement bannerUrl
  get bannerUrl => title;

}