import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injustice_app/account/domain/models/character_mapper.dart';
import 'package:injustice_app/authentication/presentation/controllers/auth_session_viewmodel.dart';
import 'package:injustice_app/core/di/dependency_injection.dart';
import 'package:injustice_app/core/failure/failure.dart';
import 'package:injustice_app/core/patterns/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/typedefs/types_defs.dart';
import 'character_repository_interface.dart';
import '../services/local/character_local_storage_interface.dart';
import '../../domain/models/character_entity.dart';

/// implementacao do repositorio de character

final class CharacterRepositoryImpl implements ICharacterRepository {
  final ICharacterLocalStorage _localStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthViewModel _auth = injector.get<AuthViewModel>();

  CharacterRepositoryImpl({required ICharacterLocalStorage localStorage})
    : _localStorage = localStorage;

  @override
  Future<CharacterResult> deleteCharacter(CharacterIdParams params) async {
  final localResult = await _localStorage.deleteCharacter(params);
  
  final uid = _auth.session.session.value?.user.id;
  if (uid != null) {
    try {
      await _firestore
          .collection('accounts')
          .doc(uid)
          .collection('characters')
          .doc(params.id) 
          .delete();
    } catch (e) {
      print("Erro ao deletar personagem do Firebase: $e");
    }
  }
  
  return localResult;
  }

  @override
  Future<CharacterResult> getCharacterById(String id) async {
    return _localStorage.getCharacterById(id);
  }

  @override
  Future<ListCharacterResult> getAllCharacters() async {
    final result = await _localStorage.getAllCharacters();
  final uid = _auth.session.session.value?.user.id;

  return result.fold(
    onFailure: (_) => result,
    onSuccess: (list) {
      final filtered = list.where((c) => c.userId == uid).toList();
      return Success(filtered);
    },
  );
  }

  @override
  Future<CharacterResult> saveCharacter(Character character) async {
 final localResult = await _localStorage.saveCharacter(character);
  
  final uid = _auth.session.session.value?.user.id;
  
  // VERIFICAÇÃO DE SEGURANÇA
  print("DEBUG FIREBASE: UID capturado: $uid");
  print("DEBUG FIREBASE: ID do Personagem: ${character.id}");
  
  if (uid != null) {
    final map = CharacterMapper.toMap(character);
    print("DEBUG FIREBASE: Mapa enviado: $map"); // Veja se o 'userId' está aqui!
    
    await _firestore
        .collection('accounts')
        .doc(uid)
        .collection('characters')
        .doc(character.id)
        .set(map);
  } else {
    print("DEBUG FIREBASE: ERRO! UID é nulo, não é possível salvar no Firebase.");
  }

  return localResult;
}}