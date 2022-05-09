import 'package:flutter/material.dart';
import 'package:tryit_admin/screens/widgets/vendors_list.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({Key? key}) : super(key: key);
  static const String id = 'vendors-screen';

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  Widget _rowHeader({int? flex, String? text}) {
    return Expanded(
        flex: flex!,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade500),
              color: Colors.grey.shade100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
   bool? selectedButton;
  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
           const Text(
            'Vendors',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
              Container(
                child:Row(
                  children:[
                    ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(selectedButton==true ?Theme.of(context).primaryColor:Colors.grey)
                      ),
                        onPressed: (){
                        setState(() {
                          selectedButton=true;
                        });
                        }, child: Text('Approved')),
                    const SizedBox(width: 10),
                    ElevatedButton( style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(selectedButton==false ?Theme.of(context).primaryColor:Colors.grey)
                    ),
                        onPressed: (){
                      setState(() {
                        selectedButton=false;
                      });
                        }, child: const Text('Not Approved',)),
                    const SizedBox(width: 10),
                    ElevatedButton( style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(selectedButton==null ?Theme.of(context).primaryColor:Colors.grey)
                    ),
                        onPressed: (){
                      setState(() {
                        selectedButton=null;
                      });
                        }, child: Text('All')),
                    const SizedBox(width: 10),



                  ]
                )
              )
        ]),
            const SizedBox(width: 10),

            Row(
          children: [
            _rowHeader(flex: 1, text: 'Logo'),
            _rowHeader(flex: 3, text: 'Business Name '),
            _rowHeader(flex: 2, text: 'City'),
            _rowHeader(flex: 2, text: 'State'),
            _rowHeader(flex: 1, text: 'Action'),
            _rowHeader(flex: 1, text: 'View More'),
          ],
        ),
        VendorList(
          approvedStatus: selectedButton,
        )
      ]),
    );
  }
}
