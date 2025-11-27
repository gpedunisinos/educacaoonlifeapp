import 'package:unisinos_usp_app/models/user_model.dart';

class UserOptions {
  static final Map<String, String> profileOptions = {
    for (var type in ProfileTypeEnum.values) type.name: type.description,
  };

  static const Map<String, String> statusOptions = {
    '1': 'Ativo',
    '0': 'Inativo',
  };

  static const Map<String, String> notifyOptions = {
    'true': 'Sim',
    'false': 'Não',
  };

  static const Map<String, String> sortOptions = {
    'name': 'Nome',
    'email': 'E-mail',
    'cpf': 'CPF',
    'created_at': 'Data de Cadastro',
  };

  static const Map<String, String> orderOptions = {
    'asc': 'Crescente',
    'desc': 'Decrescente',
  };
}
