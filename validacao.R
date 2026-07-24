# validacao.R
# ---------------------------------------------------------------------------
# Funções de validação de entrada, chamadas no início de cada função de
# biomassa/carbono/perturbação antes do dispatch. Mantém o restante do
# pacote livre de checagens repetidas.
# ---------------------------------------------------------------------------

.biomas_validos <- c(
  "amazonia", "cerrado", "mata_atlantica", "caatinga", "pantanal", "pampa"
)

#' Normaliza o nome do bioma para o padrão interno
#' @keywords internal
.normalizar_bioma <- function(bioma) {
  bioma <- tolower(bioma)
  bioma <- iconv(bioma, from = "UTF-8", to = "ASCII//TRANSLIT")
  bioma <- gsub("[^a-z0-9_]", "_", bioma)
  bioma <- gsub("__+", "_", bioma)
  bioma <- gsub("^_|_$", "", bioma)
  bioma
}

#' Validar nome de bioma (PT)
#'
#' @param bioma Character. Nome do bioma informado pelo usuário.
#' @return Character. Nome do bioma normalizado, se válido. Interrompe a
#'   execução com erro informativo caso o bioma não seja reconhecido.
#' @export
validar_bioma <- function(bioma) {
  if (missing(bioma) || is.null(bioma) || is.na(bioma) || !nzchar(bioma)) {
    stop("O argumento 'bioma' e obrigatorio e nao pode ser vazio.")
  }
  bioma_norm <- .normalizar_bioma(bioma)
  if (!bioma_norm %in% .biomas_validos) {
    stop(sprintf(
      "Bioma '%s' nao reconhecido. Biomas validos: %s.",
      bioma, paste(.biomas_validos, collapse = ", ")
    ))
  }
  bioma_norm
}

#' Validate biome name (EN)
#' @param biome Character. Biome name.
#' @return Character. Normalized, validated biome name.
#' @export
validate_biome <- function(biome) {
  validar_bioma(bioma = biome)
}

#' Validar DAP (PT)
#'
#' @param dap Numeric. Diâmetro à altura do peito (cm).
#' @param dap_min Numeric. Limite mínimo de validade da equação (opcional).
#' @param dap_max Numeric. Limite máximo de validade da equação (opcional).
#' @return Invisibly returns `dap` if valid. Emits a warning (not an error)
#'   when `dap` está fora da faixa de validade da equação, pois a estimativa
#'   ainda é computável, mas com incerteza maior.
#' @export
validar_dap <- function(dap, dap_min = NA, dap_max = NA) {
  if (!is.numeric(dap) || any(is.na(dap))) {
    stop("'dap' deve ser numerico e nao pode conter NA.")
  }
  if (any(dap <= 0)) {
    stop("'dap' deve ser um valor positivo (cm).")
  }
  if (!is.na(dap_min) && any(dap < dap_min)) {
    warning(sprintf(
      "Um ou mais valores de DAP estao abaixo da faixa de validade da equacao (minimo: %s cm). Estimativa sujeita a maior incerteza.",
      dap_min
    ))
  }
  if (!is.na(dap_max) && any(dap > dap_max)) {
    warning(sprintf(
      "Um ou mais valores de DAP estao acima da faixa de validade da equacao (maximo: %s cm). Estimativa sujeita a maior incerteza.",
      dap_max
    ))
  }
  invisible(dap)
}

#' Validate DBH (EN)
#' @param dbh Numeric. Diameter at breast height (cm).
#' @param dbh_min Numeric. Optional lower validity bound.
#' @param dbh_max Numeric. Optional upper validity bound.
#' @export
validate_dbh <- function(dbh, dbh_min = NA, dbh_max = NA) {
  validar_dap(dap = dbh, dap_min = dbh_min, dap_max = dbh_max)
}

#' Validar altura (PT)
#'
#' @param altura Numeric. Altura total ou comercial (m). Pode ser `NULL`
#'   quando a equação não exige altura.
#' @param exige_altura Logical. A equação em uso exige altura como
#'   covariável?
#' @return Invisibly returns `altura` if valid.
#' @export
validar_altura <- function(altura, exige_altura = FALSE) {
  if (exige_altura && is.null(altura)) {
    stop("Esta equacao exige 'altura' como covariavel, mas nenhum valor foi informado.")
  }
  if (!is.null(altura)) {
    if (!is.numeric(altura) || any(is.na(altura))) {
      stop("'altura' deve ser numerica e nao pode conter NA.")
    }
    if (any(altura <= 0)) {
      stop("'altura' deve ser um valor positivo (m).")
    }
  }
  invisible(altura)
}

#' Validate height (EN)
#' @param height Numeric. Total or commercial height (m).
#' @param requires_height Logical. Does the equation require height?
#' @export
validate_height <- function(height, requires_height = FALSE) {
  validar_altura(altura = height, exige_altura = requires_height)
}

#' Validar coordenadas geográficas (PT)
#'
#' @param lat Numeric. Latitude em graus decimais.
#' @param lon Numeric. Longitude em graus decimais.
#' @return Invisibly returns `c(lat, lon)` if valid.
#' @export
validar_coordenadas <- function(lat, lon) {
  if (!is.numeric(lat) || !is.numeric(lon)) {
    stop("'lat' e 'lon' devem ser numericos.")
  }
  if (any(lat < -90 | lat > 90)) {
    stop("'lat' deve estar entre -90 e 90 graus.")
  }
  if (any(lon < -180 | lon > 180)) {
    stop("'lon' deve estar entre -180 e 180 graus.")
  }
  # Aviso brando: coordenadas fora do território brasileiro aproximado.
  if (any(lat > 6 | lat < -34 | lon > -28 | lon < -74)) {
    warning("Coordenadas fora dos limites aproximados do territorio brasileiro. Verifique lat/lon.")
  }
  invisible(c(lat = lat, lon = lon))
}

#' Validate coordinates (EN)
#' @param lat Numeric. Decimal degrees latitude.
#' @param lon Numeric. Decimal degrees longitude.
#' @export
validate_coordinates <- function(lat, lon) {
  validar_coordenadas(lat = lat, lon = lon)
}

#' Validar tipologia dentro de um bioma (PT)
#'
#' @param tipologia Character. Tipologia informada (ex.: "terra_firme").
#' @param bioma Character. Bioma já validado/normalizado.
#' @return Invisibly returns the normalized `tipologia` if valid (or `NA`
#'   when the equation for that biome does not require one).
#' @export
validar_tipologia <- function(tipologia, bioma) {
  registro <- .equation_registry()
  disponiveis <- registro$tipologia[registro$bioma == bioma]
  disponiveis <- disponiveis[!is.na(disponiveis)]

  if (length(disponiveis) == 0) {
    # Bioma sem subdivisão por tipologia (ex.: Cerrado, Mata Atlantica, Pampa)
    return(invisible(NA_character_))
  }
  if (is.null(tipologia) || is.na(tipologia)) {
    stop(sprintf(
      "O bioma '%s' requer o argumento 'tipologia'. Opcoes disponiveis: %s.",
      bioma, paste(disponiveis, collapse = ", ")
    ))
  }
  tipologia_norm <- .normalizar_bioma(tipologia)
  if (!tipologia_norm %in% disponiveis) {
    stop(sprintf(
      "Tipologia '%s' invalida para o bioma '%s'. Opcoes disponiveis: %s.",
      tipologia, bioma, paste(disponiveis, collapse = ", ")
    ))
  }
  invisible(tipologia_norm)
}

#' Validate typology within a biome (EN)
#' @param typology Character. Informed typology.
#' @param biome Character. Already-validated/normalized biome.
#' @export
validate_typology <- function(typology, biome) {
  validar_tipologia(tipologia = typology, bioma = biome)
}
