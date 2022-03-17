import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: const MyHomePage(title: 'GDSC TODO'),
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
  final listKey = GlobalKey<AnimatedListState>();
  List<ListItem> items = List.from(listItems);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(widget.title),
        ),
        // body: Container(
        //   color: Colors.orange,
        //   child: Text('this is );
        // ),
        body: AnimatedList(
          key: listKey,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return ListItemWidget(
              item: items[index],
              animation: animation,
              onClicked: () => removeItem(index),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          mini: false,
          backgroundColor: Colors.orange,
          onPressed: insertItem,
          // tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void removeItem(int index) {
    final removedItem = items[index];

    items.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return ListItemWidget(
            animation: animation, item: removedItem, onClicked: () {});
      },
    );
  }
  

  Future<void> insertItem() async {
    String title = '';
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: const Text("Add Todo"),
          content: Container(
            width: 400,
            height: 100,
            child: Column(
              children: [
                TextField(
                  onChanged: (String value) {
                    title = value;
                  },
                ),
              ],
            ),
          ),
      ),
        );
    final newindex = 0;
    final newItem = ListItem(title: title);
    items.insert(newindex, newItem);
    listKey.currentState!.insertItem(newindex);
  }
}

class ListItem {
  final String title;
  const ListItem({required this.title});
}

final List<ListItem> listItems = [
  ListItem(title: 'homeWork'),
];

class ListItemWidget extends StatelessWidget {
  const ListItemWidget(
      {Key? key,
      required this.animation,
      required this.item,
      required this.onClicked})
      : super(key: key);
  final ListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  @override
  Widget build(BuildContext context) {
    return buildItem();
  }

  Widget buildItem() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.yellow),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          item.title,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red, size: 32),
          onPressed: onClicked,
        ),
      ),
    );
  }
}
