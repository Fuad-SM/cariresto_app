import 'package:flutter/material.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:restaurant_app/ui/widgets/image_view.dart';

class FoodsCard extends StatelessWidget {
  const FoodsCard(this.detailRestaurant, {Key? key}) : super(key: key);
  final DetailRestaurant detailRestaurant;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final food = detailRestaurant.restaurant.menus.foods[index];
          return InkWell(
              onTap: () => showComingsoonFeature(context),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 120,
                      height: 100,
                      color: Colors.grey.shade100,
                      child: const ImageView(
                        urlImage: 'noImage',
                        idPicture: 'noImage',
                        width: 120,
                        height: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: blackTextStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.paid,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('IDR ...', style: greyTextStyle)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ));
        },
        separatorBuilder: (context, index) => const Divider(
              height: 20,
            ),
        itemCount: detailRestaurant.restaurant.menus.foods.length);
  }
}

class DrinksCard extends StatelessWidget {
  const DrinksCard(this.detailRestaurant, {Key? key}) : super(key: key);
  final DetailRestaurant detailRestaurant;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final drink = detailRestaurant.restaurant.menus.drinks[index];
          return InkWell(
            onTap: () => showComingsoonFeature(context),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 120,
                    height: 100,
                    color: Colors.grey.shade100,
                    child: const ImageView(
                        urlImage: 'noImage',
                        idPicture: 'noImage',
                        width: 120,
                        height: 100),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink.name,
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.paid,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text('IDR ...', style: greyTextStyle),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 20),
        itemCount: detailRestaurant.restaurant.menus.drinks.length);
  }
}
