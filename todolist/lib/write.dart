import 'package:flutter/material.dart';
import 'package:todolist/data/database.dart';

import 'data/todo.dart';

class TodoWritePage extends StatefulWidget {
  final Todo todo;

  const TodoWritePage({Key? key, required this.todo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoWritePageState();
  }
}

class _TodoWritePageState extends State<TodoWritePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  int colorIdx = 0;
  int ctIdx = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                // saving page
                widget.todo.title = nameController.text;
                widget.todo.memo = memoController.text;
                await dbHelper.insertTodo(widget.todo);
                Navigator.of(context).pop(widget.todo);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: const Text("Title", style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            );
          } else if (idx == 1) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: TextField(
                  controller: nameController,
                ));
          } else if (idx == 2) {
            return InkWell(
                onTap: () {
                  List<Color> colors = [
                    Color(0xff80d3f4),
                    Color(0xffa794fa),
                    Color(0xfffb91d1),
                    Color(0xfffb8a94),
                    Color(0xfffebd9a),
                    Color(0xff51e29d),
                    Color(0xffffffff),
                  ];
                  widget.todo.color = colors[colorIdx].value;
                  colorIdx++;
                  setState(() {
                    colorIdx = colorIdx % colors.length;
                  });
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Color", style: TextStyle(fontSize: 20)),
                        Container(
                          width: 10,
                          height: 10,
                          color: Color(widget.todo.color),
                        )
                      ],
                    )));
          } else if (idx == 3) {
            return InkWell(
                onTap: () {
                  List<String> categories = ["Workout", "Study", "Game"];
                  widget.todo.category = categories[ctIdx];
                  ctIdx++;
                  setState(() {
                    ctIdx = ctIdx % categories.length;
                  });
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category", style: TextStyle(fontSize: 20)),
                        Text(widget.todo.category)
                      ],
                    )));
          } else if (idx == 4) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text("Memo", style: TextStyle(fontSize: 20)));
          } else if (idx == 5) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: TextField(
                  maxLines: 10,
                  minLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  controller: memoController,
                ));
          }

          return Container();
        },
        itemCount: 6,
      ),
    );
  }
}
