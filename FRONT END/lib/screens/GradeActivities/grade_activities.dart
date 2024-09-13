// ignore_for_file: unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:student/constants/global_variables.dart';

class ActivitiesCardListView extends StatefulWidget {
  const ActivitiesCardListView({Key? key}) : super(key: key);

  @override
  _ActivitiesCardListViewState createState() => _ActivitiesCardListViewState();
}

class _ActivitiesCardListViewState extends State<ActivitiesCardListView> {
  Map<String, bool> cardExpandedMap = {};
  double? amount;
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Activities').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            String subject = data['subject'] ?? 'No Subject';
            String grade = data['grade'] ?? 'No Grade';
            String title = data['title'] ?? 'No Title';
            String information = data['information'] ?? '';
            String pay = data['pay'] ?? '';

            bool isExpanded = cardExpandedMap[document.id] ?? false;

            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('$subject - $grade'),
                    subtitle: Text(title),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<bool>(
                        value: isExpanded,
                        icon: const Icon(Icons.expand_more),
                        onChanged: (bool? newValue) {
                          setState(() {
                            cardExpandedMap[document.id] = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('Less'),
                          ),
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('More'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(information),
                        ),
                        if (pay == 'yes')
                          ElevatedButton(
                            onPressed: () {
                              // Handle button click
                              _showPaymentDialog();
                            },
                            child: const Text('Pay Now'),
                          ),
                      ],
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value);
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                //lipaNaMpesa(userPhone: phoneNumber, amount: amount!);
                // Handle payment logic here using amount and phoneNumber variables
                startCheckout(userPhone: phoneNumber, amount: amount!);
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  Future<void> startCheckout(
      {required String userPhone, required double amount}) async {
    //Preferably expect 'dynamic', response type varies a lot!
    dynamic transactionInitialisation;
    //Better wrap in a try-catch for lots of reasons.
    try {
      //Run it
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: "174379",
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: amount,
              partyA: userPhone,
              partyB: "174379",
              callBackURL: Uri(
                  scheme: "https", host: "1234.1234.co.ke", path: "/1234.php"),
              accountReference: "shoe",
              phoneNumber: userPhone,
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "purchase",
              passKey: mPasskey);

      print("TRANSACTION RESULT: $transactionInitialisation");

      //You can check sample parsing here -> https://github.com/keronei/Mobile-Demos/blob/mpesa-flutter-client-app/lib/main.dart

      /*Update your db with the init data received from initialization response,
      * Remaining bit will be sent via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: $e");

      /*
      Other 'throws':
      1. Amount being less than 1.0
      2. Consumer Secret/Key not set
      3. Phone number is less than 9 characters
      4. Phone number not in international format(should start with 254 for KE)
       */
    }
  }

  Future<void> lipaNaMpesa(
      {required String userPhone, required double amount}) async {
    dynamic transactionInitialization;
    try {
      transactionInitialization =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
        businessShortCode: "174379",
        transactionType: TransactionType.CustomerPayBillOnline,
        amount: amount,
        partyA: userPhone,
        partyB: "174379", // Lipa na Mpesa Online ShortCode
        callBackURL: Uri(), // Modify this to the correct URL
        accountReference: "school activities payment",
        phoneNumber: userPhone,
        baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
        transactionDesc: "purchase",
        passKey: mPasskey, // Modify this to the correct passkey
      );

      print("RESULTS: $transactionInitialization");
      return transactionInitialization;
    } catch (e) {
      print("CAUGHT EXCEPTION: $e");
    }
  }
}
