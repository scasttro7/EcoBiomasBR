# perturbacao.R
# ---------------------------------------------------------------------------
# Quantificação de perturbação antrópica acumulada, genérica por polígono,
# com opção de reconciliação multi-fonte (MapBiomas vs. PRODES), seguindo
# o mesmo princípio de transparência aplicado no BIODATUM (Secao 3.1.1).
# ---------------------------------------------------------------------------

#' Perturbação antrópica acumulada por polígono (PT)
#'
#' @description
#' Stub inicial: calcula a proporção de área desmatada/degradada em um
#' polígono, a partir de uma fonte de dados (MapBiomas ou PRODES). A
#' implementação completa depende de integração com Google Earth Engine ou
#' shapefiles pré-processados, e é deixada como próximo passo de
#' desenvolvimento.
#'
#' @param poligono Um objeto `sf`/`SpatialPolygons` ou caminho para
#'   shapefile representando a área de interesse.
#' @param ano_inicio Integer. Ano inicial da série.
#' @param ano_fim Integer. Ano final da série.
#' @param fonte Character. "mapbiomas" (padrão) ou "prodes".
#' @return Numeric. Proporção da área perturbada (0-1).
#' @export
perturbacao_area <- function(poligono, ano_inicio, ano_fim, fonte = "mapbiomas") {
  fonte <- tolower(fonte)
  if (!fonte %in% c("mapbiomas", "prodes")) {
    stop("'fonte' deve ser 'mapbiomas' ou 'prodes'.")
  }
  if (ano_fim < ano_inicio) {
    stop("'ano_fim' deve ser maior ou igual a 'ano_inicio'.")
  }
  stop("perturbacao_area(): integracao com fonte de dados espaciais (GEE/shapefile) ainda nao implementada nesta versao do pacote.")
}

#' Anthropic disturbance by polygon (EN)
#' @inheritParams perturbacao_area
#' @param polygon An `sf`/`SpatialPolygons` object or shapefile path.
#' @param start_year Integer. Start year.
#' @param end_year Integer. End year.
#' @param source Character. "mapbiomas" (default) or "prodes".
#' @export
disturbance_area <- function(polygon, start_year, end_year, source = "mapbiomas") {
  perturbacao_area(poligono = polygon, ano_inicio = start_year, ano_fim = end_year, fonte = source)
}

#' Reconciliar estimativas de múltiplas fontes (PT)
#'
#' @description
#' Compara estimativas de perturbação de múltiplas fontes (ex.: MapBiomas
#' vs. PRODES) para o mesmo polígono, reportando divergências de forma
#' transparente em vez de escolher silenciosamente uma fonte — mesmo
#' princípio adotado na reconciliação de T1 no BIODATUM (Secao 3.1.1).
#'
#' @param poligono Objeto espacial ou caminho de shapefile.
#' @param fontes Character vector. Fontes a comparar. Padrão:
#'   `c("mapbiomas", "prodes")`.
#' @return Um `data.frame` com uma linha por fonte e a estimativa
#'   correspondente, incluindo uma coluna de divergência percentual em
#'   relação à mediana das fontes.
#' @export
reconciliar_fontes <- function(poligono, fontes = c("mapbiomas", "prodes")) {
  stop("reconciliar_fontes(): depende de perturbacao_area() estar implementada para cada fonte; ver pendencia nessa funcao.")
}

#' Reconcile multi-source estimates (EN)
#' @inheritParams reconciliar_fontes
#' @param sources Character vector. Sources to compare.
#' @export
reconcile_sources <- function(polygon, sources = c("mapbiomas", "prodes")) {
  reconciliar_fontes(poligono = polygon, fontes = sources)
}
