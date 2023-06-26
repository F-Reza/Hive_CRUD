import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hive_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 final titleCtr = TextEditingController();
 final taskCtr = TextEditingController();

 @override
  void dispose() {
   titleCtr.dispose();
   taskCtr.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Provider.of<HiveServiceProvider>(context, listen: false).getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(context, null);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<HiveServiceProvider>(
        builder: (context, provider, _) {
          var taskList = provider.taskList;
          return taskList.isEmpty ?
          const Center(child: Text('isEmpty!')):
          ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, i)  {
                final item = taskList[i];
                return Card(
                  elevation: 5,
                  color: Colors.grey,
                  child: ListTile(
                    onTap: () {
                     //
                    },
                    leading: const Icon(Icons.task_outlined,size: 30,),
                    title: Text(item['title'],style: const TextStyle(fontSize: 16,)),
                    subtitle: Text(item['task']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              showForm(context, item['key']);
                            },
                            icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            provider.deleteData(item['key']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              }

          );
        },
      ),
    );
  }

  showForm(context, int? key) async{

   final provider = Provider.of<HiveServiceProvider>(context, listen: false);
   if(key != null) {
     final item = provider.taskList.firstWhere((e) => e['key'] == key);
     titleCtr.text = item['title'];
     taskCtr.text = item['task'];
   }else {
     titleCtr.clear();
     taskCtr.clear();
   }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.fromLTRB(12,12,12, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtr,
                decoration: const InputDecoration(
                    hintText: 'Enter title'
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: taskCtr,
                decoration: const InputDecoration(
                    hintText: 'Enter task'
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () => insetData(key),
                child: Text(key == null ? 'Add Task' : 'Update Data' ,),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        )
    );
  }

  insetData(int? key) async {
    final provider = Provider.of<HiveServiceProvider>(context, listen: false);
    if (titleCtr.text.isNotEmpty && taskCtr.text.isNotEmpty) {
      var data = {
        'title' : titleCtr.text,
        'task' : taskCtr.text,
      };

      if( key == null) {
        provider.insertData(data);
      } else {
        provider.updateData(key, data);
      }

      Navigator.pop(context);
      titleCtr.clear();
      taskCtr.clear();
    }
 }


}
