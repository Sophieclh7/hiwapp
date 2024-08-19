# ---- USER INRTERFACE ----
glossaryUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Glossary"),
    h3("Terms and Definitions"),
    p("Here you can find definitions and explanations for various terms used in the application. This section will help you better understand the data and metrics presented."),
    HTML(paste0("
      <h4>Glossary:</h4>
      <dl>
        <dt><strong>Bar chart:</strong></dt>
        <dd>A bar chart uses bars to show the size of different values. Each bar’s length represents a quantity, making it easy to compare different categories.</dd>
        
        <dt><strong>Composite score:</strong></dt>
        <dd>This is a single score made from combining several different measurements. For example, combining scores from different health tests to get an overall health score.</dd>
        
        <dt><strong>Composite score chart:</strong></dt>
        <dd>This is a visual representation of combined scores from different sources. It shows how different measurements add up to give an overall score.</dd>
        
        <dt><strong>Domain:</strong></dt>
        <dd>The domain is the set of all possible input values for a function or analysis. In health data, it could mean the range of ages or conditions being studied.</dd>
        
        <dt><strong>Interquartile range (IQR):</strong></dt>
        <dd>This measures the spread of the middle 50% of the data. It shows the range between the 25th and 75th percentiles, helping you see how concentrated or spread out the central part of the data is.</dd>
        
        <dt><strong>Jitterplot:</strong></dt>
        <dd>A jitterplot displays individual data points with a slight random shift to avoid overlap. It helps in visualizing how data points are distributed without clustering.</dd>
        
        <dt><strong>LTLA (Local Authority Area):</strong></dt>
        <dd>This refers to a specific geographic region or administrative area, like a city or district, that local authorities manage. When you see 'area' in the charts, it represents these local regions where data is collected and analyzed.</dd>
        
        <dt><strong>Mean:</strong></dt>
        <dd>The mean is the average value of a dataset, found by adding up all the values and dividing by the number of values.</dd>
        
        <dt><strong>Median:</strong></dt>
        <dd>The median is the middle value of a dataset when it’s arranged in order. Half the values are above the median, and half are below it.</dd>
        
        <dt><strong>Range:</strong></dt>
        <dd>The range is the difference between the highest and lowest values in a dataset. It shows how spread out the data is.</dd>
        
        <dt><strong>Subdomain:</strong></dt>
        <dd>A subdomain is a smaller, more specific part of a larger domain. For example, within a domain of 'health conditions,' a subdomain might be 'cardiovascular diseases.'</dd>
        
        <dt><strong>Z score:</strong></dt>
        <dd>A Z score tells you how much a particular value is different from the average value. A Z score of 0 means the value is exactly average, while positive or negative scores show how much higher or lower it is compared to the average.</dd>
      </dl>
    "))
  )
}
# ---- SERVER FUNCTION ----
glossaryServer <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}