import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:test_mobile_app/app/database/models.dart';
import 'package:test_mobile_app/app/services/api.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _status = 'pendiente';
  late final HomeStore store;
  bool _isLoading = true;
  Tasks? selectedTask;
  bool isEditing = false;
  bool isItemSelected = false;

  @observable
  ObservableList<Tasks> tasks = ObservableList<Tasks>();

  @override
  void initState() {
    super.initState();
    store = Modular.get<HomeStore>();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    await store.fetchTasks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 60.0),
                child: Text(
                  'Tarefas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _isLoading ? _buildLoadingIndicator() : _buildTaskList(),
              ),
            ],
          ),
          if (selectedTask == null && !isEditing && !isItemSelected)
            Positioned(
              bottom: 22.0,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _showAddTaskModal(context);
                    },
                    label: const Text(
                      'Adicionar nova tarefa',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    backgroundColor: const Color(0xFF0059FF),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF0059FF)),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: store.tasks.length,
      itemBuilder: (context, index) {
        var task = store.tasks[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              isItemSelected = true;
              task.isSelected = !task.isSelected;
              if (!isEditing) {
                if (selectedTask == task) {
                  selectedTask = null;
                } else {
                  selectedTask = task;
                }
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: task.isSelected && isEditing ? 340.0 : (isEditing ? 100.0 : 100.0),
            decoration: BoxDecoration(
              color: task.isSelected ? Color(0xFF0059FF) : Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: task.isSelected && isEditing ? _buildEditTaskWidget(task) : _buildTaskListTile(task),
          ),
        );
      },
    );
  }

  Widget _buildEditTaskWidget(Tasks task) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Título',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            controller: TextEditingController(text: task.title),
            onChanged: (value) {
              task.title = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Descrição',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            controller: TextEditingController(text: task.description),
            onChanged: (value) {
              task.description = value;
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: task.status,
            decoration: const InputDecoration(
              labelText: 'Status',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (String? value) {
              setState(() {
                task.status = value!;
              });
            },
            items: <String>['pendiente', 'completada'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await updateTask(task.id, {
                    'title': task.title,
                    'description': task.description,
                    'status': task.status,
                  });
                  store.clean();
                  await store.fetchTasks();
                  setState(() {
                    _isLoading = false;
                  });
                  task.isSelected = false;
                  selectedTask = null;
                  isEditing = false;
                  isItemSelected = false;
                },
                child: const Text('Atualizar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = false;
                  });
                  task.isSelected = false;
                  selectedTask = null;
                  isEditing = false;
                  isItemSelected = false;
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListTile(Tasks task) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          color: task.isSelected ? Colors.white : Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.description,
            style: TextStyle(color: task.isSelected ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 4),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.status == 'completada' ? Colors.green : task.status == 'pendiente' ? Colors.yellow : Colors.yellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.status,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (task.isSelected)
            IconButton(
              onPressed: () async {
                setState(() {
                  isEditing = true;
                });
                selectedTask = task;
              },
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          if (task.isSelected)
            IconButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await store.deleteTask(task.id);
                await fetchTasks();
                setState(() {
                  _isLoading = false;
                });
              },
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Future<void> _showAddTaskModal(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.60,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    onChanged: (String? value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                    items: const <String>['pendiente', 'completada']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final Map<String, dynamic> taskData = {
                              'title': _titleController.text,
                              'description': _descriptionController.text,
                              'status': _status
                            };
                            await store.clean();
                            await store.fetchTasks();
                            setState(() {
                              _isLoading = false;
                            });
                            _titleController.clear();
                            _descriptionController.clear();
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0059FF),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Adicionar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
