class ValidatorHelper {
  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Intervenção: O nome completo é obrigatório para identificação.';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Intervenção: Digite o nome e pelo menos um sobrenome.';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Intervenção: O e-mail é obrigatório para o login.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Intervenção: Formato inválido. Use o padrão nome@exemplo.com.';
    }
    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Intervenção: A senha é obrigatória para proteger sua conta.';
    }
    if (value.length < 8) {
      return 'Intervenção: Aumente a segurança. Mínimo de 8 caracteres.';
    }
    if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Intervenção: A senha deve conter pelo menos uma letra.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Intervenção: A senha deve conter pelo menos um número.';
    }
    return null;
  }

  static String? validarObrigatorio(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return 'Intervenção: O campo $campo não pode ficar em branco.';
    }
    return null;
  }
}
