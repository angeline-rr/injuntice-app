import 'package:injustice_app/account/data/services/remote/account_remote_service_interface.dart';
import 'package:injustice_app/core/failure/failure.dart';
import 'package:injustice_app/core/patterns/result.dart';

import '../../../core/typedefs/types_defs.dart';
import 'account_repository_interface.dart';
import '../services/local/account_local_storage_interface.dart';
import '../../domain/models/account_entity.dart';

/// implementação do repositório para Account

final class AccountRepositoryImpl implements IAccountRepository {
  final IAccountLocalStorage _localStorage;
  final IAccountRemoteService _remoteService; 

  AccountRepositoryImpl({
    required IAccountLocalStorage localStorage,
    required IAccountRemoteService remoteService,
  }) : _localStorage = localStorage,
       _remoteService = remoteService;

  @override
  Future<VoidResult> saveAccount(Account account) async {
    final remoteResult = await _remoteService.saveAccount(account);

    return remoteResult.fold(
      onSuccess: (ok) => _localStorage.saveAccount(account),
      onFailure: (failure) =>
          Error(failure), 
    );
  }

  @override
  Future<AccountResult> getAccount() async {
    final result = await _remoteService.getAccount();

    return result.fold(
      onSuccess: (account) {
        _localStorage.saveAccount(account);
        return Success(account);
      },
      onFailure: (failure) => Error(failure), 
    );
  }

  @override
  Future<VoidResult> deleteAccount() async {
    final remoteResult = await _remoteService.deleteAccount();

    return remoteResult.fold(
      onSuccess: (ok) => _localStorage.deleteAccount(),
      onFailure: (failure) => Error(failure),
    );
  }

  @override
  Future<VoidResult> updateAccount(Account account) async {
    final remoteResult = await _remoteService.updateAccount(account);

    return remoteResult.fold(
      onSuccess: (ok) => _localStorage.updateAccount(account),
      onFailure: (failure) => Error(failure),
    );
  }
}
