context("classif_cforest")

test_that("classif_cforest", {
  library(party)
  parset.list = list(
    list(),
    list(control = cforest_unbiased(mtry = 2)),
    list(control = cforest_unbiased(ntree = 200))
  )
  parset.list2 = list(
    list(),
    list(mtry = 2),
    list(ntree = 200)
  )
  
  old.predicts.list = list()
  old.probs.list = list()
  
  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    pars = list(binaryclass.formula, data = binaryclass.train)
    pars = c(pars, parset)
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(cforest, pars)
    old.predicts.list[[i]] = predict(m, newdata = binaryclass.test)
    p = predict(m, newdata = binaryclass.test, type = 'prob')
    old.probs.list[[i]] = sapply(p, '[', 1)
  }
  
  testSimpleParsets("classif.cforest", binaryclass.df, binaryclass.target, binaryclass.train.inds,
                    old.predicts.list, parset.list2)
  testProbParsets ("classif.cforest", binaryclass.df, binaryclass.target, binaryclass.train.inds,
                   old.probs.list, parset.list2)
})