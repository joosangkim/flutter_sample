import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/data/todo.dart';
import 'package:todolist/data/utils.dart';
import 'package:todolist/write.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  int selectIdx = 0;
  List<Todo> todos = [];
  List<Todo> allTodo = [];
  //   Todo(
  //       title: "Title11",
  //       memo: "test memo",
  //       color: Colors.red.value,
  //       done: 0,
  //       category: "study",
  //       date: 20211029),
  //   Todo(
  //       title: "title2",
  //       memo: "test memo222222222",
  //       color: Colors.blue.value,
  //       done: 1,
  //       category: "study",
  //       date: 20211030)
  // ];
  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() {});
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            Todo todo = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TodoWritePage(
                    todo: Todo(
                        title: "",
                        category: "",
                        color: 0,
                        memo: "",
                        date: Utils.getFormatTime(DateTime.now()),
                        done: 0))));
            getTodayTodo();
          },
        ),
        body: getPage(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectIdx,
            onTap: (idx) {
              if (idx == 1) {
                getAllTodo();
              }
              setState(() {
                selectIdx = idx;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  label: "Today", icon: Icon(Icons.today_outlined)),
              BottomNavigationBarItem(
                  label: "Dairy", icon: Icon(Icons.assessment_outlined)),
              BottomNavigationBarItem(
                  label: "More", icon: Icon(Icons.more_horiz))
            ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget getPage() {
    if (selectIdx == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  Widget getMain() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: const Text(
                "Today",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ));
        } else if (idx == 1) {
          List<Todo> undone = todos.where((e) => e.done == 0).toList();
          return Container(
              child: Column(
                  children: List.generate(undone.length, (_idx) {
            Todo t = undone[_idx];
            return InkWell(
              child: TodoCardWiget(t: t),
              onTap: () async {
                setState(() {
                  if (t.done == 0) {
                    t.done = 1;
                  } else {
                    t.done = 0;
                  }
                });
                await dbHelper.insertTodo(t);
              },
              onLongPress: () async {
                getTodayTodo();
              },
            );
          })));
        } else if (idx == 3) {
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: const Text(
                "Completed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ));
        } else if (idx == 4) {
          List<Todo> done = todos.where((e) => e.done == 1).toList();
          return Container(
              child: Column(
                  children: List.generate(done.length, (_idx) {
            Todo t = done[_idx];
            return InkWell(
              child: TodoCardWiget(t: t),
              onTap: () async {
                setState(() {
                  if (t.done == 0) {
                    t.done = 1;
                  } else {
                    t.done = 0;
                  }
                });
                await dbHelper.insertTodo(t);
              },
              onLongPress: () async {
                Todo todo = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TodoWritePage(todo: t)));
                setState(() {});
              },
            );
          })));
        }

        return Container();
      },
      itemCount: 5,
    );
  }

  Widget getHistory() {
    return ListView.builder(
        itemBuilder: (ctx, idx) {
          return TodoCardWiget(t: allTodo[idx]);
        },
        itemCount: allTodo.length);
  }
}

class TodoCardWiget extends StatelessWidget {
  final Todo t;
  const TodoCardWiget({Key? key, required this.t}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDatetime(t.date);
    return Container(
      decoration: BoxDecoration(
          color: Color(t.color), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            t.title,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            t.done == 0 ? "Incompleted" : "Completed",
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          now == t.date
              ? Container()
              : Text(now == t.date ? "" : "${time.month}/ ${time.day}")
        ]),
        Container(height: 8),
        Text(t.memo, style: const TextStyle(color: Colors.white))
      ]),
    );
  }
}
