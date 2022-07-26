
library(dplyr)
library(reactable)
library(reactablefmtr)

technology <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-07-19/technology.csv')

x <- 
technology |> 
  filter(
    iso3c == "MEX"
    & stringr::str_detect(label, "Electricity|electric energy")
  ) |> 
  select(!variable) |> 
  pivot_wider(
    names_from = label,
    values_from = value
  ) |> 
  select(-one_of("Electricity Generating Capacity, 1000 kilowatts", "iso3c",
                 "group", "category"
                 )) |> 
  filter(year >= 1995) |> 
  rename(Period = year) 

x |> 
  reactable(
    theme = nytimes(centered = TRUE, font_color = '#666666'),
   defaultColDef = colDef(format = colFormat(digits = 2)),
   highlight = TRUE,
   defaultPageSize = 18,
   columns = list(
     #`Gross output of electric energy (TWH)` = colDef(name = "Total production of energy")
     Period = colDef(format = colFormat(digits = 0), align = "left"),
     `Gross output of electric energy (TWH)` = colDef(
       align = 'left',
       minWidth = 250,
       cell = data_bars(
         data = x,
         fill_color = viridis::viridis(5),
         background = '#FFFFFF',
         bar_height = 4,
         number_fmt = scales::comma,
         text_position = 'outside-end',
         max_value = 400,
         icon = 'circle',
         #icon_color = '#226ab2',
         icon_size = 15,
         text_color = '#226ab2',
         round_edges = TRUE
       )
     ),
     `Electricity from oil (TWH)` = colDef(
       cell =  color_tiles(x, bias = 1.4, box_shadow = TRUE,
                           number_fmt = scales::comma)
     )
     
   )
  ) |> 
  add_title(
    title = reactablefmtr::html("Energy production in Mexico <img src='https://svgsilh.com/svg/146443.svg' alt='Bee' width='40' height='40'>"),
    margin = reactablefmtr::margin(t=0,r=0,b=3,l=0)
  ) |> 
  add_subtitle(
    subtitle = 'By power source. Values until 2020.',
    font_weight = 'normal',
    font_size = 20,
    margin = reactablefmtr::margin(t=0,r=0,b=6,l=0)
  ) |> 
  add_source("Table created by: Jorge Hernández with {reactablefmtr}", font_size = 12)



