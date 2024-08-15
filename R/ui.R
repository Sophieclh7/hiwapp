ui <- fluidPage(
  h1("Health inequalities explorer Wales", style = "text-align: center; ; border-bottom: 2px solid #000; padding-bottom: 10px;"),
  h2("The health inequalities explorer app allows users to compare the health of different counties in Wales. For more information on how health scores are calculated, see health index methods below", style = "font-size: 20px;"),
  compJitterUI("compJitterModule"),
  h2("Subdomain scores"),
  h3(HTML("
  Subdomains were created to group indicators. The subdomains are:<br><br>
  <strong>Behavioural risk factors:</strong><br>
  Indicators: Alcohol misuse, drug misuse, healthy eating, sedentary behaviour, physical activity, smoking<br><br>
  <strong>Childhood development:</strong><br>
  Indicators: Early years development, pupil absences, pupil attainment, teenage pregnancy, education employment apprenticeship<br><br>
  <strong>Physiological risk factors:</strong><br>
  Indicators: Low birth weight, reception overweight/obese, adult overweight/obese<br><br>
  <strong>Protective measures:</strong><br>
  Indicators: Bowel, breast and cervical cancer screenings, child vaccination coverage
"), style = "font-size: 14px;"), 
  boxplotUI("boxplotModule"),
  compositechartUI("compositechartModule"),
  h2("Indicator scores"),
  h3("The chart displays the raw counts for each indicator", style = "font-size: 16px;"),
  barchartUI("barchartModule")
)