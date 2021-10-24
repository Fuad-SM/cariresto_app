import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/provider/search_provider.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:restaurant_app/utils/const.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SearchProvider>(
        builder: (context, state, child) {
          return Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: whiteColor),
                  ),
                  Expanded(
                    child: TextField(
                      style: regularBlackTextStyle,
                      textInputAction: TextInputAction.done,
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_searchController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Empty search,\nPlease enter your input!',
                                    textAlign: TextAlign.center,
                                  ),
                                  width: 208,
                                  padding: const EdgeInsets.all(10),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, resultRoute,
                                  arguments: _searchController.text);
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                        hintText: 'Name, Category or Menu',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xffA6A1A1),
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.amber),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.amber),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.amber),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showComingsoonFeature(context),
                    icon: const Icon(Icons.sort),
                    iconSize: 30,
                    color: whiteColor,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
