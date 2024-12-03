import 'package:app_3/model/cart_products_model.dart';

sealed class CartState {}

class CartInitial extends CartState{}

class CartLoading extends CartState{}

class CartItems extends CartState{
  final List<CartProducts> cartItems;

  CartItems(this.cartItems);
}

class CartEmpty extends CartState{}

class IncrementQuantity extends CartState{}
class DecrementQuantity extends CartState{}

class CartError extends CartState{
  final String message;

  CartError(this.message);
}