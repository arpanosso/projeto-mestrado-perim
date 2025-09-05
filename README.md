
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
source("R/my_functions.R")
country_br <- geobr::read_country(showProgress = FALSE)
```

#### Carregando os dados

Primeira Versão do Banco de dados, muito grande, pois os dados foram
baixados para o mundo todo. Código abaixo cria um recorte a partir das
coordenadas ondem está situao o Brasil, além disso são construídas as
variávies de data, e salva uma nova versão dos dados.

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

## Filtrando os dados para Br

Para filtar os dados para o território brasileiro, algumas correções dos
polígonos do IBGE são necessárias, e realizadas abaixo. O filtro é
realizado por região.

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

# XCO2

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

## Agora precisamos definir as regiões e estados

``` r
country_br |>
  ggplot2::ggplot() +
  ggplot2::geom_sf(fill="white", color="#FEBF57",
                   size=.15, show.legend = FALSE) +
  ggplot2::geom_point(data= dff |>
                        dplyr::filter(
                          country
                        ) |> 
                        dplyr::sample_n(15000),
                      ggplot2::aes(x=longitude,y=latitude))
```

``` r
dff <- readr::read_rds("data/data-set-xco2-br.rds") |> 
  dplyr::filter(!((latitude > -22.5 & latitude < -20) & 
                  (longitude > -40)) ) |> 
  dplyr::mutate(
    country = flag_nordeste|flag_norte|flag_suldeste|
      flag_sul|flag_centroeste
  )

dff |>
  dplyr::filter(
    country
  ) |> 
  dplyr::sample_n(30000) |> 
  ggplot2::ggplot(ggplot2::aes(longitude,latitude)) +
  ggplot2::geom_point() # +
  # ggplot2::coord_cartesian(xlim = c(-45,-35),ylim = c(-25,-15))
```

``` r
municipality <- geobr::read_municipality()

get_centroide <- function(df,coord){
  pol_aux <- df |> purrr::pluck(1) |> as.matrix()
  x <- mean(pol_aux[,1])
  y <- mean(pol_aux[,2])
  if(coord == "x") return(x)
  if(coord == "y") return(y)
}

municipality_df <- municipality |> 
  dplyr::group_by(abbrev_state,name_muni) |> 
  dplyr::mutate(
    lon_centroide = get_centroide(geom,"x"),
    lat_centroide = get_centroide(geom,"y"),
  ) |> 
  dplyr::ungroup() 

get_geobr_state_muni <- function(x1,y1,df){
  df_aux <- df |>
    dplyr::filter(
      lon_centroide >= round(x1,1)-.10, lon_centroide <= round(x1,1)+.5,
      lat_centroide >= round(y1,1)-.10, lat_centroide <= round(y1,1)+.5,
    ) |> 
    dplyr::mutate(distancia = sqrt((x1-lon_centroide)^2+(y1-lat_centroide)^2)) 
  if(nrow(df_aux) == 0){
    return("Other_Other")
  }else{
    list_pol <- purrr::map(1:nrow(df_aux), ~{
      df_aux$geom |> purrr::pluck(.x) |> as.matrix()
    })
    
    for(i in 1:nrow(df_aux)){
      if(def_pol(x1, y1, list_pol[[i]])) {
        index <- i
        break
      }
    }
    
    if(i == nrow(df_aux)){return("Other")
    }else{
      name_muni <- df_aux |>
        dplyr::slice(index) |> dplyr::pull(name_muni)
      abbrev_state <- df_aux |>
        dplyr::slice(index) |> dplyr::pull(abbrev_state)
      return(paste0(name_muni,"_",abbrev_state))
    }
  }
  return(df_aux)
};get_geobr_state_muni(-73.57131,-6.98122,municipality_df)
```

``` r
40/10000*2650000/60/60
# Classificando pontos
tictoc::tic()
dff_sm <- dff |> 
  dplyr::filter(
    country,
    xco2_quality_flag == 0,
  ) |> 
  dplyr::sample_n(10000) |> 
  dplyr::group_by(longitude,latitude) |> 
  dplyr::mutate(
    muni_state = get_geobr_state_muni(longitude,latitude,municipality_df)
  ) |> 
  dplyr::ungroup()
tictoc::toc()
# readr::write_rds(dff_sm,"data/data-set-xco2-state-muni.rds")
```

# SIF

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

``` r
dff <- readr::read_rds("data/data-set-sif-br.rds") |> 
  dplyr::filter(!((latitude > -22.5 & latitude < -20) & 
                  (longitude > -40)),
                (quality_flag ==0 | quality_flag == 1)) |> 
  dplyr::mutate(
    country = flag_nordeste|flag_norte|flag_suldeste|
      flag_sul|flag_centroeste
  )

dff |>
  dplyr::filter(
    country
  ) |> 
  dplyr::sample_n(30000) |> 
  ggplot2::ggplot(ggplot2::aes(longitude,latitude)) +
  ggplot2::geom_point() # +
  # ggplot2::coord_cartesian(xlim = c(-45,-35),ylim = c(-25,-15))

# Classificando pontos
# data_set <- dff
# state <- 0
# x <- data_set |> dplyr::pull(longitude)
# y <- data_set |> dplyr::pull(latitude)
# for(i in 1:nrow(data_set)) state[i] <- get_geobr_state(x[i],y[i])
# data_set <- data_set |> cbind(state)
# dplyr::glimpse(data_set)
# readr::write_rds(data_set,"../data/oco2-sif.rds")
```

``` r
# Classificando pontos
dff_sm <- dff |> dplyr::slice(1:10) |> 
  dplyr::filter(
    country,
  ) |> 
  dplyr::group_by(longitude,latitude) |> 
  dplyr::mutate(
    muni_state = get_geobr_state_muni(longitude,latitude,municipality_df)
  ) 
readr::write_rds(dff_sm,"data/data-set-sif-state-muni.rds")
```
