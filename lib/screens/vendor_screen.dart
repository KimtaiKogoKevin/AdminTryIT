import 'package:flutter/material.dart';
import 'package:tryit_admin/screens/widgets/vendors_list.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({Key? key}) : super(key: key);
  static const String id = 'vendors-screen';

  @override
  Widget build(BuildContext context) {
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

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        const Text(
          'Vendors',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
        ),
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
         VendorList()
      ]),
    );
  }
}
