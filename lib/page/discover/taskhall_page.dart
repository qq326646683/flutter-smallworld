import 'package:flutter/material.dart';
import 'package:flutter_smallworld/common/service/index.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_smallworld/widget/index.dart';
import 'package:flutter_smallworld/common/dao/taskhall_dao.dart';
import 'package:flutter_smallworld/common/redux/index.dart';
import 'package:flutter_smallworld/common/config/config.dart';
import 'package:flutter_smallworld/common/model/index.dart';
import 'package:flutter_smallworld/common/utils/index.dart';
import 'taskhall_page_style.dart';
import 'taskhall_item.dart';

class TaskhallPage extends StatefulWidget {
  static final String sName = "taskhall";

  @override
  _TaskhallPageState createState() => _TaskhallPageState();
}

class _TaskhallPageState extends State<TaskhallPage>
    with
        SMListState<TaskhallPage>,
        AutomaticKeepAliveClientMixin<TaskhallPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => false;

  @override
  bool get needHeader => false;

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;

    ResponseResult<TaskhallResult> res = await TaskhallService.getInstance().fetchList(page: this.page);
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null && res.data.list.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    ResponseResult<TaskhallResult> res = await TaskhallService.getInstance().fetchList(page: this.page);
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null);
    });
    isLoading = false;
    return null;
  }

  @override
  requestRefresh() {}

  @override
  requestLoadMore() {}

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList =
        _getStore().state.taskHallState.taskhallList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  _renderItem(Taskhall item) {
    return TaskhallItem(taskhall: item,);
  }

  Store<MainStore> _getStore() {
    return StoreProvider.of<MainStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: SMTitleBarWidget(
        isDefault: false,
        title: '任务大厅',
        backIconColor: SMColors.lightGolden,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(SMIcons.TASKHALL_BG), fit: BoxFit.fill),
        ),
        child: Stack(
          children: <Widget>[
            /*蒙层*/
            Container(
              width: ScreenUtil.getInstance().screenWidth,
              height: ScreenUtil.getInstance().screenHeight,
              color: SMColors.opacity75Cover,
            ),
            SMPullLoadWidget(
              new ScrollController(),
              pullLoadWidgetControl,
                  (BuildContext context, int index) =>
                  _renderItem(pullLoadWidgetControl.dataList[index]),
              handleRefresh,
              onLoadMore,
              refreshKey: refreshIndicatorKey,
            ),
          ],
        ),
      ),
    );
  }
}
