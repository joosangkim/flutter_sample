import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/diary.dart';

class DiaryWritePage extends StatefulWidget {
  final Diary diary;

  DiaryWritePage({Key? key, required this.diary}) : super(key: key);

  @override
  _DiaryWritePageState createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  int imgIdx = 0;
  List<String> images = [
    "assets/img/b1.jpg",
    "assets/img/b2.jpg",
    "assets/img/b3.jpg"
  ];
  int statusIdx = 0;
  List<String> status = [
    "assets/img/ico-weather.png",
    "assets/img/ico-weather_2.png",
    "assets/img/ico-weather_3.png"
  ];

  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentsTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView.builder(itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              width: 70,
              height: 70,
              child: Image.asset(
                widget.diary.image!,
                fit: BoxFit.cover,
              ),
            ),
            onTap: () {
              widget.diary.image = images[imgIdx];
              imgIdx++;
              imgIdx = imgIdx % images.length;
            },
          );
        } else if (idx == 1) {
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                status.length,
                (_idx) => InkWell(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Image.asset(status[_idx]),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _idx == widget.diary.status
                                    ? Colors.blue
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onTap: () {
                        setState(() {
                          widget.diary.status = _idx;
                        });
                      },
                    )),
          );
        } else if (idx == 2) {
          return Container(
              child: Text("Title", style: TextStyle(fontSize: 16)));
        } else if (idx == 3) {
          return Container(
            child: TextField(
              controller: titleTextController,
              minLines: 10,
              maxLines: 20,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ),
          );
        } else if (idx == 4) {
          return Container(
              child: Text("Contents", style: TextStyle(fontSize: 16)));
        }

        return Container();
      }),
    );
  }
}


//  if (idx == 0) {
//           return Container(child:Image.asset(widget.diary.image), onTap(){
//             List<String> images= ["assets/img/b1.jpg","assets/img/b2.jpg","assets/img/b3.jpg"]
//           })
//         }
//         return Co