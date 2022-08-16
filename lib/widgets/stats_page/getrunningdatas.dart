// 무한스크롤 구현용 러닝 데이터 수집기
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sprint/models/positiondata.dart';
import 'package:sprint/models/runningdata.dart';
import 'package:sprint/screens/running_result_page.dart';
import 'package:sprint/utils/secondstostring.dart';

RunningData rn = RunningData(
    runnningId: 2,
    duration: 1609,
    distance: 4005.321413,
    startTime: "2022-08-02 07:48:26.382");

List<PositionData> rawdata = const [
  PositionData(
      latitude: 37.33028771,
      longitude: -122.02810514,
      altitude: 0,
      speed: 4.05,
      timestamp: "2022-08-02 07:48:26.382Z"),
  PositionData(
      latitude: 37.33028312,
      longitude: -122.02805328,
      altitude: 0,
      speed: 4.05,
      timestamp: "2022-08-02 07:48:27.310Z"),
  PositionData(
      latitude: 37.33028179,
      longitude: -122.02799851,
      altitude: 0,
      speed: 4.21,
      timestamp: "2022-08-02 07:48:28.280Z"),
  PositionData(
      latitude: 37.33027655,
      longitude: -122.02794361,
      altitude: 0,
      speed: 4.2,
      timestamp: "2022-08-02 07:48:29.391Z"),
  PositionData(
      latitude: 37.33025622,
      longitude: -122.02763446,
      altitude: 0,
      speed: 4.13,
      timestamp: "2022-08-02 07:48:35.348Z"),
  PositionData(
      latitude: 37.33025362,
      longitude: -122.02758396,
      altitude: 0,
      speed: 4.16,
      timestamp: "2022-08-02 07:48:36.377Z"),
  PositionData(
      latitude: 37.33025232,
      longitude: -122.02753387,
      altitude: 0,
      speed: 4.14,
      timestamp: "2022-08-02 07:48:37.341Z"),
  PositionData(
      latitude: 37.33025158,
      longitude: -122.02748438,
      altitude: 0,
      speed: 4.11,
      timestamp: "2022-08-02 07:48:38.296Z"),
  PositionData(
      latitude: 37.3302507,
      longitude: -122.027435,
      altitude: 0,
      speed: 4.1,
      timestamp: "2022-08-02 07:48:39.341Z"),
  PositionData(
      latitude: 37.33024596,
      longitude: -122.02719578,
      altitude: 0,
      speed: 3.91,
      timestamp: "2022-08-02 07:48:44.371Z"),
  PositionData(
      latitude: 37.33023967,
      longitude: -122.02714858,
      altitude: 0,
      speed: 4.02,
      timestamp: "2022-08-02 07:48:45.378Z"),
];

class CharacterListItem extends StatelessWidget {
  const CharacterListItem({
    required this.num,
    Key? key,
  }) : super(key: key);

  final int num;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RunResult(
                      positionDataList: rawdata,
                      duration: rn.duration,
                      distance: rn.distance),
                  fullscreenDialog: true),
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
                        "id: $num",
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
                        "${(rn.distance / 1000).toStringAsFixed(2)}\n거리",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${secondsToString(rn.duration)}\n시간",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${secondsToString((1000 * rn.duration / rn.distance).round())}\n페이스",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${(60 * 2 * rn.duration / 900).toStringAsFixed(2)}\n칼로리",
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

class CharacterListView extends StatefulWidget {
  const CharacterListView({Key? key}) : super(key: key);

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  List<int> local = [];
  List<int> server = [];

  final PagingController<int, int> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    for (int i = 0; i < 30; i++) {
      server.add(i);
    }
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    int nextDataPosition = (pageKey * 3);
    int dataLength = 3;

    print("nextDataPosition: $nextDataPosition");
    if (nextDataPosition > server.length) {
      // 더이상 가져갈 것이 없음
      return;
    }

    // 읽을 데이터는 있지만 10개가 안되는 경우
    if ((nextDataPosition + 3) > server.length) {
      // 가능한 최대 개수 얻기
      dataLength = server.length - nextDataPosition;
    }

    final newItems =
        server.sublist(nextDataPosition, nextDataPosition + dataLength);

    final isLastPage = newItems.length < dataLength;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey.toInt());
    }

    Future.delayed(const Duration(milliseconds: 10000));
  }

  @override
  Widget build(BuildContext context) => PagedSliverList<int, int>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<int>(
          itemBuilder: (context, item, index) => CharacterListItem(
            num: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
