import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/provider/preferences_provider.dart';
import 'package:restaurant_app/data/provider/scheduling_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: StaggeredAnimation(
                  offset: -20,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text.rich(
                        TextSpan(
                          text: 'Set',
                          style: yellowTextStyle.copyWith(fontSize: 22),
                          children: [
                            TextSpan(
                              text: 'tings',
                              style: blackTextStyle.copyWith(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Notification',
                          style: blackTextStyle.copyWith(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Get Information Restaurant\nEvery Day',
                          style: greyTextStyle.copyWith(fontSize: 12),
                        ),
                        trailing: Consumer<SchedulingProvider>(
                          builder: (context, scheduled, _) {
                            return Switch.adaptive(
                              value: preferences.isDailyRestaurantActive,
                              onChanged: (value) async {
                                scheduled.scheduledRestaurant(value);
                                preferences.enabledDailyNews(value);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Text(
                        preferences.isStartedActive!,
                        style: greyTextStyle.copyWith(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
