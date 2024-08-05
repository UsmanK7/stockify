abstract class DailyExpenseState {}

abstract class DailyExpenseActionState extends DailyExpenseState {}

class DailyExpenseInitialState extends DailyExpenseState {}

class DailyExpenseAddedState extends DailyExpenseActionState {}

class DailyExpenseLoadingState extends DailyExpenseActionState {}
