import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redeem_order_app/views/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redeem_order_app/bloc/session/session_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';
import 'package:redeem_order_app/bloc/ordertype/ordertype_bloc.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/bloc/profile/profile_bloc.dart';
import 'package:redeem_order_app/bloc/checkout/checkout_bloc.dart';
import 'package:redeem_order_app/bloc/order_history/orderhistory_bloc.dart';
import 'package:redeem_order_app/services/order_history_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final int? savedUserId = prefs.getInt('loggedInUserId');

  runApp(MyApp(savedUserId: savedUserId));
}

class MyApp extends StatelessWidget {
  final int? savedUserId;

  const MyApp({super.key, required this.savedUserId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SessionBloc()..add(SetUserId(savedUserId ?? 0))),
          BlocProvider(create: (_) => OrderTypeBloc()),
          BlocProvider(create: (_) => NetsQrBloc()),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (context) => CheckoutBloc(cartBloc: context.read<CartBloc>())),
          BlocProvider(create: (_) => NetsClickBloc()),
          BlocProvider(create: (_) => ProfileBloc()..add(savedUserId != null ? LoadProfile(savedUserId!) : DoNothing())),
          BlocProvider(create: (_) => OrderHistoryBloc(OrderHistoryService())),
        ],
        child: MaterialApp(
          title: 'Redeem Order App',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
    );
  }
}

