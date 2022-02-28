import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tryit_admin/screens/widgets/main_categories_list_widget.dart';

import '../firebase_services.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'mainCategory';

  const MainCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _mainCat = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Object? _selectedValue;
  bool noCategorySelected = false;
  QuerySnapshot? snapshot;

  Widget _dropDownButton() {
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['catName'],
            child: Text(e['catName']),
          );
        }).toList(),
        onChanged: (selectedCat) {
          setState(() {
            _selectedValue = selectedCat;
            noCategorySelected = false;
          });
        });
  }

  clear() {
    setState(() {
      _selectedValue = null;
      _mainCat.clear();
    });
  }

  @override
  void initState() {
    getCatList();
    super.initState();
  }

  getCatList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
      snapshot =   querySnapshot ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Main Category  List',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(color: Colors.grey),
          snapshot == null ? const Text('Loading...') :
          _dropDownButton(),
          const SizedBox(height: 8),
          if (noCategorySelected == true)
            const Text('No Category Selected',
                style: TextStyle(color: Colors.red)),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: _mainCat,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Category Name';
                }
              },
              decoration: const InputDecoration(
                  label: Center(child: Text('Enter Category Name')),
                  contentPadding: EdgeInsets.zero),
            ),
          ),
          const SizedBox(width: 20),
          Row(
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
                    EasyLoading.show();
                    _service.saveCategory(
                      data: {
                        'category': _selectedValue,
                        'mainCategory': _mainCat.text,
                        'approved': true
                      },
                      reference: _service.mainCat,
                      docName: _mainCat.text,
                    ).then((value) {
                      clear();
                      EasyLoading.dismiss();
                    });
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
          const Divider(color: Colors.grey),
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
          const SizedBox(height: 10,),
          const MainCategoriesList()
        ]),
      ),
    );
  }
}
