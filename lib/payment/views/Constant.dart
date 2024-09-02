class Constant {
  static const baseUrl = 'https://adbb-39-44-67-62.ngrok-free.app';
////////////////this is for checkin am i opening the correct file
  ///
  static const loginUrl = '$baseUrl/stockfiy/api/auth/login';
  static const firmUrl = '$baseUrl/stockfiy/api/Phase1/getFirmDetails';
  static const userUrl = '$baseUrl/stockfiy/api/Phase1/getUserDetails';
  static const usertypeUrl = '$baseUrl/stockfiy/api/Phase1/ListUserTypes';
  static const storeUrl = '$baseUrl/stockfiy/api/Phase1/ListStores';
  static const productComapnaiesUrl =
      '$baseUrl/stockfiy/api/Phase1/ListProductCompanies';
  static const productGrouping =
      '$baseUrl/stockfiy/api/Phase1/ListProductGroups';
  static const product = '$baseUrl/stockfiy/api/Phase1/ListProducts';
  static const country = '$baseUrl/stockfiy/api/Phase1/ListCountries';
  static const state = '$baseUrl/stockfiy/api/Phase1/ListStates';
  static const cities = '$baseUrl/stockfiy/api/Phase1/ListCities';
  static const areas = '$baseUrl/stockfiy/api/Phase1/ListAreas';
  static const customer = '$baseUrl/stockfiy/api/Phase1/ListPermanentCustomers';
  static const appId = '$baseUrl/stockfiy/api/auth/saveDeviceData';
  static const sendApi =
      '$baseUrl/stockfiy/api/realdata/StorePermanentCustomerPayments';
}
