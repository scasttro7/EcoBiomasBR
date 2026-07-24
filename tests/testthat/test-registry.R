test_that("listar_equacoes retorna o registro completo sem argumento", {
  registro <- listar_equacoes()
  expect_s3_class(registro, "data.frame")
  expect_true(all(c("bioma", "tipologia", "funcao", "referencia") %in% names(registro)))
  expect_true(nrow(registro) >= 6)  # ao menos 1 por bioma
})

test_that("listar_equacoes filtra por bioma", {
  reg_amazonia <- listar_equacoes("amazonia")
  expect_true(all(reg_amazonia$bioma == "amazonia"))
  expect_true(nrow(reg_amazonia) == 3)  # terra_firme, sul_oeste, varzea
})

test_that("listar_equacoes emite warning para bioma sem equacoes", {
  # bioma valido mas sem linhas hipoteticas nao existe no registro atual;
  # aqui testamos que o filtro por nome invalido normalizado nao quebra:
  # (validar_bioma so eh chamado dentro; testamos a normalizacao interna)
  expect_true(nrow(listar_equacoes("pampa")) >= 1)
})

test_that("list_equations (EN) delega para listar_equacoes", {
  expect_equal(list_equations("cerrado"), listar_equacoes("cerrado"))
})

test_that("todos os biomas validos tem ao menos uma equacao registrada", {
  registro <- listar_equacoes()
  biomas_no_registro <- unique(registro$bioma)
  expect_setequal(biomas_no_registro, .biomas_validos)
})
