import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    bool isInWishlist = context
            .watch<WishlistBloc>()
            .state
            .wishlistItems
            .firstWhere((element) => element.id == item.id,
                orElse: () => ProductItem.none) !=
        ProductItem.none;
    return IconButton(
      onPressed: () => isInWishlist
          ? context
              .read<WishlistBloc>()
              .add(WishlistRemoveRequested(itemId: item.id))
          : context
              .read<WishlistBloc>()
              .add(WishlistAddRequested(itemId: item.id)),
      icon: AppIcon(
        iconAsset: isInWishlist //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: isInWishlist //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
