# EcoBiomasBR

<!-- badges: start -->
![status](https://img.shields.io/badge/status-desenvolvimento-yellow)
![tests](https://img.shields.io/badge/testes-40%2F40%20passando-brightgreen)
![lang](https://img.shields.io/badge/idioma-PT%20%2F%20EN-blue)
<!-- badges: end -->

Equações alométricas, biomassa, carbono, perturbação antrópica, clima e
sensoriamento remoto para os seis biomas brasileiros — **Amazônia, Cerrado,
Mata Atlântica, Caatinga, Pantanal e Pampa** — com funções expostas
**bilíngue (PT/EN)**.

Diferente de pacotes de biomassa tropical genéricos (ex.: `BIOMASS`, que usa
equações pantropicais de Chave et al.), o EcoBiomasBR organiza equações
**calibradas por bioma brasileiro** por trás de um dispatcher central único:

```r
biomassa_bioma(dap = 25, altura = 18, bioma = "amazonia", tipologia = "terra_firme")
biomass_biome(dbh = 25, height = 18, biome = "amazonia", typology = "terra_firme")  # equivalente em EN
```

O pacote é independente do [`ForestR`](https://github.com/) (metodológico,
específico do projeto BIODATUM), mas **importa** dele a lógica de correção
alométrica por altura dominante para a Amazônia
(`ForestR::fator_correcao_altura_dominante()`,
`ForestR::biomassa_higuchi_corrigida()`), evitando duplicar metodologia já
validada.

---

## Instalação

```r
# a partir do GitHub, assim que publicado:
# install.packages("remotes")
remotes::install_github("scasttro7/EcoBiomasBR")

# em desenvolvimento local (clone do repositório):
devtools::load_all("EcoBiomasBR")
```

## Uso básico

```r
library(EcoBiomasBR)

# Listar equações disponíveis para um bioma (com referência bibliográfica)
listar_equacoes("caatinga")

# Estimar biomassa via dispatcher central
biomassa_bioma(dap = 15, bioma = "caatinga")
#> [1] 86.53176

# Equivalente em inglês
biomass_biome(dbh = 15, biome = "caatinga")

# Converter biomassa em carbono (fator IPCC 2006 = 0.47, padrão)
carbono_bioma(agb = 100)
#> [1] 47

# Sinalizar risco de saturação de sinal LiDAR (GEDI) em dossel fechado
saturacao_lidar(agb = 200)
#> [1] TRUE
```

## Módulos

| Módulo | Conteúdo |
|---|---|
| `registry.R` | `equation_registry` interno — tabela única de bioma × tipologia × faixa de DAP × referência, consultada pelo dispatcher e por `listar_equacoes()` |
| `validacao.R` | `validar_bioma()`, `validar_dap()`, `validar_altura()`, `validar_coordenadas()`, `validar_tipologia()` (+ aliases EN) |
| `biomassa.R` | Dispatcher `biomassa_bioma()` + implementação por bioma |
| `carbono.R` | Conversão biomassa → carbono, fator IPCC (2006) |
| `perturbacao.R` | Perturbação antrópica acumulada, reconciliação multi-fonte (MapBiomas × PRODES) |
| `clima.R` | Integração de variáveis climáticas (ERA5/Copernicus) |
| `sensoriamento.R` | GEDI (L2A/L2B/L4A), densidade de shots, saturação LiDAR, PALSAR-2/ALOS-4 |
| `bioma_dispatcher.R` | `classificar_bioma()` — identificação de bioma a partir de coordenadas/shapefile (IBGE) |

## Status por bioma (biomassa)

| Bioma | Status | Referência |
|---|---|---|
| Amazônia | ✅ Implementado (delega ao `ForestR`) | Higuchi et al. (1998); Nogueira et al. (2008); Baia et al. (2025) |
| Caatinga | ✅ Implementado e testado | Sampaio & Silva (2005) |
| Cerrado | ⏳ Stub — coeficientes pendentes | Rezende et al. (2006) |
| Mata Atlântica | ⏳ Stub — coeficientes pendentes | Miranda, Melo & Sanquetta (2011) |
| Pantanal | ⏳ Stub — coeficientes pendentes | Sallis et al. (2006) |
| Pampa | ⏳ Stub — modelo NDVI pendente de calibração | Rede PELD Campos Sulinos (UFSM/UFRGS) |

## Testes

```
tests/testthat/
├── test-validacao.R      (10 testes)
├── test-registry.R        (5 testes)
├── test-biomassa.R        (9 testes)
├── test-carbono.R         (6 testes)
├── test-sensoriamento.R   (6 testes)
└── test-dispatcher.R      (4 testes)
```

**40/40 testes passando** (validados via harness manual em ambiente sem
acesso ao CRAN; rodar `devtools::test()` para a verificação formal via
`testthat` assim que o pacote estiver instalado com as dependências).

## Roadmap

- [ ] Parametrizar coeficientes de Cerrado, Mata Atlântica e Pantanal a partir das fontes primárias
- [ ] Calibrar modelo NDVI → biomassa para o Pampa
- [ ] Implementar `limites_biomas` (shapefile IBGE) para `classificar_bioma()`
- [ ] Integração com Google Earth Engine (GEDI, MapBiomas, PRODES, ERA5)
- [ ] `R CMD check` completo via GitHub Actions
- [ ] Decisão de licença (adiada)

## Citação

Pacote em desenvolvimento; formato de citação (`CITATION`) a ser definido
antes da primeira release pública.

## Licença

A definir.
