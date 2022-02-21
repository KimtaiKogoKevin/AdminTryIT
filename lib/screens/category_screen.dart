import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  static const String id = 'category';

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category Screen',
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
                child: const Center(child: Text('Category Image')),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Upload Image'),
              )
            ]),
            const SizedBox(width: 20),
            const SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                    label: Center(child: Text('Enter Category Name')),
                    contentPadding: EdgeInsets.zero),
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {},
              child: Text('Cancel',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      BorderSide(color: Theme.of(context).primaryColor)),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ) ,
            const SizedBox(width:10,),
            ElevatedButton(
              onPressed: () {},
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
        ]);
  }
}
