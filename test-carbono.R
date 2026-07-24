test_that("carbono_bioma aplica fator IPCC padrao 0.47", {
  expect_equal(carbono_bioma(100), 47)
})

test_that("carbono_bioma aceita fator customizado", {
  expect_equal(carbono_bioma(100, fator = 0.5), 50)
})

test_that("carbono_bioma rejeita AGB invalido", {
  expect_error(carbono_bioma(-10), "nao-negativo")
  expect_error(carbono_bioma(NA), "nao-negativo|NA")
})

test_that("carbono_bioma rejeita fator fora do intervalo (0,1)", {
  expect_error(carbono_bioma(100, fator = 1.5), "entre 0 e 1")
  expect_error(carbono_bioma(100, fator = 0), "entre 0 e 1")
})

test_that("carbon_biome (EN) delega para carbono_bioma", {
  expect_equal(carbon_biome(100), carbono_bioma(100))
})

test_that("carbono_potencial sinaliza pendencia", {
  expect_error(carbono_potencial("cerrado"), "pendentes de levantamento")
})
