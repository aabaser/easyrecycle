import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

import '../about/onboding_screen.dart';

class VerificationImage extends StatefulWidget {
  @override
  VerificationImageState createState() => VerificationImageState();
}

class VerificationImageState extends State<VerificationImage> {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildOverlay(),
          _buildContent(context),
          _buildBackButton(context),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  /*Widget _buildBackground() {
    return Image.asset(
      Img.get('3d.png'),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }*/
  Widget _buildBackground() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: ZoomableRotatingImage(
        imageUrl: 'assets/images/3d.png',
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50),
            _buildLogo(),
            SizedBox(height: 10),
            _buildTitle(context),
            SizedBox(height: 20),
            _buildSubtitle(context),
            SizedBox(height: 10),
            _buildTextField(),
            if (hasError) _buildErrorText(),
            SizedBox(height: 15),
            _buildInstructions(context),
            SizedBox(height: 10),
            _buildResendButton(),
            SizedBox(height: 10),
            _buildContinueButton(),
            SizedBox(height: 5),
            _buildSignInButton(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      Img.get('logo_f.png'),
      color: Colors.white,
      width: 80,
      height: 80,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Welcome to UiX",
      style: MyText.title(context)?.copyWith(color: MyColors.grey_10),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      "Enter Code",
      style: MyText.subhead(context)?.copyWith(color: MyColors.grey_20),
    );
  }

  Widget _buildTextField() {
    return TextField(
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: hasError ? Colors.red : Colors.white, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: hasError ? Colors.red : Colors.white, width: 2),
        ),
      ),
      onChanged: (value) {
        setState(() {
          hasError = false;
          errorMessage = '';
        });
      },
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Text(
      "We sent the confirmation code to your mobile. Please check your inbox.",
      textAlign: TextAlign.center,
      style: MyText.body2(context)?.copyWith(color: MyColors.grey_20),
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: Colors.transparent),
      child: Text("RESEND", style: TextStyle(color: Colors.white)),
      onPressed: () {
        // Implement the resend code logic here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Code resent"),
          duration: Duration(seconds: 2),
        ));
      },
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: Text(
          "CONTINUE",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: isLoading ? null : _onContinuePressed,
      ),
    );
  }

  void _onContinuePressed() {
    setState(() {
      isLoading = true;
    });

    // Simulate a network request
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = "Invalid code. Please try again.";
      });
    });
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 20,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.transparent),
        child: Text(
          "Already have an account? Sign In",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
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

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
