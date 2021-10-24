import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/provider/database_provider.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DatabaseProvider>(
        builder: (context, state, widget) {
          if (state.state == ResultState.HasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StaggeredAnimation(
                    offset: -20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Fav',
                          style: yellowTextStyle.copyWith(fontSize: 22),
                          children: [
                            TextSpan(
                              text: 'orites',
                              style: blackTextStyle.copyWith(fontSize: 22),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: state.favorite.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(state.favorite[index]),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Delete Confirmation",
                                      style: logoTextStyle,
                                    ),
                                    content: Text(
                                      "Are you sure you want to delete this item?",
                                      style: greyTextStyle,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          state.removeFavoriteResto(
                                              state.favorite[index].id!);
                                          Navigator.of(context).pop(true);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'You subtracted in favorite list!'),
                                              width: 208,
                                              padding: const EdgeInsets.all(10),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Delete",
                                          style: yellowTextStyle,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          "Cancel",
                                          style: yellowTextStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: RestaurantsCard(state.favorite[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: blackTextStyle),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, homeRoute),
                    child: Text('Add Restaurant', style: whiteTextStyle),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
