# sensoriamento.R
# ---------------------------------------------------------------------------
# Sensoriamento remoto: GEDI (LiDAR) e PALSAR-2/ALOS-4 (SAR banda L).
# ---------------------------------------------------------------------------

#' Extrair métricas GEDI por polígono (PT)
#'
#' @description
#' Stub inicial: extrai métricas GEDI (L2A altura RH98, L2B cobertura,
#' L4A AGB) por polígono, com filtro de qualidade padrão
#' (`l4_quality_flag = 1`, `degrade_flag = 0`), seguindo o mesmo protocolo
#' adotado no BIODATUM/ForestR.
#'
#' @param poligono Objeto espacial ou caminho de shapefile.
#' @param produto Character vector. Um ou mais de "L2A", "L2B", "L4A".
#' @param filtro_qualidade Logical. Aplicar filtro padrão de qualidade?
#'   Padrão: `TRUE`.
#' @return Um `data.frame` com as métricas extraídas por shot/pixel.
#' @export
gedi_extrair <- function(poligono, produto = c("L2A", "L2B", "L4A"), filtro_qualidade = TRUE) {
  produtos_validos <- c("L2A", "L2B", "L4A")
  if (!all(produto %in% produtos_validos)) {
    stop(sprintf("'produto' deve ser um subconjunto de: %s.", paste(produtos_validos, collapse = ", ")))
  }
  stop("gedi_extrair(): integracao com Google Earth Engine ainda nao implementada nesta versao do pacote.")
}

#' Extract GEDI metrics by polygon (EN)
#' @inheritParams gedi_extrair
#' @param polygon Spatial object or shapefile path.
#' @param product Character vector. One or more of "L2A", "L2B", "L4A".
#' @param quality_filter Logical. Apply standard quality filter? Default: `TRUE`.
#' @export
gedi_extract <- function(polygon, product = c("L2A", "L2B", "L4A"), quality_filter = TRUE) {
  gedi_extrair(poligono = polygon, produto = product, filtro_qualidade = quality_filter)
}

#' Densidade de shots GEDI válidos (PT)
#'
#' @description Stub inicial: verifica a densidade de shots GEDI válidos
#'   por pixel em um polígono e período, mesmo diagnóstico aplicado em
#'   T1/T2 no BIODATUM.
#' @param poligono Objeto espacial ou caminho de shapefile.
#' @param periodo Character vector de tamanho 2.
#' @return Numeric. Densidade média de shots válidos por pixel.
#' @export
densidade_shots <- function(poligono, periodo) {
  if (length(periodo) != 2) {
    stop("'periodo' deve ser um vetor de tamanho 2.")
  }
  stop("densidade_shots(): integracao com Google Earth Engine ainda nao implementada nesta versao do pacote.")
}

#' Valid GEDI shot density (EN)
#' @inheritParams densidade_shots
#' @param polygon Spatial object or shapefile path.
#' @param period Character vector of length 2.
#' @export
shot_density <- function(polygon, period) {
  densidade_shots(poligono = polygon, periodo = period)
}

#' Sinalizar saturação de sinal LiDAR (PT)
#'
#' @description Sinaliza risco de saturação do sinal GEDI em dossel fechado
#'   com AGB acima de um limiar (padrão: 150 Mg/ha), condição documentada
#'   por Dubayah et al. (2020) e Chave et al. (2019).
#' @param agb Numeric. AGB estimada (Mg/ha).
#' @param limiar Numeric. Limiar de saturação. Padrão: 150.
#' @return Logical. `TRUE` se houver risco de saturação.
#' @export
saturacao_lidar <- function(agb, limiar = 150) {
  if (!is.numeric(agb) || any(is.na(agb))) {
    stop("'agb' deve ser numerico e sem NA.")
  }
  agb > limiar
}

#' Flag LiDAR signal saturation (EN)
#' @inheritParams saturacao_lidar
#' @param threshold Numeric. Saturation threshold. Default: 150.
#' @export
lidar_saturation <- function(agb, threshold = 150) {
  saturacao_lidar(agb = agb, limiar = threshold)
}

#' Integrar dados PALSAR-2/ALOS-4 (PT)
#'
#' @description Stub inicial para integração de dados radar de banda L
#'   (PALSAR-2/ALOS-4), em articulação com o Dr. Edson Sano/Embrapa.
#' @param poligono Objeto espacial ou caminho de shapefile.
#' @param ... Argumentos adicionais (a definir conforme disponibilidade e
#'   nível de processamento dos dados PALSAR).
#' @return Um `data.frame` com as métricas radar extraídas (estrutura a
#'   definir).
#' @export
palsar_integrar <- function(poligono, ...) {
  stop("palsar_integrar(): aguardando definicoes tecnicas sobre disponibilidade, resolucao e nivel de processamento dos dados PALSAR-2/ALOS-4.")
}

#' Integrate PALSAR-2/ALOS-4 data (EN)
#' @inheritParams palsar_integrar
#' @param polygon Spatial object or shapefile path.
#' @export
palsar_integrate <- function(polygon, ...) {
  palsar_integrar(poligono = polygon, ...)
}
