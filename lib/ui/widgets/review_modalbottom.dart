import 'dart:async';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/provider/review_provider.dart';
// ignore_for_file: avoid_print

class ReviewModal extends StatefulWidget {
  const ReviewModal({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  _ReviewModalState createState() => _ReviewModalState();
}

class _ReviewModalState extends State<ReviewModal> {
  bool _isLoading = false;
  bool _isValid = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _reviewFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameFocusNode.dispose();
    _reviewFocusNode.dispose();
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isValid = false;
      });
      try {
        final responseData =
            await Provider.of<ReviewProvider>(context, listen: false)
                .fetchReview(
                    id: widget.id,
                    name: _nameController.text,
                    review: _reviewController.text);

        print('Send response');
        print(responseData);
        if (responseData != 'Success') {
          setState(() {
            _isLoading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: 'Failed',
            text: 'Failed to add review',
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Success',
            text: 'Review successfully added',
          );
          _nameController.clear();
          _reviewController.clear();
        }
        // ignore: unused_catch_clause
      } on TimeoutException catch (e) {
        setState(() {
          _isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          title: 'Timeout...',
          text: 'Connection lost, Please try again',
        );
        // ignore: unused_catch_clause
      } on SocketException catch (e) {
        setState(() {
          _isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          title: 'No Internet',
          text: 'Please check your connection',
        );
      } on Error catch (e) {
        setState(() {
          _isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'ERROR: $e',
        );
      }
      return;
    } else {
      setState(() {
        _isValid = true;
      });
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: 'Please check again your review',
      );
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'Write A Review',
          style: blackTextStyle.copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                textController: _nameController,
                labelText: 'Name',
                maxLines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is empty, Please Enter your Name';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_reviewFocusNode);
                },
                onSaved: (value) => _nameController.text,
                focusNode: _nameFocusNode,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textController: _reviewController,
                labelText: 'Review',
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Review is empty, Please Enter your Review';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {},
                focusNode: _reviewFocusNode,
                onSaved: (value) => _reviewController.text,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
          width: _isLoading == true && _isValid == false
              ? MediaQuery.of(context).size.width / 5.5
              : MediaQuery.of(context).size.width - 70,
          height: MediaQuery.of(context).size.height / 15,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: yellowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading == true && _isValid == false
                ? CircularProgressIndicator(color: whiteColor)
                : Text(
                    'Submit Review',
                    style: whiteTextStyle.copyWith(fontSize: 16),
                  ),
            onPressed: () => _submit(),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 6.3),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? textController;
  final FocusNode focusNode;
  final int? maxLines;
  final dynamic validator;
  final dynamic onFieldSubmitted;
  final dynamic onSaved;

  const CustomTextField(
      {required this.labelText,
      required this.textController,
      required this.maxLines,
      required this.validator,
      required this.onFieldSubmitted,
      required this.onSaved,
      required this.focusNode,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: textController,
      maxLines: maxLines,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(18),
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xffA6A1A1),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: yellowColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffA6A1A1)),
        ),
      ),
    );
  }
}
