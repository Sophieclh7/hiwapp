# ---- USER INTERFACE ----
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
     <dd>A bar chart displays values for different categories using a series of rectangular bars. Each bar represents an area, with its length corresponding to the value shown on the x-axis. When you hover over a bar, the specific value for that area is displayed. The chart updates dynamically based on the selected indicator, reflecting various outcomes. A dotted line indicates the Welsh average, allowing for comparison between this average and the values for individual areas.</dd>
       
        <dt><strong>Boxplot:</strong></dt>
        <dd><dd>A jittered box plot visualises the distribution of data through dots that represent individual areas. Each dot provides details about the specific area and its subdomain score when hovered over. The plot includes a box that shows the middle 50% of the data (the interquartile range), with whiskers extending to indicate the range of values, excluding extreme outliers. The dots are jittered to reduce overlap and make individual data points more distinguishable, helping you to see both the distribution and specific values clearly.</dd>

        
        <dt><strong>Composite score:</strong></dt>
        <dd>This is a single score made from combining several different....</dd>
        
        
        <dt><strong>Composite score chart:</strong></dt>
        <dd>This is a visual representation of combined scores.....</dd>
        
        
        <dt><strong>Domain:</strong></dt>
        <dd>The domain refers to the category or area being focused on in a study or analysis. For example, ' Healthy Lives' is a domain, and it contains 4 subdomains.</dd>
        
       
        <dt><strong>Interquartile range (IQR):</strong></dt>
        <dd>This measures the spread of the middle 50% of the data. It shows the range between the 25th and 75th percentiles, helping you see how concentrated or spread out the central part of the data is.</dd>
        
        
        <dt><strong>Jitterplot:</strong></dt>
        <dd>A jitterplot displays individual data points with a slight random shift to avoid overlap. It helps in visualising how data points are distributed without clustering.</dd>
        
        
        <dt><strong>LTLA (Lower Tier Authority Area):</strong></dt>
        <dd>This refers to a specific geographic region or administrative area, like a city or district, that local authorities manage. When you see 'area' in the charts, it represents these local regions where data is collected and analysed.</dd>
        
        
        <dt><strong>Mean:</strong></dt>
        <dd>The mean is the average value of a dataset, found by adding up all the values and dividing by the number of values.</dd>
        
        
        <dt><strong>Median:</strong></dt>
        <dd>The median is the middle value of a dataset when it’s arranged in order. Half the values are above the median, and half are below it.</dd>
        
       
        <dt><strong>Range:</strong></dt>
        <dd>The range is the difference between the highest and lowest values in a dataset. It shows how spread out the data is.</dd>
        
       
        <dt><strong>Scatterplot:</strong></dt>
        <dd>A scatterplot is a chart where data points are shown as dots on a graph. It helps to see if there is a pattern or relationship between two different variables, such as indicator score, subdomain score or healthy lives score within the wider domain.</dd>
        
       
        <dt><strong>Subdomain:</strong></dt>
        <dd>A subdomain is a smaller, more specific part of a larger domain. For example, within the domain of 'Healthy Lives,', an example of a domain is 'Behavioural Risk Factors' </dd>
        
        <dt><strong>Z-Score:</strong></dt>
       
        <dd>A Z-Score tells you how much a particular value is different from the average value. A Z-Score of 0 means the value is exactly average, while positive or negative scores show how much higher or lower it is compared to the average.The mean of the Z-Scores make up the composite score in this application</dd>
      </dl>
    "))
  )
}

# ---- SERVER FUNCTION ----
glossaryServer <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}
