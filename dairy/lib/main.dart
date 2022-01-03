import 'package:dairy/data/diary.dart';
import 'package:dairy/data/utils.dart';
import 'package:dairy/write.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectIdx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          title: Text(""),
        ),
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Logs!"),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: "Charts"),
        ],
        onTap: (idx) {
          setState(() {
            selectIdx = idx;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => DiaryWritePage(
                  diary: Diary(
                      date: Utils.getFormatTime(DateTime.now()),
                      image: "",
                      memo: "",
                      status: 0,
                      title: ""))));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage() {
    if (selectIdx == 0) {
      return getTodayPage();
    } else if (selectIdx == 1) {
      return getHistoryPage();
    } else {
      return getChartsPage();
    }
  }

  Widget getTodayPage() {
    return Container();
  }

  Widget getHistoryPage() {
    return Container();
  }

  Widget getChartsPage() {
    return Container();
  }
}
