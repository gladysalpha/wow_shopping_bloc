import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/cart/bloc/cart_bloc.dart';
import 'package:wow_shopping/features/connection_monitor/connection_monitor.dart';
import 'package:wow_shopping/features/main/cubit/main_cubit.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

import '../wishlist/bloc/wishlist_bloc.dart';

export 'package:wow_shopping/models/nav_item.dart';

class MainScreen extends StatelessWidget {
  const MainScreen._();

  static Route<void> route() {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeTransition(
          opacity: animation,
          child: const MainScreen._(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WishlistBloc(wishlistRepo: context.wishlistRepo)
            ..add(WishlistSubscribeRequested()),
        ),
        BlocProvider(
          create: (context) => CartBloc(cartRepo: context.cartRepo)
            ..add(CartSubscribeRequested()),
        ),
        BlocProvider(
          create: (context) => MainCubit(),
        ),
      ],
      child: const MainView(),
    );
  }
}

@immutable
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final selected = context.select(
      (MainCubit cubit) => cubit.state.navItem,
    );
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ConnectionMonitor(
                child: IndexedStack(
                  index: selected.index,
                  children: [
                    for (final item in NavItem.values) //
                      item.builder(),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              onNavItemPressed: context.read<MainCubit>().gotoSection,
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }
}
