import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class PaymentForm extends StatefulWidget {
  PaymentForm();

  @override
  PaymentFormState createState() => new PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text("Add new card"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 15),
            Row(
              children: <Widget>[
                Spacer(),
                Image.asset(Img.get("ic_visa_new.png"), width: 35, height: 35),
                Container(width: 5),
                Image.asset(Img.get("ic_mastercard_new.png"),
                    width: 35, height: 35),
                Container(width: 10),
              ],
            ),
            Container(height: 10),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller:
                        TextEditingController(text: "4111 1111 1111 1111"),
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Credit card number",
                    ),
                  ),
                  Container(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: "08/25"),
                          maxLines: 1,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Valid until (MM/YY)",
                          ),
                        ),
                      ),
                      Container(width: 10),
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          minLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "3-digit CVV",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 10),
                  TextField(
                    controller: TextEditingController(text: "Betty L"),
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Name on card",
                    ),
                  ),
                  Container(height: 15),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                  "By tapping the button, you agree to FlutterUiX Term & Condition and Privacy Policy.",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
                child: Text("Add Card",
                    style:
                        MyText.medium(context).copyWith(color: Colors.green)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
