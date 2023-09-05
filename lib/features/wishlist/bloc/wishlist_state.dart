part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistState {
  const WishlistState(this.wishlistItems);
  final List<ProductItem> wishlistItems;
}

class WishlistInitial extends WishlistState {
  const WishlistInitial(super.wishlistItems);
}

class WishlistLoaded extends WishlistState {
  const WishlistLoaded(super.wishlistItems);
}
