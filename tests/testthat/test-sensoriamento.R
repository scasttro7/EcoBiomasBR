test_that("saturacao_lidar sinaliza corretamente acima/abaixo do limiar", {
  expect_true(saturacao_lidar(200))
  expect_false(saturacao_lidar(100))
  expect_equal(saturacao_lidar(c(100, 200), limiar = 150), c(FALSE, TRUE))
})

test_that("saturacao_lidar rejeita entrada invalida", {
  expect_error(saturacao_lidar("alto"), "numerico")
  expect_error(saturacao_lidar(NA), "NA")
})

test_that("lidar_saturation (EN) delega para saturacao_lidar", {
  expect_equal(lidar_saturation(200), saturacao_lidar(200))
})

test_that("gedi_extrair valida o argumento produto", {
  expect_error(gedi_extrair(poligono = NULL, produto = "L9A"), "subconjunto de")
})

test_that("gedi_extrair sinaliza integracao pendente para produto valido", {
  expect_error(gedi_extrair(poligono = NULL, produto = "L4A"), "Google Earth Engine")
})

test_that("palsar_integrar sinaliza pendencia tecnica", {
  expect_error(palsar_integrar(poligono = NULL), "PALSAR")
})
