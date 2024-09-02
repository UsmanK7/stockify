import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color appBlue = Color(0xff1789fc);
Color appBgWhite = Color(0xffF1F1F1);
Color appborder = Color(0xffefefef);
Color apptextColor = Color(0xff91919F);
Color appsubtitletextColor = Color(0xff767E8C);
Color appsearchBoxColor = Color(0xffD9D9D9);
const baseUrl = 'https://adbb-39-44-67-62.ngrok-free.app';
const loginUrl = '$baseUrl/stockfiy/api/auth/login';
const addSaleOrderUrl = '$baseUrl/stockfiy/api/realdata/storesaleorder';

const addDailyExpenseUrl = '$baseUrl/stockfiy/api/realdata/StoreDailyExpenses';

const SyncUrl = '$baseUrl/stockfiy//api/sync';

const SyncDataUrl = '$baseUrl/stockfiy/api/sync/saveOfflineData';

const userdetailsUrl = '$baseUrl/stockfiy/api/phase1/getUserDetails';
double AppTotalScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double AppTotalScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final formatter = DateFormat('hh:mm:ss a');
  return formatter.format(dateTime);
}

DateTime getFirstDateOfLastMonth() {
  DateTime now = DateTime.now();
  DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
  DateTime lastMonth = firstDayOfCurrentMonth.subtract(Duration(days: 1));
  return DateTime(lastMonth.year, lastMonth.month, 1);
}

DateTime getLastDateOfLastMonth() {
  DateTime now = DateTime.now();
  DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
  return firstDayOfCurrentMonth.subtract(Duration(days: 1));
}

DateTime getFirstDateOfThisMonth() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, 1);
}

DateTime getLastDateOfThisMonth() {
  DateTime now = DateTime.now();
  DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
  return firstDayOfNextMonth.subtract(Duration(days: 1));
}

DateTime getFirstDateOfThisWeek() {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;
  // Subtract days to get the previous Sunday (first day of the week)
  DateTime firstDayOfThisWeek =
      now.subtract(Duration(days: currentWeekday - 1));
  return DateTime(firstDayOfThisWeek.year, firstDayOfThisWeek.month,
      firstDayOfThisWeek.day);
}

DateTime getLastDateOfThisWeek() {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;
  // Add days to get the next Saturday (last day of the week)
  DateTime lastDayOfThisWeek =
      now.add(Duration(days: DateTime.saturday - currentWeekday));
  return DateTime(
      lastDayOfThisWeek.year, lastDayOfThisWeek.month, lastDayOfThisWeek.day);
}

DateTime getFirstDateOfThisYear() {
  DateTime now = DateTime.now();
  return DateTime(now.year, 1, 1);
}

DateTime getLastDateOfThisYear() {
  DateTime now = DateTime.now();
  return DateTime(now.year, 12, 31);
}

DateTime getFirstDateOfLastSixMonthsIncludingCurrent() {
  DateTime now = DateTime.now();
  DateTime sixMonthsAgo = DateTime(now.year, now.month - 5,
      1); // Calculate 5 months ago to include the current month
  return DateTime(sixMonthsAgo.year, sixMonthsAgo.month, 1);
}

DateTime getLastDateOfLastSixMonthsIncludingCurrent() {
  DateTime now = DateTime.now();
  return now; // Last date is the current date
}

String truncateAfterChars(String text, int maxLength) {
  if (text.length > maxLength) {
    return text.substring(0, maxLength) +
        '...'; // Adding '...' to indicate truncation
  }
  return text;
}
