import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_smallworld/widget/index.dart';
import 'package:flutter_smallworld/common/utils/index.dart';
import 'package:flutter_smallworld/widget/index.dart';
import 'package:flutter_smallworld/page/index.dart';
import 'package:flutter_smallworld/common/redux/index.dart';
import 'main_page_style.dart';

class MainPage extends StatefulWidget {
  static final String sName = "main";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TabItem> _tabItems = new List<TabItem>();

  @override
  void initState() {
    super.initState();
    NavigatorUtils.getInstance().setContext(context);
  }

  List<TabItem> _renderTabItems() {
    return [
      new TabItem(
          icon: _renderImgBtn(SMIcons.TAB_HOME, false),
          activeIcon: _renderImgBtn(SMIcons.TAB_HOME_ACTIVE, false)),
      new TabItem(
          icon: _renderImgBtn(SMIcons.TAB_CHAT, true),
          activeIcon: _renderImgBtn(SMIcons.TAB_CHAT_ACTIVE, true)),
      new TabItem(
          icon: SMTabBarBtnWidget(
            icon: Image.asset(SMIcons.TAB_CLUB_ACTIVE,
                width: MainPageStyle.tabBarClubWidth,
                height: MainPageStyle.tabBarClubWidth),
            showDot: true,
          ),
          activeIcon: SMTabBarBtnWidget(
            icon: Image.asset(SMIcons.TAB_CLUB_ACTIVE,
                width: MainPageStyle.tabBarClubWidth,
                height: MainPageStyle.tabBarClubWidth),
            showDot: true,
          )),
      new TabItem(
          icon: _renderImgBtn(SMIcons.TAB_DISCOVER, true),
          activeIcon: _renderImgBtn(SMIcons.TAB_DISCOVER_ACTIVE, true)),
      new TabItem(
          icon: _renderImgBtn(SMIcons.TAB_PROFILE, false),
          activeIcon: _renderImgBtn(SMIcons.TAB_PROFILE_ACTIVE, false)),
    ];
  }
  Widget _renderImgBtn(String name, bool showDot) {
    return SMTabBarBtnWidget(
      icon: Image.asset(name,
          width: MainPageStyle.tabBarBtnWidth,
          height: MainPageStyle.tabBarBtnWidth),
      showDot: showDot,
    );
  }

  @override
  Widget build(BuildContext context) {
    _tabItems = _renderTabItems();
    LogUtil.i(MainPage.sName,'render:MainPage');
    return StoreBuilder<MainStore>(builder: (context, store) {
      return SMTabBarPageViewWidget(
        type: SMTabBarPageViewWidget.BOTTOM_TAB,
        physics: NeverScrollableScrollPhysics(),
        tabViews: <Widget>[
          HomePage(),
          ChatPage(),
          ClubPage(),
          DiscoverPage(),
          ProfilePage()
        ],
        tabItems: _tabItems,
        backgroundColor: SMColors.primaryDarkValue,
        onPageChanged: (int index) {
          StatusBarUtil.setupMainPage(index);
        },
      );
    });
  }
}

