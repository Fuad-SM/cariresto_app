import 'package:flutter/material.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/utils/const.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.png',
              width: MediaQuery.of(context).size.width - 60,
              height: 90,
            ),
            const SizedBox(height: 70),
            Text(
              'Where are you going?',
              style: blackTextStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 14),
            Text(
              'Seems like the page that you were\nrequested is already gone',
              style: greyTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: 210,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: yellowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, homeRoute, (route) => false),
                child: Text(
                  'Back to Home',
                  style: whiteTextStyle.copyWith(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
