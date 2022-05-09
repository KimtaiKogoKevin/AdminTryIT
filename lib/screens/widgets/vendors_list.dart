import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tryit_admin/firebase_services.dart';

import '../../models/vendor_model.dart';

class VendorList extends StatelessWidget {
  final bool?   approvedStatus;
  const VendorList({Key? key , this.approvedStatus}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget _vendorData({int? flex, String? text, Widget? widget}) {
      return Expanded(
        flex: flex!,
        child: Container(
          height: 116,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget ?? Text(text!),
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _service.Vendor.where('approved',isEqualTo: approvedStatus).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if(snapshot.data!.size==0){
          return const Center ( child:Text('No vendors to display',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (BuildContext context, int index) {
            Vendor vendor = Vendor.fromJson(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _vendorData(
                    flex: 1,
                    widget: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(vendor.logoImage!))),
                _vendorData(flex: 3, widget: Text(vendor.businessName!)),
                _vendorData(flex: 2, widget: Text(vendor.city!)),
                _vendorData(flex: 2, widget: Text(vendor.state!)),
                _vendorData(
                    flex: 1,
                    widget: vendor.approved == true
                        ? ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              EasyLoading.show;
                              _service.updateData(
                                  data: {'approved': false},
                                  docName: vendor.uid!,
                                  reference: _service.Vendor).then((value) =>EasyLoading.dismiss());
                            },
                            child: const FittedBox(child:Text(
                              'Reject',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )))
                        : ElevatedButton(
                            onPressed: () {
                              EasyLoading.show();
                              _service.updateData(
                                  data: {'approved': true},
                                  docName: vendor.uid!,
                                  reference: _service.Vendor) .then((value) => EasyLoading.dismiss());
                            },
                            child: const FittedBox(child: FittedBox(child: Text('Accept'))))),
                _vendorData(
                    flex: 1,
                    widget: ElevatedButton(
                        onPressed: () {},
                        child: const Center(
                            child: Text('View More',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14))))),
              ],
            );
          },
        );
      },
    );
  }
}
