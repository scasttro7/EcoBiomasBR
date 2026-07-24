# bioma_dispatcher.R
# ---------------------------------------------------------------------------
# Identificação de bioma a partir de coordenadas ou shapefile, usando os
# limites oficiais IBGE. Complementa o dispatcher de biomassa em biomassa.R.
# ---------------------------------------------------------------------------

#' Classificar bioma a partir de coordenadas (PT)
#'
#' @description
#' Stub inicial: identifica o bioma brasileiro correspondente a uma
#' coordenada geográfica, a partir dos limites oficiais IBGE. A
#' implementação completa depende do carregamento do shapefile interno
#' `limites_biomas` (ver Seção 4 do documento de design).
#'
#' @param lat Numeric. Latitude em graus decimais.
#' @param lon Numeric. Longitude em graus decimais.
#' @return Character. Nome do bioma identificado.
#' @export
classificar_bioma <- function(lat, lon) {
  validar_coordenadas(lat, lon)
  stop("classificar_bioma(): carregamento do shapefile interno 'limites_biomas' (IBGE) ainda nao implementado nesta versao do pacote.")
}

#' Classify biome from coordinates (EN)
#' @inheritParams classificar_bioma
#' @export
classify_biome <- function(lat, lon) {
  classificar_bioma(lat = lat, lon = lon)
}

#' Identificar bioma(s) a partir de shapefile (PT)
#'
#' @description Stub inicial: identifica o(s) bioma(s) sobrepostos a um
#'   polígono fornecido pelo usuário (útil quando a área de estudo cruza
#'   mais de um bioma).
#' @param shp Um objeto `sf`/`SpatialPolygons` ou caminho para shapefile.
#' @return Character vector. Bioma(s) sobrepostos ao polígono.
#' @export
bioma_from_shapefile <- function(shp) {
  stop("bioma_from_shapefile(): carregamento do shapefile interno 'limites_biomas' (IBGE) ainda nao implementado nesta versao do pacote.")
}

#' Identify biome(s) from shapefile (EN)
#' @inheritParams bioma_from_shapefile
#' @export
biome_from_shapefile <- function(shp) {
  bioma_from_shapefile(shp)
}
