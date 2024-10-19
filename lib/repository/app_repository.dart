import 'package:app_3/service/api_service.dart';
import 'package:http/http.dart' as http;

class AppRepository{
  final ApiService apiService;

  AppRepository(this.apiService);


  //////// GET Methods ////////
 
  // Get Banners
  Future<http.Response> banners() async
    => await apiService.get('/bannerlist');

  // Get Category List
  Future<http.Response> categories() async
    => await apiService.get('/categorylist');

  // Get Featured Products
  Future<http.Response> featuredProducts() async
    => await apiService.get('/featuredproducts');

  


  // Get Best Seller products
  Future<http.Response> bestSellers() async
    => await apiService.get('/bestSeller');

  // Get Region and Location List for Address
  Future<http.Response> regionLocation() async
    => await apiService.get('/regionlist');

  // 
  Future<http.Response> downloadInvoice(String url) async
    => await apiService.get(url);



  //////// POST Methods //////// 
 
  // User Sign-in
  Future<http.Response> signin(Map<String, dynamic> body) async
    => await apiService.post('/userlogin', body);
  
  // User Register
  Future<http.Response> registration(Map<String, dynamic> body) async
    => await apiService.post('/userregister', body);

  // Verify OTP
  Future<http.Response> verifyotp(Map<String, dynamic> body) async
    => await apiService.post('/verifyotp', body);

  // Resend OTP
  Future<http.Response> resendOtp(Map<String, dynamic> body) async
    => await apiService.post('/resendotp', body);

  // All products API
  Future<http.Response> allProducts(Map<String, dynamic> body) async
    => await apiService.post('/allproducts', body);

  // Quick order product list API
  Future<http.Response> quickOrderProducts() async
    => await apiService.post('/productlist', {});

  // Get Subscribe Products
  Future<http.Response> subscribedProducts(Map<String, dynamic> body) async
    => await apiService.post('/subscribedproducts', body);

  // Get User Address
  Future<http.Response> getAddresses(Map<String, dynamic> body) async
    => await apiService.post('/addresslist', body);

  // Add new Address
  Future<http.Response> addAddress(Map<String, dynamic> body) async
    => await apiService.post('/addaddress', body);

  // Update Address
  Future<http.Response> updateAddress(Map<String, dynamic> body) async
    => await apiService.post('/updateaddress', body);

  // Delete Address
  Future<http.Response> deleteAddress(Map<String, dynamic> body) async
    => await apiService.post('/destroyaddress', body);

  // Set Default Address
  Future<http.Response> defaultAddress(Map<String, dynamic> body) async
    => await apiService.post('/customeraddress', body);
  
  // Get User Profile information
  Future<http.Response> userprofile(Map<String, dynamic> body) async
    => await apiService.post('/userprofile', body);

  // Update Profile
  Future<http.Response> updateProfile(Map<String, dynamic> body) async
    => await apiService.post('/profileupdate', body);

  // Add a Product to Cart
  Future<http.Response> addCart(Map<String, dynamic> body) async
    => await apiService.post('/cartadd', body);

  // My Cart Products
  Future<http.Response> mycart(Map<String, dynamic> body) async
    => await apiService.post('/mycart', body);

  // Remove Product from the Cart
  Future<http.Response> removeCart(Map<String, dynamic> body) async
    => await apiService.post('/cartremove', body);

  // Update Cart Products
  Future<http.Response> updateCart(Map<String, dynamic> body) async
    => await apiService.post('/cartupdate', body);
    
  // Place order from cart
  Future<http.Response> cartCheckout(Map<String, dynamic> body) async 
    => await apiService.post('/placeorder', body);

  // Made Quick order 
  Future<http.Response> quickorder(Map<String, dynamic> body) async
    => await apiService.post('/quickorderadd', body);

  // Quick order checkout
  Future<http.Response> quickOrderCheckout(Map<String, dynamic> body) async
    => await apiService.post('/checkout', body);

  // Add a Product to wishlist
  Future<http.Response> addWishList(Map<String, dynamic> body) async 
    => await apiService.post('/productwishlist', body);

  // List of wish listed product
  Future<http.Response> wishlistProducts(Map<String, dynamic> body) async 
    => await apiService.post('/productwishlistdetails', body);

  // Remove a Product from wishlist
  Future<http.Response> removeWishlist(Map<String, dynamic> body) async 
    => await apiService.post('/wishlistremove', body);

  // Subscribe Product
  // Future<http.Response> subscribeProduct(Map<String, dynamic> body) async 
  //   => await apiService.post('/addsubscription', body); 
  
  // Order List 
  Future<http.Response> orderList(Map<String, dynamic> body) async
    => await apiService.post('/orderlist', body);

  // Order List 
  Future<http.Response> orderDetail(Map<String, dynamic> body) async
    => await apiService.post('/orderdetail', body);

  // Re-order the product alreader ordered
  Future<http.Response> reOrder(Map<String, dynamic> body) async
    => await apiService.post('/reorder', body);

  // Re-order the product alreader ordered
  Future<http.Response> cancelOrder(Map<String, dynamic> body) async
    => await apiService.post('/cancelorder', body);


  // Active Subscription List
  Future<http.Response> activeSubscription(Map<String, dynamic> body) async
    => apiService.post('/activesubscription', body);

  // Active Subscription List
  Future<http.Response> subscriptionHistory(Map<String, dynamic> body) async
    => apiService.post('/subscriptionhistory', body);
  
  // Cancel Subscription
  Future<http.Response> cancelSubscription(Map<String, dynamic> body) async
    => apiService.post('/cancelsubscription', body);

  // Resume Subscription
  Future<http.Response> resumeSubscription(Map<String, dynamic> body) async
    => apiService.post('/resumesubscription', body);

  // Edit subscription
  Future<http.Response> editSubscription(Map<String, dynamic> body) async
    => apiService.post('/updatesubscription', body);

  // Add Subscription
  Future<http.Response> addSubscription(Map<String, dynamic> body) async
    => apiService.post('/addsubscription', body);

  // Receipt for pre-order
  Future<http.Response> preOrderReceipts(Map<String, dynamic> body) async
    => await apiService.post('/receipts', body);
    
  // Re-new Subscrpition
  Future<http.Response> renewsubscription(Map<String, dynamic> body) async
    => await apiService.post('/renewsubscription', body);

  // Confirm Re-subscription
  Future<http.Response> confirmReSubscription(Map<String, dynamic> body) async
    => await apiService.post('/confirmReSubscription', body);

  // Invoice Listing
  Future<http.Response> invoices(Map<String, dynamic> body) async
    => await apiService.post('/invoicelist', body);
  
  // Vacation List
  Future<http.Response> vacationList(Map<String, dynamic> body) async
    => await apiService.post('/vacationlist', body);
  
  // Add Vacation
  Future<http.Response> addVacation(Map<String, dynamic> body) async
    => await apiService.post('/addvacation', body);

  // Delete Vacation
  Future<http.Response> destroyVacation(Map<String, dynamic> body) async
    => await apiService.post('/destroyvacation', body);

  // Update Vacation
  Future<http.Response> updateVacation(Map<String, dynamic> body) async
    => await apiService.post('/updatevacation', body);

  // Apply coupon
  Future<http.Response> applyCoupon(Map<String, dynamic> body) async
    => await apiService.post('/cartCoupon', body);

  // Apply coupon
  Future<http.Response> applyCouponQuickOrder(Map<String, dynamic> body) async
    => await apiService.post('/apply-coupon-quick-order', body);
  
  // Raise a Query
  Future<http.Response> raiseAQuery(Map<String, dynamic> body) async
    => await apiService.post("/raisequery", body);
} 