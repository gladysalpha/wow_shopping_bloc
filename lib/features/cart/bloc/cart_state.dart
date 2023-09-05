part of 'cart_bloc.dart';

@immutable
abstract class CartState {
  const CartState({required this.cartItems, required this.cartTotal});
  final List<CartItem> cartItems;
  final Decimal cartTotal;
}

class CartInitial extends CartState {
  const CartInitial({required super.cartItems, required super.cartTotal});
}

class CartLoaded extends CartState {
  const CartLoaded({required super.cartItems, required super.cartTotal});
}
