import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  Vendor({
    this.approved,
    this.businessName,
    this.city,
    this.shopImage,
    this.logoImage,
    this.country,
    this.email,
    this.kraPin,
    this.landMark,
    this.phoneNumber,
    this.state,
    this.taxRegistered,
    this.time,
    required this.uid});

  Vendor.fromJson(Map<String, Object?> json) : this(
    approved: json['approved']! as bool,
    businessName: json['businessName']! as String,
    city: json['city']! as String,
    shopImage: json['shopImage']! as String,
    logoImage: json['logoImage']! as String,
    country: json['country']! as String,
    email: json['email']! as String,
    kraPin: json['kraPin']! as String,
    landMark: json['landMark']! as String,
    state: json['state']! as String,
    taxRegistered: json['taxRegistered']! as String,
    time: json['time']! as Timestamp,
    uid: json['uid']! as String,

  );

  final bool? approved;
  final String? businessName;
  final String? city;
  final String? shopImage;
  final String? logoImage;
  final String? country;
  final String? email;
  final String? kraPin;
  final String? landMark;
  final String? phoneNumber;
  final String? state;
  final String? taxRegistered;
  final Timestamp? time;
  final String? uid;

  Map<String, Object?> toJson() {
    return {
      'approved': false,
      'businessName': businessName,
      'city': city,
      'country': country,
      'email': email,
      'kraPin': kraPin,
      'landMark': landMark,
      'logoImage': logoImage,
      'phoneNo': phoneNumber,
      'shopImage': shopImage,
      'state': state,
      'taxRegistered': taxRegistered,
      'time': time,
      'uid': uid,


    };
  }


}