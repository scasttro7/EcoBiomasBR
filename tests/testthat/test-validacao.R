test_that("validar_bioma aceita biomas validos e normaliza", {
  expect_equal(validar_bioma("Amazonia"), "amazonia")
  expect_equal(validar_bioma("mata atlantica"), "mata_atlantica")
  expect_equal(validar_bioma("MATA_ATLANTICA"), "mata_atlantica")
})

test_that("validar_bioma rejeita biomas invalidos", {
  expect_error(validar_bioma("savana_africana"), "nao reconhecido")
  expect_error(validar_bioma(""), "obrigatorio")
  expect_error(validar_bioma(NA), "obrigatorio")
})

test_that("validate_biome (EN) delega para validar_bioma", {
  expect_equal(validate_biome("cerrado"), "cerrado")
})

test_that("validar_dap rejeita valores invalidos", {
  expect_error(validar_dap("dez"), "numerico")
  expect_error(validar_dap(-5), "positivo")
  expect_error(validar_dap(c(10, NA)), "NA")
})

test_that("validar_dap emite warning fora da faixa de validade", {
  expect_warning(validar_dap(2, dap_min = 3), "abaixo da faixa")
  expect_warning(validar_dap(50, dap_max = 30), "acima da faixa")
  expect_silent(validar_dap(15, dap_min = 3, dap_max = 30))
})

test_that("validar_altura exige altura quando necessario", {
  expect_error(validar_altura(NULL, exige_altura = TRUE), "exige 'altura'")
  expect_silent(validar_altura(NULL, exige_altura = FALSE))
  expect_error(validar_altura(-2, exige_altura = TRUE), "positivo")
})

test_that("validar_coordenadas rejeita valores fora do intervalo", {
  expect_error(validar_coordenadas(200, -60), "-90 e 90")
  expect_error(validar_coordenadas(-10, 400), "-180 e 180")
})

test_that("validar_coordenadas avisa quando fora do Brasil aproximado", {
  expect_warning(validar_coordenadas(45, 2), "territorio brasileiro")
})

test_that("validar_tipologia exige tipologia quando o bioma tem subdivisao", {
  expect_error(validar_tipologia(NULL, "amazonia"), "requer o argumento 'tipologia'")
  expect_equal(validar_tipologia("terra_firme", "amazonia"), "terra_firme")
  expect_error(validar_tipologia("tipologia_inexistente", "amazonia"), "invalida")
})

test_that("validar_tipologia retorna NA para biomas sem subdivisao", {
  expect_true(is.na(validar_tipologia(NULL, "cerrado")))
})
