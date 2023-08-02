import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_room/blocs/home/home_bloc.dart';
import 'package:meeting_room/blocs/room_detail/room_detail_bloc.dart';
import 'package:meeting_room/res/constants.dart';

import 'blocs/dashboard/dashboard_bloc.dart';
import 'ui/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => RoomDetailBloc()),
      ],
      child: MaterialApp(
          theme: ThemeData(
              primarySwatch: Constants.materialPrimaryDarkClr,
              primaryColorDark: Constants.primaryDarkClr,
              primaryColor: Constants.primaryClr,
              fontFamily: 'FigTree'
          ),
          debugShowCheckedModeBanner: false,
          home: const Dashboard()),
    );
  }
}