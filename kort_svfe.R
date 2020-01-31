library(sf)
library(dplyr)
library(ggplot2)
library(here)

# Innlestur ---------------------------------------------------------------
# Gögn sótt hér: 
#https://gatt.lmi.is/geonetwork/srv/eng/catalog.search#/metadata/A1919501-BA1F-4AEE-ABB8-00A3217258AA

stadsetning <- here::here("data",
                          "lmi_kort",
                          "IS50V_MORK_SHP",
                          "is50v_mork_sveitarf_svaedi_24122018.shp")

kort_sf <- sf::read_sf(dsn = stadsetning)

# Plottað án litar
kort_sf %>%
  st_transform(crs = 4258) %>% 
  ggplot(aes()) +
  geom_sf()


# Plottum upp liti á sveitarfélag út frá random tölum ---------------------

set.seed(1) # Upp á random number generator

kort_sf %>% 
  mutate(random_breyta = rnorm(n = 72, mean = 0, sd = 50)) %>% 
  st_transform(crs = 4258) %>% 
  ggplot(aes(fill = random_breyta)) +
  geom_sf() +
  scale_fill_viridis_c()


# Fyrir raunveruleg gögn þyrftum við að joina út frá sveitarfelagi --------

gagnarammi <- tibble(svfe = kort_sf$NRSVEITARF,
                     random_breyta = rnorm(n = 72, mean = 0, sd = 50))


kort_sf %>% 
  left_join(gagnarammi, by = c("NRSVEITARF" = "svfe")) %>%
  st_transform(crs = 4258) %>% 
  ggplot(aes(fill = random_breyta)) +
  geom_sf() +
  scale_fill_viridis_c()
  

