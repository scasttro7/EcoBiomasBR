test_that("classificar_bioma valida coordenadas antes de sinalizar pendencia", {
  expect_error(classificar_bioma(200, -60), "-90 e 90")
  expect_error(classificar_bioma(-3, -60), "limites_biomas")
})

test_that("classify_biome (EN) delega para classificar_bioma", {
  expect_error(classify_biome(-3, -60), "limites_biomas")
})

test_that("perturbacao_area valida fonte e periodo", {
  expect_error(perturbacao_area(NULL, 2020, 2010, fonte = "mapbiomas"), "ano_fim")
  expect_error(perturbacao_area(NULL, 2000, 2020, fonte = "fonte_invalida"), "mapbiomas")
})

test_that("clima_variavel valida variavel e periodo", {
  expect_error(clima_variavel(NULL, "vento", c("2000-01-01", "2020-01-01")), "temperatura, precipitacao, spei")
  expect_error(clima_variavel(NULL, "temperatura", "2000-01-01"), "tamanho 2")
})
