import 'dart:convert';

///字符串工具
class StringUtils {
  /**
     * 检查字符串是否为null和""
     * true 为空或者""
     */
  static bool isEmpty(String str) {
    if (str == null || str.isEmpty || str == "") {
      return true;
    }
    return false;
  }


  /**
     * 是否是邮箱
     */
  static bool isEmail(String str) {
    //^([a-z0-9A-Z]+[-|_|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$
    String reStr =
        r'^([a-z0-9A-Z]+[-|_|\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\.)+[a-zA-Z]{2,}$';
    return RegExp(reStr).hasMatch(str);
  }

  /**
     * 是否是手机号码
     */
  static bool isPhone(String str) {
    //^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(17([0,1,6,7,]))|(18[0-2,5-9]))\d{8}$
    String reStr =
        r'^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(17([0,1,6,7,]))|(18[0-2,5-9]))\d{8}$';
    return RegExp(reStr).hasMatch(str);
  }

  /**
   * 是否是网络地址
   */
  static bool isHttpUrl(String str) {
    String reStr =
            "(((https|http)?://)?([a-z0-9]+[.])|(www.))\\w+[.|\\/]([a-z0-9]{0,})?[[.]([a-z0-9]{0,})]+((/[\\S&&[^,;\u4E00-\u9FA5]]+)+)?([.][a-z0-9]{0,}+|/?)";
    return RegExp(reStr).hasMatch(str);
  }
}
