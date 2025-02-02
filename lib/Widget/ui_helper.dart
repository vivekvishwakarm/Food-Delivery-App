import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

class UiHelper{

  static TextStyle boldTextStyle(){
    return theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle headLineTextStyle(){
    return theme.textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightTextStyle(){
    return theme.textTheme.bodySmall!.copyWith(
      color: lightBlack,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle semiBoldTextStyle(){
    return theme.textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }


}