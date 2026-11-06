/// Local catalog, reviewed against the researchers’ source document (2026-10-21).
/// Codes are persisted; labels and references can evolve independently.
class InventiveConcept {
  final String code, label, summary, reference, url;
  const InventiveConcept(
    this.code,
    this.label,
    this.summary,
    this.reference,
    this.url,
  );
}

class InventiveCatalog {
  static const practicesKey = 'praticas_inventivas';
  static const methodologiesKey = 'metodologias_inventivas';
  static const keys = [practicesKey, methodologiesKey];
  static const sourceUrl =
      'https://docs.google.com/document/d/1vim56rGs0j5d2ZVtASM6xB9rrGahDg2MUo-2kkhraBo/edit';
  static const concepts = <InventiveConcept>[
    InventiveConcept(
      "saigon",
      "SaIGOn — SimpoiéticA, Inventiva, Gamificada e OnLIFE",
      "Prática que articula cocriação, inventividade e gamificação em rede. A referência apresenta a vivência Novas Aventuras de Dom Quixote.",
      "Oliveira, Andrade e Schlemmer, 2022",
      "https://vjshr.uabpt.uema.br/index.php/ojs/article/view/15",
    ),
    InventiveConcept(
      "imerge",
      "iMERGE — Inventive iMmERsive Gamified Experience",
      "Prática apresentada na vivência Alice no Labirinto da Aprendizagem. Consulte a referência para conhecer a experiência em seu contexto.",
      "Oliveira, Menezes e Schlemmer, 2021",
      "http://www.guaritadigital.com.br/casaleiria/acervo/educacao/ohabitar/55/index.html",
    ),
    InventiveConcept(
      "vic",
      "VIC — Vivência Imersiva na Cibricidade",
      "As referências apresentam vivências imersivas na cibricidade, incluindo a cocriação de experiências em Peso da Régua.",
      "Schlemmer et al., 2025",
      "https://publications.immersivelrn.org/index.php/academic/article/view/322",
    ),
    InventiveConcept(
      "niig",
      "NIIG — Narrativas Imersivas, Inventivas e Gamificadas",
      "Narrativas discutidas no contexto da formação docente para a era digital. A referência aborda sua cocriação e os letramentos que emergem desse percurso.",
      "Schell, Schuster e Schlemmer, 2025",
      "https://revistas.uneb.br/faeeba/article/view/22908",
    ),
    InventiveConcept(
      "escape_game",
      "Escape Game",
      "A publicação indicada aborda inventividade, imersão e cognição em Escape Games. Consulte-a para conhecer seus fundamentos e experiências.",
      "Escape Games: inventividade, imersão e cognição",
      "https://www.researchgate.net/publication/340609112_ESCAPE_GAMES_inventividade_imersao_e_cognicao",
    ),
    InventiveConcept(
      "mup_erg",
      "MUP-ERG — Mobile/Ubiquitous/Pervasive Extended Reality Gamification",
      "Apresentação bibliográfica de uma prática citada entre as práticas simpoiéticas, inventivas e gamificadas. O documento-base relaciona as experiências In Vino Veritas e Ágora do Saber.",
      "Schlemmer e Moreira, 2022",
      "https://revistas.uneb.br/faeeba/article/view/11767",
    ),
    InventiveConcept(
      "che",
      "CHE — Contextual Hybrid Escape",
      "Apresentação bibliográfica: consulte o estudo sobre a reconfiguração das práticas pedagógicas para compreender esta abordagem em seu contexto.",
      "Schuster et al., 2024",
      "https://doi.org/10.1590/SciELOPreprints.6827",
    ),
    InventiveConcept(
      "rupu",
      "RuPu — Rastos Urbanos e Pós-Urbanos",
      "Prática mencionada entre as práticas pedagógicas simpoiéticas, inventivas e gamificadas. Esta apresentação bibliográfica remete ao estudo indicado.",
      "Schlemmer e Moreira, 2022",
      "https://revistas.uneb.br/faeeba/article/view/11767",
    ),
    InventiveConcept(
      "esc_traces",
      "EsC-Traces — Escape, Computational Thinking and Traces",
      "Prática mencionada no levantamento teórico entre as práticas simpoiéticas, inventivas e gamificadas. Consulte a referência para aprofundamento.",
      "Schlemmer e Moreira, 2022",
      "https://revistas.uneb.br/faeeba/article/view/11767",
    ),
    InventiveConcept(
      "competences_power_hybrid_card_game",
      "Competences Power Hybrid Card Game",
      "Jogo híbrido relacionado ao desenvolvimento de competências no paradigma da Educação OnLIFE. Referência: Stricto Sensu Competences Power Hybrid Card Game, p. 265–281.",
      "Schlemmer e Oliveira, 2024",
      "https://doi.org/10.29327/5365072.1-9",
    ),
    InventiveConcept(
      "pag",
      "PAG — Projetos de Aprendizagem Gamificados",
      "Metodologia inventiva para a educação na cultura híbrida e multimodal que articula projetos de aprendizagem e gamificação.",
      "Schlemmer, 2018",
      "https://periodicos.furg.br/momento/article/view/7801",
    ),
    InventiveConcept(
      "biblioteca_viva",
      "BV — Biblioteca Viva",
      "Metodologia inventiva desenvolvida no âmbito da plataforma de interação ecológica Inven!RA.",
      "Lehnemann, 2022",
      "https://repositorio.jesuita.org.br/handle/UNISINOS/11806",
    ),
    InventiveConcept(
      "versonlife",
      "VersOnLIFE",
      "Metodologia inventivo-conectiva para a Educação OnLIFE em metaversos, constituída na articulação entre pesquisa, desenvolvimento e formação.",
      "Schlemmer, Di Felice e Schuster, 2025",
      "https://publications.immersivelrn.org/index.php/academic/article/view/355",
    ),
  ];
  static List<InventiveConcept> options(String key) =>
      key == practicesKey ? concepts.sublist(0, 10) : concepts.sublist(10);
  static InventiveConcept? find(String key, String code) {
    for (final concept in options(key)) {
      if (concept.code == code) return concept;
    }
    return null;
  }

  static String title(String key) => key == practicesKey
      ? 'Práticas pedagógicas inventivas'
      : 'Metodologias inventivas';
  static String group(String key) =>
      key == practicesKey ? 'Práticas' : 'Metodologias';
  static bool isLegacy(dynamic value) =>
      value != null &&
      !(value is List && value.every((item) => item is String));
  static List<String> codes(dynamic value) =>
      isLegacy(value) || value == null ? [] : List<String>.from(value as List);
  static bool hasValue(dynamic value) =>
      value != null && (!(value is List) || value.isNotEmpty);
  static String label(String key, String code) =>
      find(key, code)?.label ?? 'Classificação não reconhecida nesta versão';
}

/// Patch only edited metadata. Preserve unconfigured fields, JSON types,
/// unknown classification codes and legacy values until explicit replacement.
Map<String, dynamic> mergeClueMetadata(
  Map<String, dynamic> original,
  Map<String, String> text,
  Map<String, dynamic> classifications,
) {
  final result = Map<String, dynamic>.from(original);
  for (final entry in text.entries) {
    if (InventiveCatalog.keys.contains(entry.key)) continue;
    final previous = original[entry.key]?.toString() ?? '';
    if (entry.value == previous) continue;
    if (entry.value.trim().isEmpty) {
      result.remove(entry.key);
    } else {
      result[entry.key] = entry.value.trim();
    }
  }
  result.addAll(classifications);
  return result;
}
