import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required WishlistRepo wishlistRepo})
      : _wishlistRepo = wishlistRepo,
        super(WishlistInitial(wishlistRepo.currentWishlistItems)) {
    on<WishlistSubscribeRequested>(_onWishlistSubscribeRequested);
    on<WishlistAddRequested>(_onWishlistAddRequested);
    on<WishlistRemoveRequested>(_onWishlistRemoveRequested);
  }

  final WishlistRepo _wishlistRepo;

  Future<void> _onWishlistSubscribeRequested(
      WishlistSubscribeRequested event, Emitter<WishlistState> emit) async {
    await emit.forEach(
      _wishlistRepo.streamWishlistItems,
      onData: (data) => WishlistLoaded(data),
    );
  }

  Future<void> _onWishlistAddRequested(
      WishlistAddRequested event, Emitter<WishlistState> emit) async {
    _wishlistRepo.addToWishlist(event.itemId);
  }

  Future<void> _onWishlistRemoveRequested(
      WishlistRemoveRequested event, Emitter<WishlistState> emit) async {
    _wishlistRepo.removeToWishlist(event.itemId);
  }
}
