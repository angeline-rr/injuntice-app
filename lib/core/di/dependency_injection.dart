import 'package:auto_injector/auto_injector.dart';
import 'package:injustice_app/account/data/services/remote/account_remote_service_interface.dart';
import 'package:injustice_app/account/data/services/remote/firestore_account_service.dart';

import '../../account/data/repositories/account_repository_impl.dart';
import '../../account/data/repositories/account_repository_interface.dart';
import '../../account/data/repositories/character_repository_impl.dart';
import '../../account/data/repositories/character_repository_interface.dart';
import '../../account/data/services/local/account_local_storage_interface.dart';
import '../../account/data/services/local/account_shared_preferences_impl.dart';
import '../../account/data/services/local/character_local_storage_interface.dart';
import '../../account/data/services/local/character_shared_preferences_impl.dart';
import '../../account/domain/facades/account_facade_usecases_impl.dart';
import '../../account/domain/facades/account_facade_usecases_interface.dart';
import '../../account/domain/facades/character_facade_usecases_impl.dart';
import '../../account/domain/facades/character_facade_usecases_interface.dart';
import '../../account/domain/usecases/account_usecases_impl.dart';
import '../../account/domain/usecases/account_usecases_interfaces.dart';
import '../../account/domain/usecases/character_usecases_impl.dart';
import '../../account/domain/usecases/character_usecases_interfaces.dart';
import '../../account/presentation/controllers/account_viewmodel.dart';
import '../../account/presentation/controllers/characters_view_model.dart';
import '../theme/theme_controller.dart';

import 'package:injustice_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:injustice_app/authentication/data/repositories/i_auth_repository.dart';
import 'package:injustice_app/authentication/data/services/local/auth_local_session_manager.dart';
import 'package:injustice_app/authentication/data/services/local/i_local_session_store.dart';
import 'package:injustice_app/authentication/data/services/local/shared_pref_local_session_service.dart';
import 'package:injustice_app/authentication/data/services/remote/firebase_auth_service.dart';
import 'package:injustice_app/authentication/data/services/remote/i_auth_service.dart';
import 'package:injustice_app/authentication/domain/facades/auth_use_case_facade_impl.dart';
import 'package:injustice_app/authentication/domain/facades/i_auth_use_case_facade.dart';
import 'package:injustice_app/authentication/domain/usecases/auth_usecases_impl.dart';
import 'package:injustice_app/authentication/domain/usecases/i_auth_usecases.dart';
import 'package:injustice_app/authentication/presentation/controllers/auth_session_viewmodel.dart';

final injector = AutoInjector();

void setupDependencyInjection() {
  // Regristração de dependências do Core
  injector.addSingleton<ThemeController>(ThemeController.new);

  // --- AUTH ---
  injector.addSingleton<IAccountRemoteService>(() => FirestoreAccountService());
  injector.addSingleton<ILocalSessionStore>(SharedPrefLocalSessionService.new);

  injector.addSingleton<AuthLocalSessionManager>(
    () => AuthLocalSessionManager(injector.get<ILocalSessionStore>()),
  );

  injector.addSingleton<IAuthService>(FirebaseAuthService.new);

  injector.addSingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      injector.get<IAuthService>(),
      injector.get<AuthLocalSessionManager>(),
    ),
  );

  // Use cases autenticação
  injector.addSingleton<ISignUpUseCase>(
    () => SignUpUseCase(authRepository: injector.get<IAuthRepository>()),
  );
  injector.addSingleton<ISignInUseCase>(
    () => SignInUseCase(authRepository: injector.get<IAuthRepository>()),
  );
  injector.addSingleton<ISignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(
      authRepository: injector.get<IAuthRepository>(),
    ),
  );
  injector.addSingleton<ISignOutUseCase>(
    () => SignOutUseCase(authRepository: injector.get<IAuthRepository>()),
  );

  injector.addSingleton<IAuthUseCaseFacade>(
    () => AuthUseCaseFacadeImpl(
      signUpUseCase: injector.get<ISignUpUseCase>(),
      signInUseCase: injector.get<ISignInUseCase>(),
      signInWithGoogleUseCase: injector.get<ISignInWithGoogleUseCase>(),
      signOutUseCase: injector.get<ISignOutUseCase>(),
    ),
  );

  // viewmodels
  injector.addSingleton<AuthViewModel>(
    () => AuthViewModel(
      injector.get<IAuthRepository>(),
      injector.get<IAuthUseCaseFacade>(),
    ),
  );

  // --- ACCOUNT ---
  injector.addSingleton<IAccountLocalStorage>(
    AccountSharedPreferencesService.new,
  );

  injector.addSingleton<IAccountRepository>(
    () => AccountRepositoryImpl(
      localStorage: injector.get<IAccountLocalStorage>(),
      remoteService: injector.get<IAccountRemoteService>(),
    ),
  );

  injector.addSingleton<IAccountFacadeUseCases>(
    () => AccountFacadeUsecasesImpl(
      getAccountUseCase: injector.get<IGetAccountUseCase>(),
      saveAccountUseCase: injector.get<ISaveAccountUseCase>(),
      updateAccountUseCase: injector.get<IUpdateAccountUseCase>(),
      deleteAccountUseCase: injector.get<IDeleteAccountUseCase>(),
    ),
  );

  injector.addSingleton<IGetAccountUseCase>(
    () => GetAccountUseCaseImpl(repository: injector.get<IAccountRepository>()),
  );
  injector.addSingleton<ISaveAccountUseCase>(
    () =>
        SaveAccountUseCaseImpl(repository: injector.get<IAccountRepository>()),
  );
  injector.addSingleton<IUpdateAccountUseCase>(
    () => UpdateAccountUseCaseImpl(
      repository: injector.get<IAccountRepository>(),
    ),
  );
  injector.addSingleton<IDeleteAccountUseCase>(
    () => DeleteAccountUseCaseImpl(
      repository: injector.get<IAccountRepository>(),
    ),
  );

  // --- CHARACTER ---
  injector.addSingleton<ICharacterLocalStorage>(
    CharacterSharedPreferencesService.new,
  );

  // Repositories e serviços
  injector.addSingleton<ICharacterRepository>(
    () => CharacterRepositoryImpl(
      localStorage: injector.get<ICharacterLocalStorage>(),
    ),
  );

  // Use Cases e Facades (Comente estes se ainda não estiverem implementados)
  injector.addSingleton<IGetAllCharactersUseCase>(
    () => GetAllCharactersUseCaseImpl(
      repository: injector.get<ICharacterRepository>(),
    ),
  );
  injector.addSingleton<IGetCharacterByIdUseCase>(
    () => GetCharacterByIdUseCaseImpl(
      repository: injector.get<ICharacterRepository>(),
    ),
  );
  injector.addSingleton<ISaveCharacterUseCase>(
    () => SaveCharacterUseCaseImpl(
      repository: injector.get<ICharacterRepository>(),
    ),
  );
  injector.addSingleton<IDeleteCharacterUseCase>(
    () => DeleteCharacterUseCaseImpl(
      repository: injector.get<ICharacterRepository>(),
    ),
  );

  injector.addSingleton<ICharacterFacadeUseCases>(
    () => CharacterFacadeUseCasesImpl(
      getAllCharactersUseCase: injector.get<IGetAllCharactersUseCase>(),
      getCharacterByIdUseCase: injector.get<IGetCharacterByIdUseCase>(),
      saveCharacterUseCase: injector.get<ISaveCharacterUseCase>(),
      deleteCharacterUseCase: injector.get<IDeleteCharacterUseCase>(),
    ),
  );

  // Viewmodels
  injector.addSingleton<AccountViewModel>(
    () => AccountViewModel(injector.get<IAccountFacadeUseCases>()),
  );
  injector.addSingleton<CharactersViewModel>(
    () => CharactersViewModel(injector.get<ICharacterFacadeUseCases>()),
  );

  injector.commit();
}
