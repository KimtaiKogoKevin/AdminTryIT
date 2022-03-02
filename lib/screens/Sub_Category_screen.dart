import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:tryit_admin/screens/widgets/categories_list_widget.dart';

import '../firebase_services.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'subCategory';

  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  final FirebaseService _service = FirebaseService();
  final TextEditingController _subCatController = TextEditingController();
  dynamic image;
  String? fileName;
  final storage = firebase_storage.FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  Object? _selectedValue;
  bool noCategorySelected = false;
  QuerySnapshot? snapshot;

  Widget _dropDownButton() {
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select parent of Sub Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
        }).toList(),
        onChanged: (selectedCat) {
          setState(() {
            _selectedValue = selectedCat;
            noCategorySelected = false;
          });
        });
  }
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      //failed to pick image
      print('Canceled');
    }
  }

  saveImageToDB()async{
    EasyLoading.show();
    var ref = storage.ref('subcategoryImage/$fileName');
    try {
      String? mimiType = mime(basename(fileName!),);
      var metaData = firebase_storage.SettableMetadata(contentType:mimiType);
      firebase_storage.TaskSnapshot uploadSnapshot = await ref.putData(image , metaData);
      //get download link of image stored in firestore
      String downloadURL = await uploadSnapshot.ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {

          _service.saveCategory(
              data:{
                'subCatName':_subCatController.text,
                'mainCategory':_selectedValue,
                'image':value,
                'active':true
              } ,
              docName: _subCatController.text,
              reference: _service.subCategories).then((value){
            //after save clear all the data from screen
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
      _subCatController.clear();
      image=null;
    });
  }

  @override
  void initState() {
    getMainCatList();
    super.initState();
  }

  getMainCatList() {
    return _service.mainCat.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot =   querySnapshot ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sub Category',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          Row(
            children: [
              Column(children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Center(
                    child: image == null
                        ? const Text('Sub Category Image')
                        : Image.memory(image),
                  ),
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
             Padding(
               padding: const EdgeInsets.fromLTRB(15,0,0,0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                 snapshot == null ? const Text('Loading...') :
                 _dropDownButton(),
                 const SizedBox(height: 8),
                 if (noCategorySelected == true)
                   const Text('No Sub Category Selected',
                       style: TextStyle(color: Colors.red)),
                 SizedBox(
                   width: 200,
                   child: TextFormField(
                     controller: _subCatController,
                     validator: (value) {
                       if (value!.isEmpty) {
                         return 'Enter Sub Category Name';
                       }
                     },
                     decoration: const InputDecoration(
                         label: Center(child: Text('Enter Sub Category Name')),
                         contentPadding: EdgeInsets.zero),
                   ),
                 ),
                 const SizedBox(width: 20),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     children: [
                       TextButton(
                         onPressed: clear,
                         child: Text('Cancel',
                             style: TextStyle(color: Theme.of(context).primaryColor)),
                         style: ButtonStyle(
                             side: MaterialStateProperty.all(
                                 BorderSide(color: Theme.of(context).primaryColor)),
                             backgroundColor: MaterialStateProperty.all(Colors.white)),
                       ),
                       const SizedBox(
                         width: 10,
                       ),
                       ElevatedButton(
                         onPressed: () {
                           if (_selectedValue == null) {
                             setState(() {
                               noCategorySelected = true;
                             });
                             return;
                           }
                           if (_formKey.currentState!.validate()) {
                             saveImageToDB();
                           }
                         },
                         child: const Text('Save'),
                         style: ButtonStyle(
                             side: MaterialStateProperty.all(
                                 BorderSide(color: Theme.of(context).primaryColor)),
                             backgroundColor: MaterialStateProperty.all(Colors.blue)),
                       ),
                     ],
                   ),
                 ),
               ],),
             )

            ],
          ),
          const Divider(color: Colors.grey),
          const SizedBox(height:10,),
           CategoriesList(
             reference: _service.subCategories,
           )
        ],
      ),
    );

  }
}
