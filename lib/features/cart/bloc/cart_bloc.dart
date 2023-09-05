import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required CartRepo cartRepo})
      : _cartRepo = cartRepo,
        super(CartInitial(
            cartItems: cartRepo.currentCartItems,
            cartTotal:
                cartRepo.calculateCartTotal(cartRepo.currentCartItems))) {
    on<CartSubscribeRequested>(_onCartSubscribeRequested);
    on<CartAddRequested>(_onCartAddRequested);
    on<CartUpdateQuantityRequested>(_onCartUpdateQuantityRequested);
    on<CartRemoveRequested>(_onCartRemoveRequested);
  }

  final CartRepo _cartRepo;

  Future<void> _onCartSubscribeRequested(
      CartSubscribeRequested event, Emitter<CartState> emit) async {
    await emit.forEach(
      _cartRepo.streamCartItems,
      onData: (data) => CartLoaded(
          cartItems: data, cartTotal: _cartRepo.calculateCartTotal(data)),
    );
  }

  Future<void> _onCartAddRequested(
      CartAddRequested event, Emitter<CartState> emit) async {
    _cartRepo.addToCart(event.productItem);
  }

  Future<void> _onCartUpdateQuantityRequested(
      CartUpdateQuantityRequested event, Emitter<CartState> emit) async {
    _cartRepo.updateQuantity(event.itemId, event.quantity);
  }

  Future<void> _onCartRemoveRequested(
      CartRemoveRequested event, Emitter<CartState> emit) async {
    _cartRepo.removeToCart(event.itemId);
  }
}
