import 'package:injustice_app/account/domain/models/account_entity.dart';
import 'package:injustice_app/core/typedefs/types_defs.dart';

abstract interface class IAccountRemoteService {
  Future<AccountResult> getAccount();
  Future<VoidResult> saveAccount(Account account);
  Future<VoidResult> updateAccount(Account account);
  Future<VoidResult> deleteAccount();
}