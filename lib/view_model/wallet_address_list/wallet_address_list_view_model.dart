import 'package:cake_wallet/store/app_store.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/bitcoin/bitcoin_wallet.dart';
import 'package:cake_wallet/monero/monero_wallet.dart';
import 'package:cake_wallet/core/wallet_base.dart';
import 'package:cake_wallet/utils/list_item.dart';
import 'package:cake_wallet/view_model/wallet_address_list/wallet_account_list_header.dart';
import 'package:cake_wallet/view_model/wallet_address_list/wallet_address_list_header.dart';
import 'package:cake_wallet/view_model/wallet_address_list/wallet_address_list_item.dart';
import 'package:cake_wallet/entities/wallet_type.dart';

part 'wallet_address_list_view_model.g.dart';

class WalletAddressListViewModel = WalletAddressListViewModelBase
    with _$WalletAddressListViewModel;

abstract class PaymentURI {
  PaymentURI({this.amount, this.address});

  final String amount;
  final String address;
}

class MoneroURI extends PaymentURI {
  MoneroURI({String amount, String address})
      : super(amount: amount, address: address);

  @override
  String toString() {
    var base = 'monero:' + address;

    if (amount?.isNotEmpty ?? false) {
      base += '?tx_amount=$amount';
    }

    return base;
  }
}

class BitcoinURI extends PaymentURI {
  BitcoinURI({String amount, String address})
      : super(amount: amount, address: address);

  @override
  String toString() {
    var base = 'bitcoin:' + address;

    if (amount?.isNotEmpty ?? false) {
      base += '?amount=$amount';
    }

    return base;
  }
}

abstract class WalletAddressListViewModelBase with Store {
  WalletAddressListViewModelBase(
      {@required AppStore appStore}) {
    hasAccounts = _wallet is MoneroWallet;
    _appStore = appStore;
    _wallet = _appStore.wallet;
    _onWalletChangeReaction = reaction((_) => _appStore.wallet, (WalletBase wallet) => _wallet = wallet);
    _init();
  }

  @observable
  String amount;

  @computed
  WalletType get type => _wallet.type;

  @computed
  WalletAddressListItem get address =>
      WalletAddressListItem(address: _wallet.address);

  @computed
  PaymentURI get uri {
    if (_wallet is MoneroWallet) {
      return MoneroURI(amount: amount, address: address.address);
    }

    if (_wallet is BitcoinWallet) {
      return BitcoinURI(amount: amount, address: address.address);
    }

    return null;
  }

  @computed
  ObservableList<ListItem> get items =>
      ObservableList<ListItem>()..addAll(_baseItems)..addAll(addressList);

  @computed
  ObservableList<ListItem> get addressList {
    final wallet = _wallet;
    final addressList = ObservableList<ListItem>();

    if (wallet is MoneroWallet) {
      addressList.addAll(wallet.subaddressList.subaddresses.map((subaddress) =>
          WalletAddressListItem(
              id: subaddress.id,
              name: subaddress.label,
              address: subaddress.address)));
    }

    if (wallet is BitcoinWallet) {
      final bitcoinAddresses = wallet.addresses.map((addr) =>
          WalletAddressListItem(name: addr.label, address: addr.address));
      addressList.addAll(bitcoinAddresses);
    }

    return addressList;
  }

  bool hasAccounts;

  @observable
  WalletBase _wallet;

  List<ListItem> _baseItems;

  AppStore _appStore;

  ReactionDisposer _onWalletChangeReaction;

  @computed
  String get accountLabel {
    final wallet = _wallet;

    if (wallet is MoneroWallet) {
      return wallet.account.label;
    }

    return null;
  }

  @action
  void setAddress(WalletAddressListItem address) =>
      _wallet.address = address.address;

  void _init() {
    _baseItems = [];

    if (_wallet is MoneroWallet) {
      _baseItems.add(WalletAccountListHeader());
    }

    _baseItems.add(WalletAddressListHeader());
  }
}
