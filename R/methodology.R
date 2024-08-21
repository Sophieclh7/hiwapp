methodologyUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Methodology: Health Index Wales - Healthy Lives"),
    HTML(paste0("
        <dl style='margin: 0; padding: 0;'>
        
        <dt style='font-size: 20px; margin-top: 30px; margin-bottom: 10px;'><strong>Step 1: Data collection</strong></dt>
        <dd style='margin-bottom: 30px;'>
          See metadata for data sources for each indicator: 
          <a href='https://github.com/Sophieclh7/health-index-wales/blob/main/metadata.md' target='_blank'>Metadata</a>
          <br>Data was collected for each indicator in the form of rates or percentages, age standardised where available.
        </dd>
        
        <dt style='font-size: 20px; margin-top: 30px; margin-bottom: 10px;'><strong>Step 2: Data standardization</strong></dt>
        <dd style='margin-bottom: 30px;'>
          For each indicator, z scores were calculated for each area.
          <br>Z scores are calculated as follows:
          <br>
          <div style='display: inline-block; text-align: center;'>
            <span style='display: block; margin-bottom: 2px;'>
              (data value for area - mean value for indicator)
            </span>
            <span style='display: block; border-top: 1px solid black;'>
              standard deviation for indicator
            </span>
          </div>
        </dd>
        
        <dt style='font-size: 20px; margin-top: 30px; margin-bottom: 10px;'><strong>Step 3: Score creation (indicators)</strong></dt>
        <dd style='margin-bottom: 30px;'>
          For each indicator, standardised scores were created so that the mean value for every indicator is 100.
          <br>The scores were calculated as follows:
          <br>
          (Z score x 10) + 100
          <br>
          Using these standardised scores, every 10 units above or below 100 corresponds to 1 standard deviation away from the mean.
          <br>
          For example, a score of 110 corresponds to 1 standard deviation higher than the mean, while a score of 90 corresponds to 1 standard deviation lower than the mean.
        </dd>
        
         <dt style='font-size: 20px; margin-top: 30px; margin-bottom: 10px;'><strong>Step 4: Score creation (subdomains)</strong></dt>
        <dd style='margin-bottom: 30px;'>
          Subdomain scores were created by taking the mean standardised scores from Step 3 of all the indicators in that subdomain
          <br>For example, for the Physiological Risk Factors subdomain, the subdomain score is the mean of the Step 3 scores for Low Birth Weight, Reception Overweight/Obesity and Adult Overweight/Obesity
        </dd>
        
        <dt style='font-size: 20px; margin-top: 30px; margin-bottom: 10px;'><strong>Step 5: Score creation (domain)</strong></dt>
        <dd style='margin-bottom: 30px;'>
          The score for the Healthy Lives domain was created by taking the mean standardised scores from Step 3 of all indicators
        </dd>
        
        </dl>
    "))
  )
}

# ---- SERVER FUNCTION ----
methodologyServer <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}
        
        
        
        
