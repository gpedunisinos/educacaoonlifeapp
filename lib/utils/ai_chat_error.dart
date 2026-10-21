/// Only display known backend messages; never echo arbitrary response/URL data.
String aiChatError(
  Object error, {
  String fallback =
      'Não foi possível enviar a mensagem. Tente novamente em instantes.',
}) {
  const allowed = [
    'A inteligência artificial está temporariamente sem quota. Tente novamente mais tarde.',
    'O modelo Gemini configurado não está disponível. Nenhum modelo alternativo foi utilizado.',
    'Não foi possível consultar a inteligência artificial agora. Tente novamente.',
    'O limite de consultas desta resposta foi atingido. Refine a pergunta para continuar.',
    'A inteligência artificial ainda não foi configurada no servidor.',
    'As consultas da inteligência artificial não estão disponíveis no servidor.',
    'A inteligência artificial não retornou uma resposta válida.',
    'A inteligência artificial não retornou texto para exibir.',
    'O modelo solicitou uma consulta indisponível nesta conversa.',
    'A consulta da inteligência artificial excedeu o tempo disponível. Tente novamente.',
    'A inteligência artificial retornou uma resposta inválida.',
  ];
  if (error is! String || !allowed.contains(error)) return fallback;
  return switch (error) {
    'A inteligência artificial está temporariamente sem quota. Tente novamente mais tarde.' =>
      'O serviço de IA atingiu seu limite temporário de uso. Tente novamente mais tarde.',
    'O modelo Gemini configurado não está disponível. Nenhum modelo alternativo foi utilizado.' =>
      'O serviço de IA configurado está indisponível. Tente novamente mais tarde.',
    'A inteligência artificial ainda não foi configurada no servidor.' ||
    'As consultas da inteligência artificial não estão disponíveis no servidor.' =>
      'O serviço de IA ainda não está disponível nesta plataforma.',
    _ => error,
  };
}
