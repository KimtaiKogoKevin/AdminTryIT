import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../firebase_services.dart';

class CategoriesList extends StatelessWidget {
  final CollectionReference reference;
  const CategoriesList({ required this.reference ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    
    Widget categoryWidget(data){
      return Card(
        color: Colors.grey.shade400,
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                const SizedBox(height: 20,),
                Image.network(data['image']),
                Text(reference == _service.categories ? data['catName'] : data['subCatName']),
              ]
          ),
        ),
      );

    }
    return StreamBuilder<QuerySnapshot>(
      stream: reference.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.data!.size==0){
          return const Text("No Categories Added");
        }

        return GridView.builder(
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3
            ),
            itemCount:snapshot.data!.size,
            itemBuilder: (context,index){
             var data = snapshot.data!.docs[index];
             return categoryWidget(data);

            });
      },
    );
  }
}
