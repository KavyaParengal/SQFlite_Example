
import 'package:flutter/material.dart';
import 'package:sqflitetask/sqlhelper.dart';

class HomePage_Sqflite extends StatefulWidget {
  const HomePage_Sqflite({Key? key}) : super(key: key);

  @override
  State<HomePage_Sqflite> createState() => _HomePage_SqfliteState();
}

class _HomePage_SqfliteState extends State<HomePage_Sqflite> {

  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();

  List<Map<String,dynamic>> _datas=[];
  bool isLoading=true;

  void _refreshdata() async {
    final data=await SQLHelper.getItem();
    setState(() {
      _datas=data;
      print(_datas);
      isLoading=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshdata();
  }

  void _showForm(int? id) async{
    if(id!=null){
      final existingData= _datas.firstWhere((element) => element['id'] == id);
      titleController.text=existingData["title"];
      descriptionController.text=existingData["description"];
    }

    showModalBottomSheet (
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                top: 16,
                left: 16,
                right: 16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title', // Use labelText for labels
                  ),),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description', // Use labelText for labels
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async{
                      if(id==null){
                        await _addItem();
                      }
                      if(id!=null){
                        await _updateItem(id);
                      }

                      titleController.text='';
                      descriptionController.text='';

                      Navigator.pop(context);
                    },
                    child: Text(id==null?'Create New':'Update', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade900,fixedSize: Size.fromHeight(50)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addItem() async{
    await SQLHelper.createItem(titleController.text, descriptionController.text);
    _refreshdata();
  }

  Future<void> _updateItem(int id) async{
    await SQLHelper.updateItem(id,titleController.text, descriptionController.text);
    _refreshdata();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully deleted")));
    _refreshdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showForm(null);
        },
        child: Icon(Icons.add,size: 30,),
        backgroundColor: Colors.teal.shade900,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('SQL Helper',style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),),
        toolbarHeight: 65,
        backgroundColor: Colors.teal.shade900,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) :ListView.builder(
          itemCount: _datas.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height*.15,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          offset: Offset(2, 3),
                          blurRadius: 1,
                          spreadRadius: 2
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_datas[index]["title"],style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                            ),),
                            SizedBox(height: 5,),
                            Expanded(
                              child: Text(_datas[index]["description"],style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey.shade300,
                                  fontWeight: FontWeight.w400,
                              ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            _showForm(_datas[index]["id"]);
                          },
                              icon: Icon(Icons.edit,size: 28,color: Colors.grey.shade300,)
                          ),
                          IconButton(onPressed: (){
                            _deleteItem(_datas[index]["id"]);
                          },
                              icon: Icon(Icons.delete,size: 28,color: Colors.grey.shade300,)
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
                top: 16,
                left: 16,
                right: 16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title', // Use labelText for labels
                  ),),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description', // Use labelText for labels
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Create New', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade900,fixedSize: Size.fromHeight(50)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
