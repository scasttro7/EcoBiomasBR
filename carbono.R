# carbono.R
# ---------------------------------------------------------------------------
# Conversão biomassa -> carbono. Fator padrão IPCC (2006) = 0.47, fixo como
# default para todos os biomas, mas sobrescrevível via argumento `fator`.
# ---------------------------------------------------------------------------

#' Converter biomassa em carbono (PT)
#'
#' @description
#' Aplica o fator de conversão biomassa-carbono. O padrão (0.47) segue o
#' IPCC (2006) e é mantido fixo para todos os biomas, salvo indicação
#' contrária explícita via `fator` — não há, por ora, evidência suficiente
#' na literatura consultada para justificar fatores diferenciados por bioma.
#'
#' @param agb Numeric. Biomassa acima do solo (Mg/ha ou kg, conforme
#'   unidade de entrada; a saída preserva a mesma unidade).
#' @param bioma Character. Bioma (usado apenas para registro/rastreabilidade;
#'   não altera o fator por padrão).
#' @param fator Numeric. Fator de conversão biomassa->carbono. Padrão: 0.47
#'   (IPCC, 2006).
#' @return Numeric. Carbono estimado, mesma unidade de `agb`.
#' @export
carbono_bioma <- function(agb, bioma = NULL, fator = 0.47) {
  if (!is.numeric(agb) || any(is.na(agb)) || any(agb < 0)) {
    stop("'agb' deve ser numerico, nao-negativo e sem NA.")
  }
  if (!is.null(bioma)) {
    validar_bioma(bioma)
  }
  if (!is.numeric(fator) || fator <= 0 || fator >= 1) {
    stop("'fator' deve ser numerico e estar entre 0 e 1 (ex.: 0.47, padrao IPCC 2006).")
  }
  agb * fator
}

#' Convert biomass to carbon (EN)
#' @inheritParams carbono_bioma
#' @param biome Character. Biome (for traceability only).
#' @param factor Numeric. Biomass-to-carbon conversion factor. Default: 0.47.
#' @export
carbon_biome <- function(agb, biome = NULL, factor = 0.47) {
  carbono_bioma(agb = agb, bioma = biome, fator = factor)
}

#' Carbono potencial por tipologia (PT)
#'
#' @description Stub: estimativa de carbono potencial máximo por tipologia
#'   florestal, usado como referência para índices de eficiência (ex.:
#'   componente C do IRFA no ForestR). Pendente de parametrização por bioma
#'   fora da Amazônia.
#' @param bioma Character. Bioma.
#' @param tipologia Character. Tipologia dentro do bioma.
#' @return Numeric. Carbono potencial (Mg/ha).
#' @export
carbono_potencial <- function(bioma, tipologia = NULL) {
  bioma <- validar_bioma(bioma)
  stop(sprintf(
    "carbono_potencial(): valores de referencia regionais pendentes de levantamento para o bioma '%s' (disponiveis atualmente apenas via ForestR para Amazonia).",
    bioma
  ))
}

#' Potential carbon by typology (EN)
#' @inheritParams carbono_potencial
#' @param biome Character. Biome.
#' @param typology Character. Typology within the biome.
#' @export
carbon_potential <- function(biome, typology = NULL) {
  carbono_potencial(bioma = biome, tipologia = typology)
}
