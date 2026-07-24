# EcoBiomasBR (development version)

## EcoBiomasBR 0.1.0 (2026-07-22)

### 🌱 Nascimento do pacote

Primeira versão pública do EcoBiomasBR, um pacote R independente para
integração de equações alométricas e ferramentas voltadas à estimativa de
biomassa, carbono, perturbação antrópica, clima e sensoriamento remoto nos
seis biomas brasileiros (Amazônia, Cerrado, Mata Atlântica, Caatinga,
Pantanal e Pampa).

### Filosofia do pacote

O EcoBiomasBR foi concebido para disponibilizar infraestrutura computacional
reutilizável para análises ecológicas nos biomas brasileiros, priorizando
transparência metodológica, reprodutibilidade e integração com bases
oficiais.

### Adicionado

#### Funcionalidades implementadas

- **`equation_registry`** interno (`registry.R`): tabela única de bioma ×
  tipologia × faixa de DAP × referência bibliográfica, consultada pelo
  dispatcher central e por `listar_equacoes()`/`list_equations()`.
- **Módulo de validação** (`validacao.R`): `validar_bioma()`, `validar_dap()`,
  `validar_altura()`, `validar_coordenadas()`, `validar_tipologia()` — e
  respectivos aliases em inglês.
- **Dispatcher central de biomassa** `biomassa_bioma()` / `biomass_biome()`,
  delegando para a função específica de cada bioma.
- **Caatinga totalmente implementada**: `biomassa_caatinga()`/
  `biomass_caatinga()`, com as duas equações de Sampaio & Silva (2005) por
  faixa de DAP (3–30 cm e > 30 cm).
- **Amazônia implementada** via importação do `ForestR`
  (`ForestR::fator_correcao_altura_dominante()`,
  `ForestR::biomassa_higuchi_corrigida()`), evitando duplicar metodologia já
  validada no BIODATUM.
- **`carbono.R`**: `carbono_bioma()`/`carbon_biome()` com fator de conversão
  IPCC (2006) = 0.47 como padrão.
- **`sensoriamento.R`**: `saturacao_lidar()`/`lidar_saturation()`
  implementado e testado.
- Suíte de testes completa em `tests/testthat/` — **40 testes, todos
  passando** (validação, registry, dispatcher de biomassa, carbono,
  sensoriamento).
- README com badges, exemplos de uso, tabela de status por bioma e roadmap.

#### Estruturas preparadas para desenvolvimento

- **Cerrado, Mata Atlântica, Pantanal, Pampa**: funções esqueleto
  (`biomassa_cerrado()`, `biomassa_mata_atlantica()`, `biomassa_pantanal()`,
  `biomassa_pampa()`) com validação de entrada funcional, sinalizando
  explicitamente a pendência de parametrização final dos coeficientes.
- **`gedi_extrair()`**, **`densidade_shots()`**, **`palsar_integrar()`**
  (stubs em `sensoriamento.R`) aguardando integração com Google Earth
  Engine.
- **`perturbacao.R`** e **`clima.R`**: stubs com validação de argumentos,
  aguardando integração espacial (MapBiomas/PRODES, ERA5/Copernicus).
- **`bioma_dispatcher.R`**: `classificar_bioma()`/`classify_biome()` como
  stub, aguardando shapefile interno de limites IBGE.

### Notas de arquitetura

- Pacote **independente do ForestR** (que segue específico do projeto de
  tese BIODATUM), mas relacionado a ele via `Imports:` — decisão deliberada
  para permitir reutilização por qualquer pesquisador brasileiro, não só no
  contexto da tese.
- Funções expostas **bilíngue (PT/EN)** desde a primeira versão.
- Licença será definida antes da primeira versão estável (1.0.0).

### Próximos passos

- Cobertura completa dos seis biomas (parametrização final de Cerrado, Mata
  Atlântica, Pantanal e Pampa)
- Integração com Google Earth Engine (GEDI, MapBiomas, PRODES, ERA5)
- GitHub Actions (`R CMD check` automático a cada push)
- Documentação via `pkgdown`
- Submissão ao CRAN

---

*Esta é a primeira versão pública (0.1.0) e estabelece a arquitetura inicial
do pacote. As próximas versões priorizarão a expansão da cobertura dos
biomas e das integrações espaciais.*
