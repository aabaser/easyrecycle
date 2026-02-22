import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class VerificationGreen extends StatefulWidget {
  @override
  VerificationGreenState createState() => VerificationGreenState();
}

class VerificationGreenState extends State<VerificationGreen> {
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          _checkAndFocusFirstEmptyField(i);
        }
      });
    }
  }

  void _checkAndFocusFirstEmptyField(int currentIndex) {
    for (int i = 0; i <= currentIndex; i++) {
      if (controllers[i].text.isEmpty) {
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(),
      ),
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildContent(context),
          Positioned(
            top: 10,
            left: 10,
            child: _buildBackButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade800, Colors.green.shade400],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 340,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            SizedBox(height: 80),
            _buildTitle(context),
            SizedBox(height: 10),
            _buildInstructions(context),
            SizedBox(height: 30),
            _buildVerificationCodeInput(),
            Spacer(),
            _buildResendInfo(context),
            SizedBox(height: 100),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Verify Account",
      style: MyText.title(context)?.copyWith(color: Colors.white),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Text(
      "Please enter the verification code we sent to your email address",
      textAlign: TextAlign.center,
      style: MyText.body1(context)?.copyWith(color: Colors.white),
    );
  }

  Widget _buildVerificationCodeInput() {
    return Container(
      width: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) => _buildCodeInputField(index)),
      ),
    );
  }

  Widget _buildCodeInputField(int index) {
    return Flexible(
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '', // Hide the length counter
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.grey_10, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (index < 3) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            } else {
              focusNodes[index].unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
      ),
    );
  }

  Widget _buildResendInfo(BuildContext context) {
    return Column(
      children: [
        Text("I didn't receive the code",
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.transparent),
          child: Text(
            "Please Re-Send",
            style: MyText.subhead(context)?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            // Implement resend logic here
          },
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
