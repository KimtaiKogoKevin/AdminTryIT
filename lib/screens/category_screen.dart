import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:tryit_admin/firebase_services.dart';
import 'package:tryit_admin/screens/widgets/categories_list_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseService _service =FirebaseService();
  final TextEditingController _catName =  TextEditingController();
  dynamic image;
  String? fileName;
  final storage = firebase_storage.FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();

  pickImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image ,allowMultiple:false
    );
    if(result!=null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }else{
        //failed to pick image
      print('Canceled');
    }

  }

  saveImageToDB()async{
    EasyLoading.show();
    var ref = storage.ref('categoryImage/$fileName');
    try {
      String? mimiType = mime(basename(fileName!),);
      var metaData = firebase_storage.SettableMetadata(contentType:mimiType);
      firebase_storage.TaskSnapshot uploadSnapshot = await ref.putData(image , metaData);
      //get download link of image stored in firestore
      String downloadURL = await uploadSnapshot.ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {

          _service.saveCategory(
              data:{
            'catName':_catName.text,
            'image':value,
            'active':true
          } ,
          docName: _catName.text,
          reference: _service.categories).then((value){
            //
            clear();
            EasyLoading.dismiss();

          });
        }
        return value;


      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      clear();
      //print(e.toString());
    }
  }

  clear(){
    setState(() {
      _catName.clear();
      image=null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Create Category',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(children: [
              Column(children: [
                const SizedBox(width:10,),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child:Center(child: image==null ?  Text('Category Image') : Image.memory(image),),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text('Upload Image'),
                )
              ]),
              const SizedBox(width: 20),
               SizedBox(
                width: 200,
                child: TextFormField(
                  controller:_catName,
                  validator:(value){
                    if(value!.isEmpty){
                      return 'Enter Category Name';
                    }
                  },
                  decoration: const InputDecoration(
                      label: Center(child: Text('Enter Category Name')),
                      contentPadding: EdgeInsets.zero),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: clear,
                child: Text('Cancel',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).primaryColor)),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
              ) ,
              const SizedBox(width:10,),
             image == null ? Container() : ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    saveImageToDB();

                  }
                },
                child: const Text('Save'),
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).primaryColor)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
              ) ,
            ]),
            const Divider(
              color: Colors.grey,
            ) ,
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const SizedBox(height:10,),
            const Categories_List()

          ]),
    );
  }
}
