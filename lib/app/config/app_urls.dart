/// Defines API endpoints for the LayerX app.
abstract class AppUrls {
  AppUrls._();

  static const String baseAPIURL = 'https://api.vladai.eu/api';

  // static const String notificationsBaseApi = "https://fcm.googleapis.com/v1/projects/ninjacar-3cb70/messages:send";

  // Auth Apis
  static const String signUp = '/auth/register';
  static const String login = '/auth/login';
  static const String resendOtp = '/auth/resend-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile';
  static const String deleteAccount = '/auth/delete-account';

  // Cities Apis
  static const String getPopularCities = "/cities/popular";
  static const String getAllItineraries = "/v2/itineraries";
  static const String getAccommodation = "/cities/categories?type=accommodation";
  static const String getInterest = "/cities/categories?type=attraction";
  static const String getRestaurantCategories = "/cities/categories?type=restaurant";
  static const String citiesCategories = "/cities/categories";
  static const String citiesCategoriesNew = "/cities/map-categories";
  static const String getCities = "/cities";
  static const String createItinery = "/v2/itineraries/generate";
  static const String getCityDetails = "/cities/items";
  static const String getCityLastTrips = "/cities/my-last-trips";
  static const String reorderSlots = "/v2/itineraries"; // /:id/slots/reorder

  //Suggest Place Apis
  static const String suggestPlaceApi = "/user-suggestions";
  //Suggest Fav Apis
  static const String getFavsApi = "/favorites";
  static const String postFavsApi = "/favorites/toggle";

  //Suggest Notification Apis
  static const String getNotificationsAPI = "/notifications";
  static const String getMarkAllNotificationsTrue = "/notifications/mark-all-read";

  // Countries Api
  static const String getCountries = "/countries";

  // Itinerary Reviews Api
  static const String itineraryReviews = "/itinerary-reviews/itinerary"; // /:itineraryId
}
