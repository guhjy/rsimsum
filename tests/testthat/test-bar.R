context("bar")
library(ggplot2)

test_that("bar checks arguments properly", {
  data("MIsim", package = "rsimsum")
  s1 <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method")
  expect_error(bar(obj = MIsim))
  expect_error(bar(obj = s1))
  expect_error(bar(obj = s1, sstat = "BIAS"))
  expect_error(bar(obj = s1, sstat = "nsim"))
  expect_error(bar(obj = s1, sstat = "bias", level = 101))
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", by = "fv_dist")
  expect_error(bar(obj = sm))
  expect_error(bar(obj = sm, sstat = "BIAS"))
  expect_warning(expect_error(bar(obj = sm, sstat = "nsim")))
  expect_error(bar(obj = sm, sstat = "bias", level = 101))
})

test_that("bar returns a ggplot object", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method")
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model")
  expect_s3_class(bar(s, sstat = "bias"), class = c("gg", "ggplot"))
  expect_s3_class(bar(sm, sstat = "bias"), class = c("gg", "ggplot"))
  expect_s3_class(bar(sm, sstat = "bias", par = "trt"), class = c("gg", "ggplot"))
})

test_that("bar does not plot CI when simsum in called with mcse = FALSE", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", mcse = FALSE)
  bar(s, sstat = "bias")
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", mcse = FALSE)
  bar(sm, sstat = "bias")
  bar(sm, sstat = "bias", par = "trt")
})

test_that("bar works with 'by' factors", {
  data("relhaz", package = "rsimsum")
  s <- simsum(data = relhaz, estvarname = "theta", true = -0.5, se = "se", methodvar = "model", by = c("n", "baseline"))
  expect_warning(bar(s, sstat = "bias"))
  expect_error(bar(s, sstat = "bias", by = "random-name"))
  expect_s3_class(bar(s, sstat = "bias", by = c("n", "baseline")), class = c("gg", "ggplot"))
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", by = "fv_dist")
  expect_warning(bar(sm, sstat = "bias", par = "trt"))
  expect_error(bar(sm, sstat = "bias", par = "trt", by = "random-name"))
  expect_s3_class(bar(sm, sstat = "bias", par = "trt", by = "fv_dist"), class = c("gg", "ggplot"))
  expect_warning(bar(sm, sstat = "bias"))
  expect_error(bar(sm, sstat = "bias", by = "random-name"))
  expect_s3_class(bar(sm, sstat = "bias", by = "fv_dist"), class = c("gg", "ggplot"))
})

test_that("bar works when changing graphical parameters", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method")
  bar(s, sstat = "bias", gpars = list(bar.colour = "yellow"))
  bar(s, sstat = "bias", gpars = list(bar.fill = "purple"))
  bar(s, sstat = "bias", gpars = list(target.shape = 1))
  bar(s, sstat = "bias", gpars = list(target.colour = 2))
  bar(s, sstat = "bias", gpars = list(width = 0.5))
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model")
  bar(sm, sstat = "bias", par = "trt", gpars = list(bar.colour = "yellow"))
  bar(sm, sstat = "bias", par = "trt", gpars = list(bar.fill = "purple"))
  bar(sm, sstat = "bias", par = "trt", gpars = list(target.shape = 1))
  bar(sm, sstat = "bias", par = "trt", gpars = list(target.colour = 2))
  bar(sm, sstat = "bias", par = "trt", gpars = list(width = 0.5))
  bar(sm, sstat = "bias", gpars = list(target.shape = 1))
  bar(sm, sstat = "bias", gpars = list(target.colour = 2))
  bar(sm, sstat = "bias", gpars = list(width = 0.5))
})

test_that("bar with all 'sstat' options, with and without 'target'", {
  data("MIsim", package = "rsimsum")
  s <- simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method")
  bar(s, sstat = "nsim", target = 1000)
  bar(s, sstat = "thetamean")
  bar(s, sstat = "thetamean", target = 0.50)
  bar(s, sstat = "thetamedian")
  bar(s, sstat = "thetamedian", target = 0.50)
  bar(s, sstat = "se2mean")
  bar(s, sstat = "se2mean", target = 0)
  bar(s, sstat = "se2median")
  bar(s, sstat = "se2median", target = 0)
  bar(s, sstat = "bias")
  bar(s, sstat = "bias", target = 0)
  bar(s, sstat = "empse")
  bar(s, sstat = "empse", target = 0)
  bar(s, sstat = "mse")
  bar(s, sstat = "mse", target = 0)
  bar(s, sstat = "relprec")
  bar(s, sstat = "relprec", target = 1)
  bar(s, sstat = "modelse")
  bar(s, sstat = "modelse", target = 0)
  bar(s, sstat = "relerror")
  bar(s, sstat = "relerror", target = 0)
  bar(s, sstat = "cover")
  bar(s, sstat = "cover", target = 0.95)
  bar(s, sstat = "bccover")
  bar(s, sstat = "bccover", target = 0.95)
  bar(s, sstat = "power")
  bar(s, sstat = "power", target = 0.95)
  data("frailty", package = "rsimsum")
  sm <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50, fv = 0.75), estvarname = "b", se = "se", methodvar = "model", by = "fv_dist")
  bar(sm, par = "trt", by = "fv_dist", sstat = "nsim", target = 1000)
  bar(sm, par = "trt", by = "fv_dist", sstat = "thetamean")
  bar(sm, par = "trt", by = "fv_dist", sstat = "thetamean", target = -0.50)
  bar(sm, par = "trt", by = "fv_dist", sstat = "thetamedian")
  bar(sm, par = "trt", by = "fv_dist", sstat = "thetamedian", target = -0.50)
  bar(sm, par = "trt", by = "fv_dist", sstat = "se2mean")
  bar(sm, par = "trt", by = "fv_dist", sstat = "se2mean", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "se2median")
  bar(sm, par = "trt", by = "fv_dist", sstat = "se2median", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "bias")
  bar(sm, par = "trt", by = "fv_dist", sstat = "bias", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "empse")
  bar(sm, par = "trt", by = "fv_dist", sstat = "empse", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "mse")
  bar(sm, par = "trt", by = "fv_dist", sstat = "mse", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "relprec")
  bar(sm, par = "trt", by = "fv_dist", sstat = "relprec", target = 1)
  bar(sm, par = "trt", by = "fv_dist", sstat = "modelse")
  bar(sm, par = "trt", by = "fv_dist", sstat = "modelse", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "relerror")
  bar(sm, par = "trt", by = "fv_dist", sstat = "relerror", target = 0)
  bar(sm, par = "trt", by = "fv_dist", sstat = "cover")
  bar(sm, par = "trt", by = "fv_dist", sstat = "cover", target = 0.95)
  bar(sm, par = "trt", by = "fv_dist", sstat = "bccover")
  bar(sm, par = "trt", by = "fv_dist", sstat = "bccover", target = 0.95)
  bar(sm, par = "trt", by = "fv_dist", sstat = "power")
  bar(sm, par = "trt", by = "fv_dist", sstat = "power", target = 0.95)
  bar(sm, by = "fv_dist", sstat = "nsim", target = 1000)
  bar(sm, by = "fv_dist", sstat = "thetamean")
  bar(sm, by = "fv_dist", sstat = "thetamean", target = -0.50)
  bar(sm, by = "fv_dist", sstat = "thetamedian")
  bar(sm, by = "fv_dist", sstat = "thetamedian", target = -0.50)
  bar(sm, by = "fv_dist", sstat = "se2mean")
  bar(sm, by = "fv_dist", sstat = "se2mean", target = 0)
  bar(sm, by = "fv_dist", sstat = "se2median")
  bar(sm, by = "fv_dist", sstat = "se2median", target = 0)
  bar(sm, by = "fv_dist", sstat = "bias")
  bar(sm, by = "fv_dist", sstat = "bias", target = 0)
  bar(sm, by = "fv_dist", sstat = "empse")
  bar(sm, by = "fv_dist", sstat = "empse", target = 0)
  bar(sm, by = "fv_dist", sstat = "mse")
  bar(sm, by = "fv_dist", sstat = "mse", target = 0)
  bar(sm, by = "fv_dist", sstat = "relprec")
  bar(sm, by = "fv_dist", sstat = "relprec", target = 1)
  bar(sm, by = "fv_dist", sstat = "modelse")
  bar(sm, by = "fv_dist", sstat = "modelse", target = 0)
  bar(sm, by = "fv_dist", sstat = "relerror")
  bar(sm, by = "fv_dist", sstat = "relerror", target = 0)
  bar(sm, by = "fv_dist", sstat = "cover")
  bar(sm, by = "fv_dist", sstat = "cover", target = 0.95)
  bar(sm, by = "fv_dist", sstat = "bccover")
  bar(sm, by = "fv_dist", sstat = "bccover", target = 0.95)
  bar(sm, by = "fv_dist", sstat = "power")
  bar(sm, by = "fv_dist", sstat = "power", target = 0.95)
})
