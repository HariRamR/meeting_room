
import 'package:flutter/material.dart';

Widget progressBar(BuildContext context){
  return Container(
    alignment: Alignment.center,
    color: Theme.of(context).primaryColorDark,
    child: const CircularProgressIndicator(
      color: Colors.white,
    ),
  );
}