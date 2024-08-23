import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateBloc.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateEvent.dart';
import 'package:okra_distributer/bloc/fetchdataaBloc/fetchDataBloc.dart';
import 'package:okra_distributer/bloc/fetchdataaBloc/fetchdataevent.dart';
import 'package:okra_distributer/bloc/popUpbloc/popBloc.dart';
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/view/daily_expense/bloc/daily_expense_bloc.dart';

import 'package:okra_distributer/view/daily_expense/bloc/date_picker_bloc/data_picker_bloc.dart';

import 'package:okra_distributer/view/first_homescreen/first_home_screen.dart';
import 'package:okra_distributer/view/sale/bloc/date_picker_bloc/data_picker_bloc.dart';
import 'package:okra_distributer/view/sale/bloc_pop_sale/sale_pop_bloc.dart';
import 'package:okra_distributer/view/sale_order/bloc/bloc_pop_sale_order/sale_pop_bloc.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final dbHelper = DBHelper();
  final database = await dbHelper.initDb();
  runApp(MyApp(dbHelper: dbHelper, database: database));
}

class MyApp extends StatelessWidget {
  final DBHelper dbHelper;
  final Database database;

  const MyApp({Key? key, required this.dbHelper, required this.database})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<Popbloc>(
              create: (context) => Popbloc(database),
            ),
            BlocProvider<CompletionBloc>(
              create: (context) => CompletionBloc()..add(FetchData()),
            ),
            BlocProvider<DateBloc>(
              create: (context) => DateBloc(),
            ),
            BlocProvider<UpdationBloc>(
              create: (context) =>
                  UpdationBloc()..add(FetchData() as UpdationEvent),
            ),
            BlocProvider<Popbloc>(
              create: (context) => Popbloc(database),
            ),
            BlocProvider<SaleOrderPopBloc>(
              create: (context) => SaleOrderPopBloc(database),
            ),
            BlocProvider<DateBloc>(
              create: (context) => DateBloc(),
            ),
            BlocProvider<SalePopBloc>(
              create: (context) => SalePopBloc(database),
            ),
            BlocProvider<DailyExpenseDateBloc>(
              create: (context) => DailyExpenseDateBloc(),
            ),
             BlocProvider<DailyExpenseBloc>(
              create: (context) => DailyExpenseBloc(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            home: FirstHomeScreen(database: database),
          ),
        );
      },
    );
  }
}
