import 'package:app_3/screens/main_screens/cubits/cart_repository.dart';
import 'package:app_3/screens/main_screens/cubits/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubits extends Cubit<CartState>{
  final CartRepository cartRepository;
  CartCubits(this.cartRepository): super(CartInitial());

  void fetchCartItems() async {
    emit(CartLoading());
    try {
      await cartRepository.cartItemsAPI();
      emit(CartItems(cartRepository.cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void increamentQuantity(int productId){
    cartRepository.incrementQuantity(productId: productId, isIncrement: true);
    emit(CartItems(cartRepository.cartItems));
  }

  void decreamentQuantity(int productId){
    cartRepository.incrementQuantity(productId: productId, isIncrement: false);
    emit(CartItems(cartRepository.cartItems));
  }

}