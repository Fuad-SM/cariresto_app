import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _backgroundService.someTask());
    _notificationHelper.configureSelectNotificationsSubject();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: logoTextStyle.copyWith(fontSize: 25),
      bodyTextStyle: greyTextStyle.copyWith(fontSize: 16),
      descriptionPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          pages: [
            PageViewModel(
              title: 'Brows App\nand Order Now',
              body:
                  'We have many recipes for you\nGo and select food what you want.',
              image: Image.asset('assets/images/girl_phone.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: 'Best Delicious\nFood in your Area',
              body: 'We provide best food to our\ncustomer healthy and organic',
              image: Image.asset('assets/images/noodle.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: 'We Provide Fast\nFood Service',
              body:
                  'We provide organic food service\n our customer from anywhere',
              image: Image.asset('assets/images/beefsteak.png'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => Navigator.pushReplacementNamed(context, homeRoute),
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: Text(
            'Skip',
            style: yellowTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          next: const Icon(Icons.arrow_forward),
          done: Text(
            'Next',
            style: yellowTextStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeColor: Color(0xffFEB801),
            activeSize: Size(24.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
