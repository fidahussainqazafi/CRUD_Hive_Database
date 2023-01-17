import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_databse/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Databse'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder:(context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString(), style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500
                          ),),
                          Spacer(),
                          InkWell(
                            onTap: (){
                              delete(data[index]);
                            },
                           child: Icon(Icons.delete, color: Colors.red,),
                          ),

                          SizedBox(width: 15,),
                          InkWell(
                            onTap: () {
                              _editMyDailog(data[index], data[index].title.toString(),
                                data[index].description.toString());

                            },
                            child: Icon(Icons.edit, color: Colors.green,),

                          )

                        ],
                      ),

                      Text(data[index].description.toString(),
              style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w100
              ),)
                    ],
                  ),
                ),
              );
          });

        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          _showMyDailog();
          var box = await Hive.openBox('Qazafi');
          var box2 = await Hive.openBox('name');


         box2.put('name2', 'Fida');
          box.put('name', 'Qazafi');
          box.put('age', 22);
          print(box.get('name'));
          print(box.get('age'));
        },
        child: Icon(Icons.add),
      ),

    );
  }



  void delete(NotesModel notesModel)async {
    await notesModel.delete();
  }



  Future<void> _editMyDailog(NotesModel notesModel, String title, String description)async{

    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            title: Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  )],
              ),
            ),

            actions: [
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('cancel')),

              TextButton(onPressed: ()async{

            notesModel.title = titleController.text.toString();
            notesModel.description = descriptionController.text.toString();

            notesModel.save();
            descriptionController.clear();
            titleController.clear();

                Navigator.pop(context);
              }, child: Text('Edit')),
            ],
          );
        }
    );
  }

  Future<void> _showMyDailog()async{
    return showDialog(
      context: context,
      builder:(context) {
        return AlertDialog(
          title: Text('Add Notes'),
         content: SingleChildScrollView(
           child: Column(
             children: [
               TextFormField(
                 controller: titleController,
                 decoration: InputDecoration(
                   hintText: 'Enter Title',
                   border: OutlineInputBorder(),
                 ),
               ),
               SizedBox(height: 20,),
          TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: 'Enter Description',
            border: OutlineInputBorder(),
          ),
          )],
           ),
         ),

          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text('cancel')),

            TextButton(onPressed: () {

              final data = NotesModel(title: titleController.text,
                  description: descriptionController.text);

              final box = Boxes.getData();
              box.add(data);
              
              // data.save();
               print(box);
               titleController.clear();
               descriptionController.clear();

              Navigator.pop(context);
            }, child: Text('Add')),
          ],
        );
      }
    );
  }

}
