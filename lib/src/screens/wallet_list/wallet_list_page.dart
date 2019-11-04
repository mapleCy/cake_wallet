import 'package:cake_wallet/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/src/widgets/scollable_with_bottom_section.dart';
import 'package:cake_wallet/src/stores/wallet_list/wallet_list_store.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';

class WalletListPage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Monero Wallet';
  AppBarStyle get appBarStyle => AppBarStyle.withShadow;

  @override
  Widget body(BuildContext context) => WalletListBody();
}

class WalletListBody extends StatefulWidget {
  WalletListBodyState createState() => WalletListBodyState();
}

class WalletListBodyState extends State<WalletListBody> {
  WalletListStore _walletListStore;

  void presetMenuForWallet(WalletDescription wallet, bool isCurrentWallet,
      BuildContext bodyContext) {
    showDialog(
        context: bodyContext,
        builder: (context) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            CupertinoActionSheet(
              actions: _generateActionsForWalletActionSheets(
                  wallet, isCurrentWallet, context, bodyContext),
              cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(context).pop()),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    _walletListStore = Provider.of<WalletListStore>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final _isDarkTheme = _themeChanger.getTheme() == Themes.darkTheme;

    return ScrollableWithBottomSection(
        content: Container(
          padding: EdgeInsets.all(20),
          child: Observer(
            builder: (_) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, index) => Divider(
                    color: _isDarkTheme
                        ? PaletteDark.darkThemeGreyWithOpacity
                        : Palette.lightGrey,
                    height: 1.0),
                itemCount: _walletListStore.wallets.length,
                itemBuilder: (__, index) {
                  final wallet = _walletListStore.wallets[index];
                  final isCurrentWallet =
                      _walletListStore.isCurrentWallet(wallet);

                  return InkWell(
                      onTap: () =>
                          presetMenuForWallet(wallet, isCurrentWallet, context),
                      child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: ListTile(
                              title: Text(
                                wallet.name,
                                style: TextStyle(
                                    color: isCurrentWallet
                                        ? Palette.cakeGreen
                                        : _isDarkTheme
                                            ? PaletteDark.darkThemeGrey
                                            : Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              trailing: isCurrentWallet
                                  ? Icon(
                                      Icons.check,
                                      color: Palette.cakeGreen,
                                      size: 20.0,
                                    )
                                  : null)));
                }),
          ),
        ),
        bottomSection: Column(children: <Widget>[
          PrimaryIconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.newWallet),
              iconData: Icons.add,
              color: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButton
                  : Palette.purple,
              borderColor: _isDarkTheme
                  ? PaletteDark.darkThemePurpleButtonBorder
                  : Palette.deepPink,
              iconColor: Palette.violet,
              iconBackgroundColor:
                  _isDarkTheme ? PaletteDark.darkThemeViolet : Colors.white,
              text: 'Create New Wallet'),
          SizedBox(height: 10.0),
          PrimaryIconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.restoreWalletOptions),
            iconData: Icons.refresh,
            text: 'Restore Wallet',
            color: _isDarkTheme
                ? PaletteDark.darkThemeIndigoButton
                : Palette.indigo,
            borderColor: _isDarkTheme
                ? PaletteDark.darkThemeIndigoButtonBorder
                : Palette.deepIndigo,
            iconColor: _isDarkTheme ? Colors.white : Colors.black,
            iconBackgroundColor: _isDarkTheme
                ? PaletteDark.darkThemeIndigoButtonBorder
                : Colors.white,
          )
        ]));
  }

  List<Widget> _generateActionsForWalletActionSheets(WalletDescription wallet,
      bool isCurrentWallet, BuildContext context, BuildContext bodyContext) {
    List<Widget> actions = [];

    if (!isCurrentWallet) {
      actions.add(CupertinoActionSheetAction(
          child: const Text('Load wallet'),
          onPressed: () async {
            Navigator.of(context).popAndPushNamed(Routes.auth, arguments: [
              (auth, _) async {
                try {
                  auth.changeProcessText('Loading ${wallet.name} wallet');
                  await _walletListStore.loadWallet(wallet);
                  auth.close();
                  Navigator.of(bodyContext).pop();
                } catch (e) {
                  auth.changeProcessText(
                      'Failed to load ${wallet.name} wallet. ${e.toString()}');
                }
              }
            ]);
          }));
    }

    actions.add(CupertinoActionSheetAction(
        child: const Text('Show seed'),
        onPressed: () async {
          Navigator.of(context).popAndPushNamed(Routes.auth, arguments: [
            (auth, _) async {
              auth.close();
              Navigator.of(bodyContext).popAndPushNamed(Routes.seed);
            }
          ]);
        }));

    if (!isCurrentWallet) {
      actions.add(CupertinoActionSheetAction(
          child: const Text('Remove'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).popAndPushNamed(Routes.auth, arguments: [
              (auth, _) async {
                try {
                  auth.changeProcessText('Removing ${wallet.name} wallet');
                  await _walletListStore.remove(wallet);
                  auth.close();
                } catch (e) {
                  auth.changeProcessText(
                      'Failed to remove ${wallet.name} wallet. ${e.toString()}');
                }
              }
            ]);
          }));
    }

    if (isCurrentWallet) {
      actions.add(CupertinoActionSheetAction(
          child: const Text('Rescan'), onPressed: () async {}));
    }

    return actions;
  }
}