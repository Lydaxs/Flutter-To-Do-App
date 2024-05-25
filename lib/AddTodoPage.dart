import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({super.key, required this.refreshTodo});

  final Function refreshTodo;

  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController todo = TextEditingController();
  final TextEditingController deadline = TextEditingController();

  @override
  State<AddTodoPage> createState() => _AddTodoView();
}

class _AddTodoView extends State<AddTodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Add To Do", style: TextStyle(color: Color.fromRGBO(201, 24, 74, 1))),
            Text(
              DateFormat("d MMMM yyyy").format(DateTime.now()),
              style: const TextStyle(color: Color.fromRGBO(201, 24, 74, 1), fontSize: 18),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(255, 135, 171, 1),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: widget._formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "ToDo",
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "ToDo",
                      ),
                      controller: widget.todo,
                      validator: FormBuilderValidators.required(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FormBuilderDateTimePicker(
                        name: "Deadline",
                        controller: widget.deadline,
                        decoration: const InputDecoration(
                          labelText: "Deadline (optional)",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                          onPressed: () {
                            if (widget._formKey.currentState?.saveAndValidate() ?? false) {
                              widget.refreshTodo({
                                const Uuid().v4(): {
                                  "todo": widget.todo.text,
                                  "deadline": widget.deadline.text,
                                  'date': DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now())
                                }
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 0),
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: const Color.fromRGBO(255, 240, 243, 1)),
                          child: const Text("Save")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
