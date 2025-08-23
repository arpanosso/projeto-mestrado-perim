#'Função para leitura dos arquivos nc4 da SIF do OCO2 e OCO3
get_oco2_sif <- function(file_path){
  nc_file <- ncdf4::nc_open(file_path)
  df <- data.frame(
    "time"=ncdf4::ncvar_get(nc_file,varid="Delta_Time"),
    "sza"=ncdf4::ncvar_get(nc_file,varid="SZA"),
    "vza"=ncdf4::ncvar_get(nc_file,varid="VZA"),
    "saz"=ncdf4::ncvar_get(nc_file,varid="SAz"),
    "vaz"=ncdf4::ncvar_get(nc_file,varid="VAz"),
    "longitude"=ncdf4::ncvar_get(nc_file,varid="Longitude"),
    "latitude"=ncdf4::ncvar_get(nc_file,varid="Latitude"),
    # "longitude_corners"=ncdf4::ncvar_get(nc_file,varid="Longitude_Corners"),
    # "latitude_corners"=ncdf4::ncvar_get(nc_file,varid="Latitude_Corners"),
    "sif740"=ncdf4::ncvar_get(nc_file,varid="SIF_740nm"),
    "sif740_uncertainty"=ncdf4::ncvar_get(nc_file,varid="SIF_Uncertainty_740nm"),
    "daily_sif740"=ncdf4::ncvar_get(nc_file,varid="Daily_SIF_740nm"),
    "daily_sif757"=ncdf4::ncvar_get(nc_file,varid="Daily_SIF_757nm"),
    "daily_sif771"=ncdf4::ncvar_get(nc_file,varid="Daily_SIF_771nm"),
    "quality_flag"=ncdf4::ncvar_get(nc_file,varid="Quality_Flag"),
    "path" = file_path
  )
  df <- df |>
    dplyr::filter(latitude >= -35 & latitude <= 5,
                  longitude >= -75 & longitude <= -34)
  ncdf4::nc_close(nc_file)
  return(df)
}

#'Função para leitura dos arquivos nc4 da XCO2 do OCO2 e OCO3
get_oco2_xco2 <- function(file_path){
  nc_file <- ncdf4::nc_open(file_path)
  df <- data.frame(
    "longitude"=ncdf4::ncvar_get(nc_file,varid="longitude"),
    "latitude"=ncdf4::ncvar_get(nc_file,varid="latitude"),
    "time"=ncdf4::ncvar_get(nc_file,varid="time"),
    "xco2"=ncdf4::ncvar_get(nc_file,varid="xco2"),
    "xco2_quality_flag"=ncdf4::ncvar_get(nc_file,varid="xco2_quality_flag"),
    "xco2_incerteza"=ncdf4::ncvar_get(nc_file,varid="xco2_uncertainty"),
    # "fs"=ncdf4::ncvar_get(nc_file,varid="Retrieval/fs"),
    # "fs_rel"=ncdf4::ncvar_get(nc_file,varid="Retrieval/fs_rel"),
    "path" = file_path
  )
  df <- df |>
    dplyr::filter(latitude >= -35 & latitude <= 5,
                  longitude >= -75 & longitude <= -34)
  ncdf4::nc_close(nc_file)
  return(df)
}
