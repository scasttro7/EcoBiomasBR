test_that("biomassa_caatinga aplica a equacao correta por faixa de DAP", {
  # DAP <= 30: B(kg) = 0.1730 * DAP^2.2950
  b <- biomassa_caatinga(dap = 15)
  esperado <- 0.1730 * 15^2.2950
  expect_equal(b, esperado, tolerance = 1e-6)
})

test_that("biomassa_caatinga exige altura e densidade da madeira para DAP > 30", {
  # DAP > 30: B(kg) = 0.1648 * (AAP x H x rho)^0.9023
  expect_error(biomassa_caatinga(dap = 35), "altura, densidade_madeira")
  b <- biomassa_caatinga(dap = 35, altura = 8, densidade_madeira = 0.7)
  aap_esperado <- (pi / 4) * 35^2
  esperado <- 0.1648 * (aap_esperado * 8 * 0.7)^0.9023
  expect_equal(b, esperado, tolerance = 1e-6)
})

test_that("biomassa_caatinga rejeita DAP invalido", {
  expect_error(biomassa_caatinga(dap = -5), "positivo")
})

test_that("biomass_caatinga (EN) delega corretamente", {
  b_pt <- biomassa_caatinga(dap = 15)
  b_en <- biomass_caatinga(dbh = 15)
  expect_equal(b_pt, b_en)
})

test_that("biomassa_bioma dispatcher chama a funcao certa para caatinga", {
  b_dispatcher <- biomassa_bioma(dap = 15, bioma = "caatinga")
  b_direto <- biomassa_caatinga(dap = 15)
  expect_equal(b_dispatcher, b_direto)
})

test_that("biomassa_bioma rejeita bioma invalido", {
  expect_error(biomassa_bioma(dap = 10, bioma = "savana_africana"), "nao reconhecido")
})

test_that("biomassa_amazonia requer altura e delega ao ForestR (sem ForestR instalado -> erro informativo)", {
  skip_if(requireNamespace("ForestR", quietly = TRUE),
          "ForestR esta instalado; teste de ausencia nao aplicavel neste ambiente.")
  expect_error(biomassa_amazonia(dap = 25, altura = 18), "ForestR")
})

test_that("biomassa_pantanal e biomassa_cerrado sinalizam pendencia de coeficientes", {
  expect_error(biomassa_pantanal(dap = 20, altura = 10), "pendentes de parametrizacao")
  expect_error(biomassa_cerrado(dap = 20, altura = 10), "pendentes de parametrizacao")
})

test_that("biomassa_pampa exige ndvi ou cobertura conforme metodo", {
  expect_error(biomassa_pampa(metodo = "ndvi"), "requer o argumento 'ndvi'")
  expect_error(biomassa_pampa(metodo = "campo"), "requer o argumento 'cobertura'")
  expect_error(biomassa_pampa(metodo = "invalido"), "'ndvi' ou 'campo'")
})
