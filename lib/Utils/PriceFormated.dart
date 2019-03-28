import 'package:flutter/material.dart';
class PriceFormatter{
  static const String EURO = "euro";
  static const String CFA = "cfa";
  static const String DOLLAR = "dollar";
  static String formatPrice({@required double price, String device}){
    String priceString = price.toStringAsFixed(2);
    if(int.parse(priceString.substring(priceString.length -2)) == 00)
      return priceString.substring(0, priceString.length - 3) + getDevice(device);
    else if(int.parse(priceString.substring(priceString.length -1)) == 0)
      return priceString.substring(0, priceString.length - 3) + "," + priceString.substring(priceString.length - 2, priceString.length - 1) + getDevice(device);
    else
      return priceString.substring(0, priceString.length - 3) + "," + priceString.substring(priceString.length - 2) + getDevice(device);
  }
      static String getDevice(String device){
    switch(device){
      case CFA : return "CFA";
      case DOLLAR : return "\$";
      default : return "€";    }
  }
}