# biomassa.R
# ---------------------------------------------------------------------------
# Dispatcher central de biomassa + implementações por bioma.
# Todas as funções consultam .equation_registry() (ver registry.R) para
# validar tipologia e faixa de DAP antes de calcular.
# ---------------------------------------------------------------------------

#' Estimar biomassa por bioma (dispatcher central) (PT)
#'
#' @description
#' Aplica a equação alométrica adequada conforme o bioma (e, quando
#' necessário, a tipologia) informados, delegando o cálculo para a função
#' específica registrada em [.equation_registry()].
#'
#' @param dap Numeric. Diâmetro à altura do peito (cm).
#' @param altura Numeric. Altura (m). `NULL` quando a equação não exige.
#' @param bioma Character. Um de: "amazonia", "cerrado", "mata_atlantica",
#'   "caatinga", "pantanal", "pampa".
#' @param tipologia Character. Subtipo dentro do bioma, quando aplicável
#'   (ex.: "terra_firme", "varzea" para Amazônia; "dap_3_30" ou
#'   "dap_maior_30" para Caatinga; ver [listar_equacoes()]).
#' @param ... Argumentos adicionais repassados à função específica do bioma
#'   (ex.: `dns`, `densidade_madeira` para Caatinga; `ndvi`, `cobertura`,
#'   `metodo` para Pampa).
#'
#' @return Numeric. Biomassa estimada (kg por árvore, ou conforme unidade
#'   nativa da equação do bioma — ver [listar_equacoes()] para detalhes).
#'
#' @examples
#' \dontrun{
#' biomassa_bioma(dap = 25, altura = 18, bioma = "amazonia", tipologia = "terra_firme")
#' biomassa_bioma(dap = 15, bioma = "caatinga", tipologia = "dap_3_30")
#' }
#' @export
biomassa_bioma <- function(dap = NULL, altura = NULL, bioma, tipologia = NULL, ...) {
  bioma_norm <- validar_bioma(bioma)

  fn_nome <- unique(.equation_registry()$funcao[.equation_registry()$bioma == bioma_norm])
  if (length(fn_nome) == 0) {
    stop(sprintf("Nenhuma funcao de biomassa registrada para o bioma '%s'.", bioma_norm))
  }
  fn_nome <- fn_nome[[1]]
  fn <- if ("EcoBiomasBR" %in% loadedNamespaces()) {
    get(fn_nome, envir = asNamespace("EcoBiomasBR"))
  } else {
    get(fn_nome, mode = "function")
  }

  if (bioma_norm == "pampa") {
    return(fn(...))
  }

  fn(dap = dap, altura = altura, tipologia = tipologia, ...)
}

#' Estimate biomass by biome (central dispatcher) (EN)
#'
#' @description English-language alias of [biomassa_bioma()]. See that
#'   function for full documentation.
#' @param dbh Numeric. Diameter at breast height (cm).
#' @param height Numeric. Height (m).
#' @param biome Character. One of: "amazonia", "cerrado", "mata_atlantica",
#'   "caatinga", "pantanal", "pampa".
#' @param typology Character. Sub-typology within the biome, when applicable.
#' @param ... Additional arguments passed to the biome-specific function.
#' @return Numeric. Estimated biomass.
#' @export
biomass_biome <- function(dbh = NULL, height = NULL, biome, typology = NULL, ...) {
  biomassa_bioma(dap = dbh, altura = height, bioma = biome, tipologia = typology, ...)
}

# ---------------------------------------------------------------------------
# Amazônia — importa correção alométrica do ForestR, evitando duplicação
# ---------------------------------------------------------------------------

#' Biomassa — Amazônia (PT)
#'
#' @description
#' Estima biomassa para tipologias amazônicas (terra firme, sul-oeste,
#' várzea). A correção por altura dominante é delegada ao pacote `ForestR`
#' (`ForestR::fator_correcao_altura_dominante()`,
#' `ForestR::biomassa_higuchi_corrigida()`), evitando duplicar a lógica já
#' validada no BIODATUM.
#'
#' @param dap Numeric. DAP (cm).
#' @param altura Numeric. Altura (m).
#' @param tipologia Character. Um de "terra_firme", "sul_oeste", "varzea".
#' @param ... Argumentos adicionais repassados a `ForestR` quando aplicável.
#' @return Numeric. Biomassa estimada (kg).
#' @export
biomassa_amazonia <- function(dap, altura, tipologia = "terra_firme", ...) {
  tipologia <- validar_tipologia(tipologia, "amazonia")
  validar_dap(dap)
  validar_altura(altura, exige_altura = TRUE)

  if (!requireNamespace("ForestR", quietly = TRUE)) {
    stop("O pacote 'ForestR' e necessario para biomassa_amazonia() mas nao esta instalado.")
  }

  # Delega ao ForestR a calibracao por altura dominante e a equacao de Higuchi.
  ForestR::biomassa_higuchi_corrigida(dap = dap, altura = altura, tipologia = tipologia, ...)
}

#' Biomass — Amazon (EN)
#' @inheritParams biomassa_amazonia
#' @export
biomass_amazon <- function(dap, altura, tipologia = "terra_firme", ...) {
  biomassa_amazonia(dap = dap, altura = altura, tipologia = tipologia, ...)
}

# ---------------------------------------------------------------------------
# Cerrado
# ---------------------------------------------------------------------------

#' Biomassa — Cerrado (PT)
#'
#' @description Rezende et al. (2006) — modelo para cerrado sensu stricto
#'   (Brasília/DF).
#' @param dap Numeric. DAP (cm).
#' @param altura Numeric. Altura (m).
#' @param tipologia Ignorado (Cerrado não se subdivide no registro atual).
#' @param ... Não utilizado.
#' @return Numeric. Biomassa estimada (kg).
#' @export
biomassa_cerrado <- function(dap, altura, tipologia = NULL, ...) {
  validar_dap(dap)
  validar_altura(altura, exige_altura = TRUE)
  # Placeholder: coeficientes de Rezende et al. (2006) a confirmar/parametrizar.
  # B = a * DAP^b * altura^c (forma geral log-log de modelos de cerrado).
  stop("biomassa_cerrado(): coeficientes de Rezende et al. (2006) pendentes de parametrizacao final. Ver Secao 3.2 do documento de design.")
}

#' Biomass — Cerrado (EN)
#' @inheritParams biomassa_cerrado
#' @export
biomass_cerrado <- function(dbh, height, typology = NULL, ...) {
  biomassa_cerrado(dap = dbh, altura = height, tipologia = typology, ...)
}

# ---------------------------------------------------------------------------
# Mata Atlântica
# ---------------------------------------------------------------------------

#' Biomassa — Mata Atlântica (PT)
#'
#' @description Miranda, Melo & Sanquetta (2011) — modelos ajustados para
#'   árvores de reflorestamento de restauração (Mata Atlântica/Cerrado).
#' @param dap Numeric. DAP (cm).
#' @param altura Numeric. Altura (m).
#' @param tipologia Ignorado.
#' @param ... Não utilizado.
#' @return Numeric. Biomassa estimada (kg).
#' @export
biomassa_mata_atlantica <- function(dap, altura, tipologia = NULL, ...) {
  validar_dap(dap)
  validar_altura(altura, exige_altura = TRUE)
  stop("biomassa_mata_atlantica(): coeficientes de Miranda, Melo & Sanquetta (2011) pendentes de parametrizacao final; referencia Vieira et al. (2008) ainda requer verificacao primaria.")
}

#' Biomass — Atlantic Forest (EN)
#' @inheritParams biomassa_mata_atlantica
#' @export
biomass_atlantic_forest <- function(dbh, height, typology = NULL, ...) {
  biomassa_mata_atlantica(dap = dbh, altura = height, tipologia = typology, ...)
}

# ---------------------------------------------------------------------------
# Caatinga — duas equações conforme faixa de DAP (Sampaio & Silva, 2005)
# ---------------------------------------------------------------------------

#' Biomassa — Caatinga (PT)
#'
#' @description
#' Sampaio & Silva (2005, *Acta Botanica Brasilica*), ajuste prático via
#' Lima Júnior et al.:
#' \itemize{
#'   \item DAP entre 3 e 30 cm: B(kg) = 0.1730 x DAP^2.2950 (R² = 0.918)
#'   \item DAP > 30 cm: B(kg) = 0.1648 x (AAP x altura x densidade_madeira)^0.9023,
#'     em que AAP é a área seccional à altura do peito (cm²), calculada a
#'     partir do DAP quando não informada diretamente.
#' }
#'
#' @param dap Numeric. DAP (cm).
#' @param altura Numeric. Altura (m). Exigida apenas para DAP > 30 cm.
#' @param dns Numeric. Diâmetro ao nível do solo (cm), alternativa ao DAP
#'   para plantas de porte arbustivo (não implementado nesta versão).
#' @param densidade_madeira Numeric. Densidade da madeira (g/cm³). Exigida
#'   apenas para DAP > 30 cm.
#' @param tipologia Character. Opcional; se não informado, é inferido a
#'   partir do valor de `dap` ("dap_3_30" ou "dap_maior_30").
#' @param ... Não utilizado.
#' @return Numeric. Biomassa estimada (kg).
#' @export
biomassa_caatinga <- function(dap, altura = NULL, dns = NULL,
                               densidade_madeira = NULL, tipologia = NULL, ...) {
  validar_dap(dap, dap_min = 3)

  if (is.null(tipologia)) {
    tipologia <- ifelse(dap <= 30, "dap_3_30", "dap_maior_30")
  }
  tipologia <- validar_tipologia(tipologia, "caatinga")

  if (tipologia == "dap_3_30") {
    # B(kg) = 0.1730 * DAP^2.2950
    biomassa <- 0.1730 * dap^2.2950
    return(biomassa)
  }

  # tipologia == "dap_maior_30": exige altura e densidade da madeira
  faltando <- c()
  if (is.null(altura)) faltando <- c(faltando, "altura")
  if (is.null(densidade_madeira)) faltando <- c(faltando, "densidade_madeira")
  if (length(faltando) > 0) {
    stop(sprintf(
      "Para DAP > 30 cm (equacao de Sampaio & Silva, 2005) sao obrigatorios: %s.",
      paste(faltando, collapse = ", ")
    ))
  }
  validar_altura(altura, exige_altura = TRUE)
  aap <- (pi / 4) * dap^2  # area seccional a altura do peito (cm^2), aproximada a partir do DAP
  biomassa <- 0.1648 * (aap * altura * densidade_madeira)^0.9023
  biomassa
}

#' Biomass — Caatinga (EN)
#' @inheritParams biomassa_caatinga
#' @export
biomass_caatinga <- function(dbh, height = NULL, dbh_at_ground = NULL,
                              wood_density = NULL, typology = NULL, ...) {
  biomassa_caatinga(
    dap = dbh, altura = height, dns = dbh_at_ground,
    densidade_madeira = wood_density, tipologia = typology, ...
  )
}

# ---------------------------------------------------------------------------
# Pantanal
# ---------------------------------------------------------------------------

#' Biomassa — Pantanal (PT)
#'
#' @description Sallis et al. (2006) — correlações alométricas para
#'   formações lenhosas savânicas (cordilheira/cerradão) sobre os "capões"
#'   do Pantanal.
#' @param dap Numeric. DAP (cm).
#' @param altura Numeric. Altura (m).
#' @param tipologia Character. Formação lenhosa (padrão: "cordilheira").
#' @param ... Não utilizado.
#' @return Numeric. Biomassa estimada (kg).
#' @export
biomassa_pantanal <- function(dap, altura, tipologia = "cordilheira", ...) {
  tipologia <- validar_tipologia(tipologia, "pantanal")
  validar_dap(dap)
  validar_altura(altura, exige_altura = TRUE)
  stop("biomassa_pantanal(): coeficientes de Sallis et al. (2006) pendentes de parametrizacao final a partir da fonte primaria.")
}

#' Biomass — Pantanal (EN)
#' @inheritParams biomassa_pantanal
#' @export
biomass_pantanal <- function(dbh, height, typology = "cordilheira", ...) {
  biomassa_pantanal(dap = dbh, altura = height, tipologia = typology, ...)
}

# ---------------------------------------------------------------------------
# Pampa — sem base arbórea/DAP; NDVI ou método de campo
# ---------------------------------------------------------------------------

#' Biomassa — Pampa (PT)
#'
#' @description
#' O bioma Pampa é predominantemente campestre (gramíneas nativas), sem
#' base arbórea/DAP. A estimativa é feita por NDVI (sensoriamento remoto)
#' ou por método de campo (prato ascendente/régua), não por equação
#' alométrica tradicional. Ver Rede PELD Campos Sulinos (UFSM/UFRGS).
#'
#' @param ndvi Numeric. Índice de vegetação por diferença normalizada,
#'   quando `metodo = "ndvi"`.
#' @param cobertura Numeric. Cobertura vegetal (proporção 0–1), alternativa
#'   ao NDVI.
#' @param metodo Character. "ndvi" (padrão) ou "campo".
#' @param ... Não utilizado.
#' @return Numeric. Biomassa estimada (t/ha).
#' @export
biomassa_pampa <- function(ndvi = NULL, cobertura = NULL, metodo = "ndvi", ...) {
  metodo <- tolower(metodo)
  if (!metodo %in% c("ndvi", "campo")) {
    stop("'metodo' deve ser 'ndvi' ou 'campo'.")
  }
  if (metodo == "ndvi" && is.null(ndvi)) {
    stop("metodo = 'ndvi' requer o argumento 'ndvi'.")
  }
  if (metodo == "campo" && is.null(cobertura)) {
    stop("metodo = 'campo' requer o argumento 'cobertura'.")
  }
  stop("biomassa_pampa(): modelo de conversao NDVI/cobertura -> biomassa (t/ha) pendente de calibracao a partir da literatura da Rede PELD Campos Sulinos.")
}

#' Biomass — Pampa (EN)
#' @inheritParams biomassa_pampa
#' @export
biomass_pampa <- function(ndvi = NULL, cover = NULL, method = "ndvi", ...) {
  biomassa_pampa(ndvi = ndvi, cobertura = cover, metodo = method, ...)
}
