import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/features/wishlist/widgets/wishlist_item.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

import 'bloc/wishlist_bloc.dart';

@immutable
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var _wishlistItems = <ProductItem>[];
  final _selectedItems = <String>{};

  bool isSelected(ProductItem item) {
    return _selectedItems.contains(item.id);
  }

  void setSelected(ProductItem item, bool selected) {
    setState(() {
      if (selected) {
        _selectedItems.add(item.id);
      } else {
        _selectedItems.remove(item.id);
      }
    });
  }

  void toggleSelectAll() {
    final allIds = _wishlistItems.map((el) => el.id).toList();
    setState(() {
      if (_selectedItems.containsAll(allIds)) {
        _selectedItems.clear();
      } else {
        _selectedItems.addAll(allIds);
      }
    });
  }

  void _removeSelected() {
    for (final selected in _selectedItems) {
      context
          .read<WishlistBloc>()
          .add(WishlistRemoveRequested(itemId: selected));
    }
    setState(() {
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    _wishlistItems = context.watch<WishlistBloc>().state.wishlistItems;
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopNavBar(
              title: const Text('Wishlist'),
              actions: [
                TextButton(
                  onPressed: toggleSelectAll,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Select All'),
                ),
              ],
            ),
            Expanded(
              child: MediaQuery.removeViewPadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  padding: verticalPadding12,
                  itemCount: _wishlistItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _wishlistItems[index];
                    return Padding(
                      padding: verticalPadding12,
                      child: WishlistItem(
                        item: item,
                        onPressed: (item) {
                          // FIXME: navigate to product details
                        },
                        selected: isSelected(item),
                        onToggleSelection: setSelected,
                      ),
                    );
                  },
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _selectedItems.isEmpty ? 0.0 : 1.0,
                child: AppPanel(
                  padding: allPadding24,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: _removeSelected,
                          label: 'Remove',
                          iconAsset: Assets.iconRemove,
                        ),
                      ),
                      horizontalMargin16,
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            // FIXME: implement Buy Now button
                          },
                          label: 'Buy now',
                          iconAsset: Assets.iconBuy,
                          style: AppButtonStyle.highlighted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
