
healthIndexMethodsUI <- function(id) {
  ns <- NS(id)
  div(id = ns("method_info"), style = "display: none;",  # Ensure it's hidden by default
      p("The health index score is calculated by adding the z scores for healthy lives indicators for each LTLA."),
      p("Z-scores are standardized scores that indicate how many standard deviations an element is from the mean of the data. This standardization enables the comparison of data on different scales."),
      p("The indicators are:"),
      p("Alcohol_misuse - Age standardised alcohol-specific death rate per 100,000."),
      p("Breast_Cancer_Screening  - Percentage of eligible women screened for breast cancer."),
      p("Bowel_Cancer_Screening - Percentage of adults (aged 58-74) who attended bowel cancer screening within six months of invitation."),
      p("Cervical_Cancer_Screening - Percentage of women (aged 25-64) who received an adequate cervical cancer screening."),
      p("Diphteria_vaccination - Percentage of children immunised against Diphteria by their second birthday."),
      p("Drug_misuse - Drug poisoning related deaths per 1,000 people."),
      p("Early_years_development - Percentage of 7-year-olds achieving expected level in all four areas of foundation phase tests."),
      p("Education_employment_apprenticeship  - Post-16 Education and Training participation rate for under 20 year olds."),
      p("Healthy_eating - Percentage of adults (16+) eating >5 portions of fruit and vegetables the previous day."),
      p("Hib_vaccination - Percentage of children immunised against Hib by their second birthday."),
      p("MMR_vaccination - Percentage of children immunised against MMR by their second birthday."),
      p("Polio_vaccination - Percentage of children immunised against polio by their second birthday."),
      p("Literacy_score - Average GCSE English Language score."),
      p("Numeracy_score - Average GCSE Mathematics score."),
      p("Reception_overweight_obese - Percentage of overweight and obese children aged 4-5."),
      p("Teenage_pregnancy - Percentage of conceptions for women aged 15-17."),
      p("Tetanus_vaccination - Percentage of children immunised against tetanus by their second birthday."),
      p("Whooping_cough_vaccination - Percentage of children who received the whooping cough vaccine.")
  )
}