load("data/hl_composite_score.rda")
library(dplyr)

hl_composite_score <- hl_composite_score |>
  rename(`Children & young people score` = `Children & young people composite score`,
         `Physiological risk factors score` = `Physiological risk factors composite score`,
         `Protective measures score` = `Protective measures composite score`)
# ---- Save output to data/ folder ----
usethis::use_data(hl_composite_score, overwrite = TRUE)
