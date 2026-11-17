nse <- function(obs, sim){
  nse <- 1 - sum((obs - sim)^2) /sum((obs - mean(obs))^2)
  nse
}
