import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/common/theme/theme.dart';

class ResultStateAlert {
  static loading(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [yellowColor],
          strokeWidth: 2,
        ),
      ),
    );
  }

  static noData(String message) {
    return Center(
      child: Text(message, style: regularBlackTextStyle),
    );
  }

  static error() {
    return Center(
      child: Lottie.asset('assets/json/no-internet-connection.json'),
    );
  }
}

class SearchAlert extends StatelessWidget {
  final String message;
  final String lottie;
  final double width;
  final double height;

  const SearchAlert(
      {required this.lottie,
      required this.width,
      required this.height,
      required this.message,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 4),
        Lottie.asset(
          lottie,
          height: height,
          width: width,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            message,
            style: greyTextStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
