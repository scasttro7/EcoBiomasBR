# clima.R
# ---------------------------------------------------------------------------
# Integração de variáveis climáticas (ERA5/Copernicus) por polígono.
# ---------------------------------------------------------------------------

#' Extrair variável climática por polígono (PT)
#'
#' @description
#' Stub inicial: extrai série temporal de uma variável climática
#' (temperatura, precipitação, SPEI) para um polígono, via ERA5/Copernicus.
#'
#' @param poligono Objeto espacial ou caminho de shapefile.
#' @param variavel Character. Uma de "temperatura", "precipitacao", "spei".
#' @param periodo Character vector de tamanho 2, ex.: `c("2000-01-01", "2025-12-31")`.
#' @param fonte Character. Padrão: "era5".
#' @return Um `data.frame` com série temporal (data, valor).
#' @export
clima_variavel <- function(poligono, variavel, periodo, fonte = "era5") {
  variaveis_validas <- c("temperatura", "precipitacao", "spei")
  variavel <- tolower(variavel)
  if (!variavel %in% variaveis_validas) {
    stop(sprintf("'variavel' deve ser uma de: %s.", paste(variaveis_validas, collapse = ", ")))
  }
  if (length(periodo) != 2) {
    stop("'periodo' deve ser um vetor de tamanho 2 (data inicial, data final).")
  }
  stop("clima_variavel(): integracao com ERA5/Copernicus ainda nao implementada nesta versao do pacote.")
}

#' Extract climate variable by polygon (EN)
#' @inheritParams clima_variavel
#' @param polygon Spatial object or shapefile path.
#' @param variable Character. One of "temperature", "precipitation", "spei".
#' @param period Character vector of length 2.
#' @param source Character. Default: "era5".
#' @export
climate_variable <- function(polygon, variable, period, source = "era5") {
  variavel_pt <- switch(tolower(variable),
    "temperature" = "temperatura",
    "precipitation" = "precipitacao",
    "spei" = "spei",
    tolower(variable)
  )
  clima_variavel(poligono = polygon, variavel = variavel_pt, periodo = period, fonte = source)
}

#' Identificar janela de evento climático severo (PT)
#'
#' @description Stub inicial: identifica janelas de eventos climáticos
#'   severos (ex.: ENSO) em uma série temporal já extraída.
#' @param serie Um `data.frame` retornado por [clima_variavel()].
#' @param tipo Character. Padrão: "enso".
#' @return Um `data.frame` com as janelas identificadas (início, fim,
#'   intensidade).
#' @export
evento_climatico <- function(serie, tipo = "enso") {
  stop("evento_climatico(): deteccao de eventos ENSO/severos ainda nao implementada nesta versao do pacote.")
}

#' Identify severe climate event window (EN)
#' @inheritParams evento_climatico
#' @param series A `data.frame` returned by [climate_variable()].
#' @param type Character. Default: "enso".
#' @export
climate_event <- function(series, type = "enso") {
  evento_climatico(serie = series, tipo = type)
}
