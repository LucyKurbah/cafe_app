class ApiConstants {
  static String aws_ip= "13.231.134.208";
  static String office_ip="10.179.2.187:8001";
  static String bran_office_ip="10.179.28.63:8001";
  static String home_ip="192.168.29.48:8000";
  static String bran_ip="192.168.1.51:8000";

  static String right_now_ip=office_ip;

  static String baseUrl = 'http://$right_now_ip/api';
  static String ipUrl = 'http://10.179.2.187';
  //LOGIN
  static String loginUrl = '$baseUrl/login';
  static String registerUrl = '$baseUrl/register';
  static String forgotPasswordUrl = '$baseUrl/forgotPassword';
  static String logoutUrl = '$baseUrl/logout';
  static String userUrl = '$baseUrl/user';
  //PROFILE 
  static String getProfileUrl = '$baseUrl/getProfile';
  static String saveProfileUrl = '$baseUrl/saveProfile';
  static String uploadProfileUrl = '$baseUrl/uploadProfile';
  static String getIdDetailsUrl = '$baseUrl/getIdDetails';
  static String deleteDocumentUrl = '$baseUrl/deleteDocument';
  //EVENTS
  static String getEventsUrl = '$baseUrl/getSliders';
  //POPUP ON APP LAUNCH
 static String getPopUpsUrl = '$baseUrl/getPopUps';
  //MENU & ADD ON
  static String itemUrl = '$baseUrl/getFoodItems';
  static String getAddOnUrl = '$baseUrl/getItems';
  //TABLE
  static String tableUrl = '$baseUrl/getTables';
  static String availableTablesUrl = '$baseUrl/getAvailableTables';
  static String getTableDetailsUrl = '$baseUrl/validateTable';
  static String getTableDateTimeDetailsUrl = '$baseUrl/validateTableDateTime';
  //CONFERENCE
  static String getConferenceDetailsUrl = '$baseUrl/getConferenceDetails';
  static String checkConferenceDetailsUrl = '$baseUrl/checkConferenceDetails';
  //ENTIRE FLOOR
  static String getEntireFloorDetailsUrl = '$baseUrl/getEntireFloorDetails';
  static String checkFloorDetailsUrl = '$baseUrl/checkFloorDetails';
  //CART
  static String cartUrl = '$baseUrl/cart/getCart';
  static String addCartUrl = '$baseUrl/cart/add';
  static String removeCartUrl = '$baseUrl/cart/remove';
  static String getTotalUrl = '$baseUrl/cart/getTotal'; 
  static String saveOrder = '$baseUrl/order/saveDetails';
  static String makePayment = '$baseUrl/makePayment';
  //ORDER
  static String getOrdersUrl = '$baseUrl/order/getOrdersList';
  static String getOrdersDetailsUrl = '$baseUrl/order/getOrdersDetails';
  //FAQS
  static String getFaqsUrl = '$baseUrl/faq/getFaqsList';
  //MISC
  static String imagePath = "http://$right_now_ip/";
  static String imageUrl = "$baseUrl/$imagePath";
  static String serverError = 'Servor Error';
  static String unauthorized = 'Unauthorized';
  static String somethingWentWrong = 'Something went wrong';
  static String notLoggedIn = 'Please log in first!';
   static String noTable = 'No Table available for the date and time!';
}