import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/cart/bloc/cart_bloc.dart';
import 'package:wow_shopping/utils/formatting.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/common.dart';

class CheckoutPanel extends StatelessWidget {
  const CheckoutPanel({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(cartRepo: context.cartRepo)..add(CartSubscribeRequested()),
      child: CheckoutPanelView(
        label: label,
        onPressed: onPressed,
      ),
    );
  }
}

class CheckoutPanelView extends StatelessWidget {
  const CheckoutPanelView({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    Decimal total = context.watch<CartBloc>().state.cartTotal;
    return Hero(
      tag: CheckoutPanelView,
      child: AppPanel(
        padding: horizontalPadding24 + topPadding12 + bottomPadding24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order amount:'),
                  Text(formatCurrency(total)),
                ],
              ),
            ),
            DefaultTextStyle.merge(
              style: const TextStyle(
                fontSize: 12.0,
                color: appGreyColor,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your total amount of discount:'),
                  Text('-'),
                ],
              ),
            ),
            verticalMargin12,
            AppButton(
              onPressed: onPressed,
              style: AppButtonStyle.highlighted,
              label: label,
            ),
          ],
        ),
      ),
    );
  }
}
