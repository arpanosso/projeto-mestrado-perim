
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
| [data-set-xco2.rds](https://drive.google.com/file/d/1E6oYKw7WyBRcgLaiFlPP1-ZTXTG4QO-2/view?usp=sharing) ⬇️ |
| [data-set-sif.rds](https://drive.google.com/file/d/1Tvy4T2O3YwY9sQwvHnDD3sZWkoqvwZbw/view?usp=sharing) ⬇️ |
| [faxina-de-dados.R](https://raw.githubusercontent.com/arpanosso/projeto-mestrado-perim/refs/heads/master/data-raw/faxina-de-dados.R) |

Formato dos arquivos:

> .rds (formato nativo do R para carregamento rápido)

> salve os arquivos na pasta `data` do projeto

### 🧹 Faxina de dados

#### Carregando os polígonos do Brasil

``` r
country_br <- geobr::read_country(showProgress = FALSE)
```

#### Carregando os dados

``` r
data_set_xco2 <- readr::read_rds("data/data-set-xco2.rds") |> 
  dplyr::mutate(
    time = lubridate::as_datetime(time, tz = "America/Sao_Paulo"),
    year = lubridate::year(time),
    month = lubridate::month(time),
    day = lubridate::day(time),
  )
dplyr::glimpse(data_set_xco2)
#> Rows: 14,113,963
#> Columns: 10
#> $ longitude         <dbl> -42.82634, -42.83171, -42.83667, -42.84213, -42.8476…
#> $ latitude          <dbl> -22.90563, -22.91458, -22.89448, -22.90340, -22.9122…
#> $ time              <dttm> 2020-01-01 13:41:10, 2020-01-01 13:41:10, 2020-01-0…
#> $ xco2              <dbl> 411.1394, 408.3469, 408.4254, 409.1369, 409.6229, 40…
#> $ xco2_quality_flag <int> 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0…
#> $ xco2_incerteza    <dbl> 0.3705117, 0.3717737, 0.3879336, 0.4135483, 0.360514…
#> $ path              <chr> "data-raw/2020/OCO2/oco2_LtCO2_200101_B11210Ar_24091…
#> $ year              <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020…
#> $ month             <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ day               <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
```

``` r
data_set_sif <- readr::read_rds("data/data-set-sif-filter.rds")
dplyr::glimpse(data_set_sif)
#> Rows: 2,755,525
#> Columns: 17
#> $ time               <dttm> 2020-01-02 14:27:47, 2020-01-02 14:27:58, 2020-01-…
#> $ sza                <dbl> 24.21838, 24.43658, 25.21167, 25.22522, 25.20837, 2…
#> $ vza                <dbl> 18.96948, 19.25812, 19.79761, 19.75006, 19.91901, 1…
#> $ saz                <dbl> 240.8419, 239.6188, 235.9193, 235.8642, 235.9224, 2…
#> $ vaz                <dbl> 61.69757, 59.83484, 56.50873, 56.77283, 55.88147, 5…
#> $ longitude          <dbl> -58.04297, -58.18042, -58.59381, -58.59863, -58.597…
#> $ latitude           <dbl> -12.287109, -11.691345, -9.810913, -9.781616, -9.81…
#> $ sif740             <dbl> 1.68288898, 2.33085060, 3.39827824, 3.13973331, 1.7…
#> $ sif740_uncertainty <dbl> 0.6398249, 0.5907574, 0.5819044, 0.6214972, 0.57474…
#> $ daily_sif740       <dbl> 0.60762787, 0.83928204, 1.21343613, 1.12081718, 0.6…
#> $ daily_sif757       <dbl> 0.43646145, 0.56351566, 0.39550304, 0.42863560, 0.3…
#> $ daily_sif771       <dbl> 0.24913883, 0.37035179, 0.81494141, 0.71052551, 0.3…
#> $ quality_flag       <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
#> $ path               <chr> "data-raw/2020/OCO2 SIF/oco2_LtSIF_200102_B11012Ar_…
#> $ year               <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 202…
#> $ month              <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ day                <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, …
```
