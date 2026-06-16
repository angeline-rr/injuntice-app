import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injustice_app/account/domain/models/account_entity.dart';
import 'package:injustice_app/account/domain/models/account_mapper.dart';
import 'package:injustice_app/core/typedefs/types_defs.dart';
import 'package:injustice_app/core/failure/failure.dart'; // Certifique-se de importar suas Failures
import 'package:injustice_app/core/patterns/result.dart'; // Onde está o seu Result
import 'account_remote_service_interface.dart';

class FirestoreAccountService implements IAccountRemoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirestoreAccountService() {
    print("LOG_CRÍTICO: FirestoreAccountService foi instanciado!");
  }
  @override
  Future<VoidResult> saveAccount(Account account) async {
    try {
      // Pega o usuário logado diretamente aqui, sem precisar passar pelo Command/UseCase
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      await _firestore
          .collection('accounts')
          .doc(uid)
          .set(AccountMapper.toMap(account));
      return Success(null);
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<AccountResult> getAccount() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      final doc = await _firestore.collection('accounts').doc(uid).get();
      if (doc.exists) {
        return Success(AccountMapper.fromMap(doc.data()!));
      }
      return Error(DefaultFailure("Conta não encontrada"));
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<VoidResult> deleteAccount() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Error(DefaultFailure("Usuário não logado"));

      // Deleta o documento da conta
      await _firestore.collection('accounts').doc(uid).delete();

      return Success(null);
    } catch (e) {
      return Error(DefaultFailure(e.toString()));
    }
  }

  @override
  Future<VoidResult> updateAccount(Account account) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final data = AccountMapper.toMap(account);
      print("DOC_ID_ALVO: $uid");
      print("DADOS_ENVIADOS: $data");
      final docSnapshot = await _firestore
          .collection('accounts')
          .doc(uid)
          .get();
      print("O DOCUMENTO EXISTE NO BANCO? ${docSnapshot.exists}");

      await _firestore.collection('accounts').doc(uid).update(data);

      return Success(null);
    } catch (e) {
      print("DEBUG: Erro no update: $e");
      return Error(DefaultFailure(e.toString()));
    }
  }
}
