# registry.R
# ---------------------------------------------------------------------------
# Registro central de equações alométricas (equation_registry).
#
# Em vez de dispersar a lógica de seleção de equação em blocos if/else dentro
# de cada função de biomassa, o EcoBiomasBR mantém uma tabela única com todos os
# metadados necessários para o dispatcher decidir qual equação aplicar, e para
# listar_equacoes()/list_equations() responder de forma transparente qual
# fonte foi usada.
#
# Colunas:
#   bioma           - nome do bioma (padronizado, minúsculas, sem acento)
#   tipologia       - subtipo dentro do bioma (ex.: "terra_firme", "varzea",
#                     "cordilheira", "cerrado_sensu_stricto"); NA se não houver
#                     subdivisão relevante
#   dap_min, dap_max- faixa de validade do DAP (cm) em que a equação foi
#                     calibrada; NA quando não aplicável (ex.: Pampa, não-DAP)
#   exige_altura    - logical; a equação requer altura como covariável?
#   funcao          - nome da função R que implementa a equação
#   referencia      - citação abreviada (autor, ano) da fonte primária
#   observacoes     - ressalvas metodológicas relevantes
# ---------------------------------------------------------------------------

#' Registro de equações alométricas do EcoBiomasBR
#'
#' @description
#' `equation_registry` é uma tabela interna (não exportada como dado público
#' editável) que centraliza os metadados de todas as equações alométricas
#' disponíveis no pacote. É a fonte única consultada por [biomassa_bioma()],
#' [listar_equacoes()] e pelas rotinas de validação.
#'
#' @keywords internal
.equation_registry <- function() {
  data.frame(
    bioma = c(
      "amazonia", "amazonia", "amazonia",
      "cerrado",
      "mata_atlantica",
      "caatinga", "caatinga",
      "pantanal",
      "pampa"
    ),
    tipologia = c(
      "terra_firme", "sul_oeste", "varzea",
      NA_character_,
      NA_character_,
      "dap_3_30", "dap_maior_30",
      "cordilheira",
      NA_character_
    ),
    dap_min = c(5, 5, 5, NA, NA, 3, 30, NA, NA),
    dap_max = c(NA, NA, NA, NA, NA, 30, NA, NA, NA),
    exige_altura = c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE),
    funcao = c(
      "biomassa_amazonia", "biomassa_amazonia", "biomassa_amazonia",
      "biomassa_cerrado",
      "biomassa_mata_atlantica",
      "biomassa_caatinga", "biomassa_caatinga",
      "biomassa_pantanal",
      "biomassa_pampa"
    ),
    referencia = c(
      "Higuchi et al. (1998)",
      "Nogueira et al. (2008)",
      "Baia et al. (2025)",
      "Rezende et al. (2006)",
      "Miranda, Melo & Sanquetta (2011)",
      "Sampaio & Silva (2005); Lima Junior et al.",
      "Sampaio & Silva (2005); Lima Junior et al.",
      "Sallis et al. (2006)",
      "N/A (metodo nao-alometrico: NDVI/campo)"
    ),
    observacoes = c(
      "Modelo terra firme Amazonia Central; requer calibracao por altura dominante (ver ForestR::fator_correcao_altura_dominante).",
      "Ajustes/extrapolacoes para sul e oeste amazonico.",
      "Calibrado em varzea de agua branca (nordeste amazonico); extrapolacao para outras tipologias de varzea e limitacao reconhecida.",
      "Cerrado sensu stricto, Brasilia/DF; comparacao de multiplos modelos.",
      "Ajustado para arvores de reflorestamento de restauracao (Mata Atlantica e Cerrado); nao especifico de floresta primaria.",
      "Equacao B(kg) = 0.1730 * DAP^2.2950 (R2 = 0.918), 10 especies caatinga.",
      "Equacao B(kg) = 0.1648 * (AAP x H x rho)^0.9023 para DAP > 30 cm.",
      "Formacoes lenhosas savanicas (cordilheira/cerradao) sobre os capoes do Pantanal.",
      "Bioma predominantemente campestre; nao ha equacao alometrica por DAP. Estimativa por NDVI ou metodo de campo (prato ascendente/regua)."
    ),
    stringsAsFactors = FALSE
  )
}

#' Listar equações alométricas disponíveis (PT)
#'
#' @param bioma Character. Nome do bioma (ex.: "amazonia", "cerrado",
#'   "mata_atlantica", "caatinga", "pantanal", "pampa"). Se `NULL`, retorna
#'   o registro completo.
#'
#' @return Um `data.frame` com as equações disponíveis e seus metadados.
#' @export
listar_equacoes <- function(bioma = NULL) {
  registro <- .equation_registry()
  if (is.null(bioma)) {
    return(registro)
  }
  bioma <- .normalizar_bioma(bioma)
  resultado <- registro[registro$bioma == bioma, ]
  if (nrow(resultado) == 0) {
    warning(sprintf("Nenhuma equacao registrada para o bioma '%s'.", bioma))
  }
  resultado
}

#' List available allometric equations (EN)
#'
#' @description English-language alias of [listar_equacoes()]. See that
#'   function for full documentation.
#' @param biome Character. Biome name. If `NULL`, returns the full registry.
#' @return A `data.frame` with available equations and metadata.
#' @export
list_equations <- function(biome = NULL) {
  listar_equacoes(bioma = biome)
}
