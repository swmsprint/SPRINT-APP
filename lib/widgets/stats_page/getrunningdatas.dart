import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:infinite_scroll_pagination/src/ui/default_indicators/first_page_exception_indicator.dart';
import 'package:sprint/models/positiondata.dart';
import 'package:sprint/models/runningdata.dart';
import 'package:sprint/screens/running_result_page.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class RunningItem extends StatelessWidget {
  final RunningData data;
  final int userId;
  const RunningItem({
    required this.data,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getRunningDetail(runningId) async {
      var dio = await authDio(context);

      var response = await dio.get(
          '$serverurl/api/running/detail/?runningId=$runningId&userId=$userId');
      if (response.statusCode == 200) {
        return response.data;
      }
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            getRunningDetail(data.runningId).then(
              (value) {
                List<PositionData> rawdata = [];
                for (int i = 0; i < value["runningData"].length; i++) {
                  rawdata.add(PositionData(
                      latitude: value["runningData"][i]["latitude"],
                      longitude: value["runningData"][i]["longitude"],
                      altitude: 0,
                      speed: value["runningData"][i]["speed"],
                      timestamp: value["runningData"][i]["timestamp"]));
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RunResult(
                      positionDataList: rawdata,
                      duration: value["duration"].round(),
                      distance: value["distance"],
                      calories: value["energy"],
                    ),
                  ),
                );
              },
            );
          },
          child: Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.topLeft,
              color: const Color(0xffffffff),
            ),
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateTime.parse(data.startTime)
                            .add(const Duration(hours: 9))
                            .toString()
                            .substring(0, 16),
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 30,
                          color: Color(0xfffa7531),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(data.distance / 1000).toStringAsFixed(2)}KM\n거리",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${secondsToString(data.duration)}\n시간",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        data.distance == 0
                            ? "00:00\n페이스"
                            : "${secondsToString((1000 * data.duration / data.distance).round())}\n페이스",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${data.calories.toStringAsFixed(2)}\n칼로리",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                ],
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }
}

class RunningListView extends StatefulWidget {
  final int userId;
  const RunningListView({Key? key, required this.userId}) : super(key: key);

  @override
  State<RunningListView> createState() => _RunningListViewState();
}

class _RunningListViewState extends State<RunningListView> {
  static const _pageSize = 3;

  final PagingController<int, RunningData> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.userId);
    });
    super.initState();
  }

  _getRunningDatas(pageKey) async {
    var dio = await authDio(context);

    var response = await dio.get(
        '$serverurl/api/running/personal/?pageNumber=$pageKey&userId=${widget.userId}');
    if (response.statusCode == 200) {
      List<dynamic> result = response.data;
      List<RunningData> runningDatas = [];
      for (int i = 0; i < result.length; i++) {
        runningDatas.add(RunningData(
            runningId: result[i]['runningId'],
            duration: result[i]['duration'].round(),
            distance: result[i]['distance'],
            startTime: result[i]['startTime'],
            calories: result[i]['energy']));
      }
      return runningDatas;
    }
  }

  Future<void> _fetchPage(int pageKey, int userId) async {
    try {
      final newItems = await _getRunningDatas(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) =>
      // Don't worry about displaying progress or error indicators on screen; the
      // package takes care of that. If you want to customize them, use the
      // [PagedChildBuilderDelegate] properties.
      /*
      PagedListView<int, RunningData>(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<RunningData>(
          itemBuilder: (context, item, index) => RunningItem(
            data: item,
            userId: widget.userId,
          ),
          noItemsFoundIndicatorBuilder: (_) =>
              const FirstPageExceptionIndicator(
            title: '러닝 기록이 없습니다!',
            message: '신나게 뛰어보세요!',
          ),
        ),
      );
      */
      PagedSliverList<int, RunningData>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<RunningData>(
          itemBuilder: (context, item, index) => RunningItem(
            data: item,
            userId: widget.userId,
          ),
          noItemsFoundIndicatorBuilder: (_) =>
              const FirstPageExceptionIndicator(
            title: '러닝 기록이 없습니다!',
            message: '신나게 뛰어보세요!',
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
