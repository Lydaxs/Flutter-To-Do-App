import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/AddTodoPage.dart';
import 'package:to_do_list/EditTodoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeView();
}

class _HomeView extends State<HomePage> {
  late List<Map<String, Map<String, String>>>? todos;
  late List<Map<String, Map<String, String>>>? todosDone;

  void _loadTodos() {
    List<dynamic> storedTodos = GetStorage().read('todo') ?? [];
    List<dynamic> storedTodosDone = GetStorage().read('todoDone') ?? [];

    todos = storedTodos.map((item) {
      return (item as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, Map<String, String>.from(value as Map));
      });
    }).toList();

    todosDone = storedTodosDone.map((item) {
      return (item as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, Map<String, String>.from(value as Map));
      });
    }).toList();
  }

  void addTodo(Map<String, Map<String, String>> data) {
    setState(() {
      todos?.add(data);
      GetStorage().write('todo', todos);
    });
  }

  void addToDoDone(Map<String, Map<String, String>> data) {
    setState(() {
      todosDone?.add(data);
      GetStorage().write('todoDone', todosDone);
    });
  }

  void removeTodoById(String id) {
    setState(() {
      todos?.removeWhere((todo) => todo.containsKey(id));
      GetStorage().write('todo', todos);
    });
  }

  void removeTodoDoneById(String id) {
    setState(() {
      todosDone?.removeWhere((todo) => todo.containsKey(id));
      GetStorage().write('todoDone', todosDone);
    });
  }

  void updateTodo(String uuid, Map<String, String> value) {
    setState(() {
      int index = todos?.indexWhere((todo) => todo.containsKey(uuid)) ?? 1;

      todos?[index][uuid] = value;
      GetStorage().write('todo', todos);
    });
  }

  @override
  void initState() {
    print(GetStorage().read('todo'));
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    print(todos);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoPage(refreshTodo: addTodo),
              ));
        },
        tooltip: "Add new ToDo",
        backgroundColor: const Color.fromRGBO(87, 164, 120, 1.0),
        foregroundColor: const Color.fromRGBO(255, 240, 243, 1),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("My To Do List"),
            Text(
              DateFormat("d MMMM yyyy").format(DateTime.now()),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(122, 159, 121, 1),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      "To Do",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (todos!.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'To Do is Empty...',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: todos?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = todos?[index];
                        final uuid = item?.keys.first;
                        final todoItem = item?[uuid] as Map<String, String>;

                        final todo = todoItem['todo'] ?? '';
                        final deadline = todoItem['deadline'];
                        final date = todoItem['date'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Slidable(
                              startActionPane: ActionPane(motion: const ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditTodoPage(
                                                refreshTodo: updateTodo,
                                                oldTodo: todo,
                                                oldDeadline: deadline,
                                                uuid: uuid)));
                                  },
                                  backgroundColor: Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  icon: Icons.edit,
                                  label: "Edit",
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    removeTodoById(uuid!);
                                    addToDoDone({uuid: todoItem});
                                  },
                                  backgroundColor: const Color.fromRGBO(149, 213, 178, 1),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  icon: Icons.check,
                                  label: "Selesai",
                                ),
                              ]),
                              endActionPane: ActionPane(motion: const ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    removeTodoById(uuid!);
                                  },
                                  backgroundColor: Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  icon: Icons.delete,
                                  label: "Hapus",
                                ),
                              ]),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(177, 221, 158, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(todo),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Dibuat: $date"),
                                            if (deadline!.isNotEmpty)
                                              Text("Deadline: "
                                                  "$deadline")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }),
                Container(
                  width: double.infinity,
                  height: 1.8,
                  color: const Color.fromRGBO(89, 13, 34, 1),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      "Completed",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (todosDone!.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Completed ToDo is Empty...',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  )
                else
                  ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: todosDone?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = todosDone?[index];
                        final uuid = item?.keys.first;
                        final todoItem = item?[uuid] as Map<String, String>;

                        final todo = todoItem['todo'] ?? '';
                        final deadline = todoItem['deadline'];
                        final date = todoItem['date'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Slidable(
                              startActionPane: ActionPane(motion: const ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    removeTodoDoneById(uuid!);
                                  },
                                  backgroundColor: Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  icon: Icons.delete,
                                  label: "Hapus",
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    addTodo({uuid!: todoItem});
                                    removeTodoDoneById(uuid);
                                  },
                                  backgroundColor: Colors.yellow,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  icon: Icons.restore,
                                  label: "Undo",
                                ),
                              ]),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(153, 187, 0, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(todo),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Dibuat: $date"),
                                            if (deadline!.isNotEmpty)
                                              Text("Deadline: "
                                                  "$deadline")
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      })
              ],
            ),
          )
        ],
      ),
    );
  }
}
