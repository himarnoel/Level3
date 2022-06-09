import 'package:flutter/material.dart';

class Crud extends StatefulWidget {
  const Crud({Key? key}) : super(key: key);

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  final textController = TextEditingController();
  List<String> crudData = [];
  int theCurrentIndex = 0;
  bool isEditing = false;
  bool isSearching = false;

  delFunc(myId) {
    setState(() {
      crudData.removeAt(myId);
    });
  }

  editFunc(id) {
    setState(() {
      isEditing = true;
      theCurrentIndex = id;
      textController.text = crudData[id];
    });
  }

  createFunc() {
    if (textController.text.isNotEmpty) {
      setState(() {
        crudData.add(textController.text);
        textController.clear();
      });
    }
  }

  edit() {
    setState(() {
      if (textController.text.isNotEmpty) {
        crudData[theCurrentIndex] = textController.text;
        isEditing = false;
        textController.clear();
      }
    });
  }

  initializeSearch() {
    setState(() {
      isSearching = true;
    });
  }

  startSearching() {
    List<String> data = crudData
        .where(
          (element) =>
              element.toLowerCase().contains(textController.text.toLowerCase()),
        )
        .toList();

    return data.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CRUD'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: initializeSearch,
            )
          ],
        ),
        body: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  onEditingComplete: (){

                  },
                  decoration: InputDecoration(
                      hintText: isEditing
                          ? "start edit"
                          : isSearching
                              ? "Start searching"
                              : 'create data'),
                  controller: textController,
                  onChanged: (val) {
                    setState(() {
                      isSearching ? startSearching : null;
                    });
                  },
                ),
              ),

              isSearching ? SizedBox.shrink():
              IconButton(
                onPressed: isEditing ? edit : createFunc,
                icon: Icon(Icons.send),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isSearching ? startSearching() : crudData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(crudData[index], overflow: TextOverflow.ellipsis,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => editFunc(index)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => delFunc(index))
                    ],
                  ),
                );
              },
            ),
          )
        ]));
  }
}
