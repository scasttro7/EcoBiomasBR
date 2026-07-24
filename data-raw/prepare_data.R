# data-raw/prepare_data.R
# ---------------------------------------------------------------------------
# Script de preparação dos dados internos do pacote (data/).
# Pendente: requer shapefile oficial de biomas do IBGE, não incluído nesta
# versão do esqueleto por depender de download externo.
# ---------------------------------------------------------------------------

# limites_biomas <- sf::st_read("caminho/para/shapefile_biomas_ibge.shp")
# limites_biomas <- sf::st_simplify(limites_biomas, dTolerance = 500)
# usethis::use_data(limites_biomas, overwrite = TRUE)

# tabela_equacoes <- EcoBiomasBR:::.equation_registry()
# usethis::use_data(tabela_equacoes, overwrite = TRUE)

# NOTA: por ora, o registro de equacoes vive apenas como funcao interna
# (.equation_registry() em R/registry.R), nao como objeto de dados exportado.
# Promover para data/tabela_equacoes.rda e um passo futuro, caso seja util
# ter o registro navegavel sem carregar o pacote inteiro.
