part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

final class CartSubscribeRequested extends CartEvent {}

final class CartAddRequested extends CartEvent {
  final ProductItem productItem;

  CartAddRequested({required this.productItem});
}

final class CartRemoveRequested extends CartEvent {
  final String itemId;

  CartRemoveRequested({required this.itemId});
}

final class CartUpdateQuantityRequested extends CartEvent {
  final String itemId;
  final int quantity;

  CartUpdateQuantityRequested({required this.itemId, required this.quantity});
}
