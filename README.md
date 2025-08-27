
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Projeto Mestrado - Rodrigo Perim

## 👨‍🔬 Autores

- **Rodrigo Baratiere Perim**  
  Mestrando em Agronomia (Ciência do Solo) - FCAV/Unesp  
  Email: [odrigo.perim@unesp.br](mailto:rodrigo.perim@unesp.br)

- **Prof. Dr. Alan Rodrigo Panosso**  
  Coorientador — Departamento de Ciências Exatas - FCAV/Unesp  
  Email: <alan.panosso@unesp.br>

## 📁 Etapas do Projeto

### ⬇️ Aquisição dos dados brutos

- **Aquisição e download dos dados brutos** [OCO-2 e
  OCO-3](https://disc.gsfc.nasa.gov):

### 🔗 Links para Download dos dados compilados:

| Dados Processados Para Download |
|:--:|
| [data-set-xco2-br.rds](https://drive.google.com/file/d/1iq97nQyR-kKMEygV6C-2OsKE41mIkLF5/view?usp=sharing) ⬇️ |
| [data-set-sif-br.rds](https://drive.google.com/file/d/1XgJXuvN8OmcmblG8TEgys_KSHkEIf9QO/view?usp=sharing) ⬇️ |
| [faxina-de-dados.R](https://raw.githubusercontent.com/arpanosso/projeto-mestrado-perim/refs/heads/master/data-raw/faxina-de-dados.R) |

Formato dos arquivos:

> .rds (formato nativo do R para carregamento rápido)

> salve os arquivos na pasta `data` do projeto

### 🧹 Faxina de dados

#### Carregando o polígono do Brasil

``` r
country_br <- geobr::read_country(showProgress = FALSE)
```

#### Carregando os dados

``` r
data_set_xco2 <- readr::read_rds("data/data-set-xco2.rds") |> 
  dplyr::filter(
    longitude >=-59.7700 & longitude <= -49.8361,
    latitude >=-12.3561 & latitude <= -1.6058
  ) |> 
  dplyr::mutate(
    time = lubridate::as_datetime(time, tz = "America/Sao_Paulo"),
    year = lubridate::year(time),
    month = lubridate::month(time),
    day = lubridate::day(time),
  ) 
dplyr::glimpse(data_set_xco2)
readr::write_rds(data_set_xco2,"data/data-set-xco2-filter.rds")
```

``` r
data_set_sif <- readr::read_rds("data/data-set-sif.rds") |> 
  dplyr::filter(
    longitude >=-59.7700 & longitude <= -49.8361,
    latitude >=-12.3561 & latitude <= -1.6058
  ) |>  
  dplyr::mutate(
    time = lubridate::as_datetime(time, 
                                  origin = "1990-01-01 00:00:00",
                                  tz = "America/Sao_Paulo"),
    year = lubridate::year(time),
    month = lubridate::month(time),
    day = lubridate::day(time),
  )
dplyr::glimpse(data_set_sif)
readr::write_rds(data_set_sif,"data/data-set-sif-filter.rds")
```

``` r
country_br |> 
  ggplot2::ggplot()+
  ggplot2::geom_sf(fill = "lightgray", color = "black") +
  ggplot2::geom_point(data = data_set_xco2 |> 
                        dplyr::filter(year==2020),
                      ggplot2::aes(longitude, latitude),
                      size=.3,color="red") +
  # ajusta os limites do mapa
  ggplot2::coord_sf(xlim = c(-72, -48), ylim = c(-15, 0)) +
  ggplot2::labs(title = "XCO2")
```

``` r
country_br |> 
  ggplot2::ggplot()+
  ggplot2::geom_sf(fill = "lightgray", color = "black") +
  ggplot2::geom_point(data = data_set_sif |> 
                        dplyr::filter(year==2020),
                      ggplot2::aes(longitude, latitude),
                      size=.3,color="blue") +
  # ajusta os limites do mapa
  ggplot2::coord_sf(xlim = c(-72, -48), ylim = c(-15, 0))+
  ggplot2::labs(title = "SIF")
```

## Filtrando os dados para Br

``` r
regiao <- geobr::read_region(showProgress = FALSE)
pol_norte <- regiao$geom |> purrr::pluck(1) |> as.matrix()
pol_nordeste <- regiao$geom |> purrr::pluck(2) |> as.matrix()
pol_sudeste <- regiao$geom |> purrr::pluck(3) |> as.matrix()
pol_sul <- regiao$geom |> purrr::pluck(4) |> as.matrix()
pol_centroeste<- regiao$geom |> purrr::pluck(5) |> as.matrix()

pol_nordeste <- pol_nordeste[pol_nordeste[,1]<=-34,]
pol_nordeste <- pol_nordeste[!((pol_nordeste[,1]>=-38.7 & pol_nordeste[,1]<=-38.6) & pol_nordeste[,2]<= -15),]

pol_nordeste <- pol_nordeste[pol_nordeste[,1]<=-34,]
pol_nordeste <- pol_nordeste[!((pol_nordeste[,1]>=-38.7 & pol_nordeste[,1]<=-38.6) & pol_nordeste[,2]<= -15),]
```

``` r
def_pol <- function(x, y, pol){
  as.logical(sp::point.in.polygon(point.x = x,
                                  point.y = y,
                                  pol.x = pol[,1],
                                  pol.y = pol[,2]))
}
```

``` r
# data_set_xco2 <- readr::read_rds("data/data-set-xco2.rds") |> 
#   dplyr::mutate(
#     time = lubridate::as_datetime(time, tz = "America/Sao_Paulo"),
#     year = lubridate::year(time),
#     month = lubridate::month(time),
#     day = lubridate::day(time),
#   ) 
# dplyr::glimpse(data_set_xco2)
```

``` r
# data_set_xco2_br <- data_set_xco2 |>
#   dplyr::mutate(
#     flag_norte = def_pol(longitude, latitude, pol_norte),
#     flag_nordeste = def_pol(longitude, latitude, pol_nordeste),
#     flag_sul = def_pol(longitude, latitude, pol_sul),
#     flag_centroeste = def_pol(longitude, latitude, pol_centroeste),
#     flag_suldeste = def_pol(longitude, latitude, pol_sudeste),
#   )
# readr::write_rds(data_set_xco2_br,"data/data-set-xco2-br.rds")
```

``` r
# country_br |>
#   ggplot2::ggplot() +
#   ggplot2::geom_sf(fill="white", color="#FEBF57",
#                    size=.15, show.legend = FALSE) +
#   ggplot2::geom_point(data= data_set_xco2_br |>
#                         dplyr::sample_n(1000) |>
#                         dplyr::filter(flag_nordeste) ,
#                       ggplot2::aes(x=longitude,y=latitude),
#                       shape=3,
#                       col="red",
#                       alpha=0.2)
dff <- readr::read_rds("data/data-set-xco2-br.rds") |> 
  dplyr::mutate(
    country = flag_nordeste|flag_norte|flag_suldeste|
      flag_sul|flag_centroeste
  )

source("r/my_functions.R")

dff |>
  dplyr::filter(
    country
  ) |> 
  dplyr::sample_n(10000) |> 
  ggplot2::ggplot(ggplot2::aes(longitude,latitude)) +
  ggplot2::geom_point()

# Classificando pontos
data_set <- dff
state <- 0
x <- data_set |> dplyr::pull(longitude)
y <- data_set |> dplyr::pull(latitude)
for(i in 1:nrow(data_set)) state[i] <- get_geobr_state(x[i],y[i])
data_set <- data_set |> cbind(state)
dplyr::glimpse(data_set)

# readr::write_rds(data_set,"../data/oco2-sif.rds")
```

``` r
# data_set_sif <- readr::read_rds("data/data-set-sif.rds") |> 
#   dplyr::mutate(
#     time = lubridate::as_datetime(time, 
#                                   origin = "1990-01-01 00:00:00",
#                                   tz = "America/Sao_Paulo"),
#     year = lubridate::year(time),
#     month = lubridate::month(time),
#     day = lubridate::day(time),
#   )
# dplyr::glimpse(data_set_sif)
```

``` r
# data_set_sif_br <- data_set_sif |>
#   dplyr::mutate(
#     flag_norte = def_pol(longitude, latitude, pol_norte),
#     flag_nordeste = def_pol(longitude, latitude, pol_nordeste),
#     flag_sul = def_pol(longitude, latitude, pol_sul),
#     flag_centroeste = def_pol(longitude, latitude, pol_centroeste),
#     flag_suldeste = def_pol(longitude, latitude, pol_sudeste),
#   )
# readr::write_rds(data_set_sif_br,"data/data-set-sif-br.rds")
```

``` r
# country_br |>
#   ggplot2::ggplot() +
#   ggplot2::geom_sf(fill="white", color="#FEBF57",
#                    size=.15, show.legend = FALSE) +
#   ggplot2::geom_point(data= data_set_sif_br |>
#                         dplyr::sample_n(1000) |>
#                         dplyr::filter(flag_nordeste) ,
#                       ggplot2::aes(x=longitude,y=latitude),
#                       shape=3,
#                       col="red",
#                       alpha=0.2)
# 
# # Classificando pontos
# data_set <- dff
# state <- 0
# x <- data_set |> dplyr::pull(longitude)
# y <- data_set |> dplyr::pull(latitude)
# for(i in 1:nrow(data_set)) state[i] <- get_geobr_state(x[i],y[i])
# data_set <- data_set |> cbind(state)
# dplyr::glimpse(data_set)
# readr::write_rds(data_set,"../data/oco2-sif.rds")
```
