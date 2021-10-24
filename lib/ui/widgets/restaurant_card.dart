import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/provider/database_provider.dart';
import 'package:restaurant_app/ui/widgets/image_view.dart';

class RestaurantsCard extends StatelessWidget {
  const RestaurantsCard(this.restaurantElement, {Key? key}) : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, detailRoute,
            arguments: restaurantElement),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 120,
                height: 100,
                child: Stack(
                  children: [
                    ImageView(
                      urlImage: smallPicture,
                      idPicture: restaurantElement.pictureId,
                      width: 120,
                      height: 100,
                    ),
                    Consumer<DatabaseProvider>(
                      builder: (context, state, widget) {
                        return FutureBuilder<bool>(
                          future: state.isFavorite(restaurantElement.id!),
                          builder: (context, snapshot) {
                            var _isFavorited = snapshot.data ?? true;
                            return _isFavorited
                                ? Container(
                                    width: 35,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: Icon(Icons.favorite,
                                        size: 20, color: Colors.red[400]),
                                  )
                                : const SizedBox();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantElement.name,
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 5),
                      Text(restaurantElement.city, style: greyTextStyle)
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: yellowColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${restaurantElement.rating}',
                        style: regularBlackTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
