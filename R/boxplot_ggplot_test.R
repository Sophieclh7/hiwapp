load("data/hl_composite_score.rda")
sum(hl_composite_score$`Composite score`)

long_data <- hl_composite_score |>
  pivot_longer(
    cols = c("Behavioural risk composite score", 
             "Children & young people composite score",
             "Physiological risk factors composite score",
             "Protective measures composite score"),
    names_to = "ScoreType",
    values_to = "ScoreValue"
  )
ggplot(long_data, aes(x = ScoreType, y = ScoreValue)) +
  geom_boxplot() +
  theme_minimal() +
  labs(x = "Score Type", y = "Score Value", title = "Boxplots of Composite Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
