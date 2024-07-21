# Load necessary libraries
library(readr)
library(randomForest)
library(ggplot2)
library(reshape2)

data <- read_csv("2024bible_less_leading.csv")

head(data)

data$date <- NULL  # Excluding date column for simplicity

cat("Number of rows in data: ", nrow(data), "\n")
cat("Number of columns in data: ", ncol(data), "\n")

formula <- spyclose3day ~ spyopen + spyhigh + spylow + spyclose + spyvolume + polarity + subjectivity +
  goldopen + goldhigh + goldlow + goldclose + goldvolume + oilopen + oilhigh + oillow + 
  oilclose + oilvolume + m2_supply + fed_assets

model <- randomForest(formula, data = data, importance = TRUE)

print(model)

model_stats <- capture.output({
  print(model)
  cat("\nVariable Importance:\n")
  print(importance(model))
  cat("\nR-squared:\n")
  print(model$rsq)
  cat("\nMean Squared Error (MSE):\n")
  print(model$mse)
})

writeLines(model_stats, "model_summary.txt")

varImpPlot(model)

r_squared_values <- sapply(names(data)[-which(names(data) == "spyclose3day")], function(var) {
  lm_formula <- as.formula(paste("spyclose3day ~", var))
  lm_model <- lm(lm_formula, data = data)
  summary(lm_model)$r.squared
})

cat("R-squared values for each input variable:\n")
print(r_squared_values)

capture.output(cat("R-squared values for each input variable:\n"), print(r_squared_values), file = "model_summary.txt", append = TRUE)

cor_matrix <- cor(data[, -which(names(data) == "spyclose3day")])
melted_cor_matrix <- melt(cor_matrix)

make_prediction <- function(spyopen, spyhigh, spylow, spyclose, spyvolume, polarity, subjectivity,
                            goldopen, goldhigh, goldlow, goldclose, goldvolume, oilopen, oilhigh, 
                            oillow, oilclose, oilvolume, m2_supply, fed_assets) {
  
  new_data <- data.frame(spyopen = spyopen, spyhigh = spyhigh, spylow = spylow, spyclose = spyclose,
                         spyvolume = spyvolume, polarity = polarity, subjectivity = subjectivity,
                         goldopen = goldopen, goldhigh = goldhigh, goldlow = goldlow, goldclose = goldclose,
                         goldvolume = goldvolume, oilopen = oilopen, oilhigh = oilhigh, oillow = oillow,
                         oilclose = oilclose, oilvolume = oilvolume, m2_supply = m2_supply, 
                         fed_assets = fed_assets)
  
  prediction <- predict(model, newdata = new_data)
  return(prediction)
}

#Manually input new values for prediction:
new_prediction <- make_prediction(spyopen = 544.33, spyhigh = 546.95, spylow = 542.62, spyclose = 542.74,
                                  spyvolume = 45499000, polarity = 0.047765494227994226, subjectivity = 0.20884218975468977,
                                  goldopen = 2323.30, goldhigh = 2332.90, goldlow = 2322.7, goldclose = 2330,
                                  goldvolume = 76, oilopen = 80.45, oilhigh = 81.78, oillow = 80.23, 
                                  oilclose = 81.63, oilvolume = 290500, m2_supply = 20961, 
                                  fed_assets = 7252542)

# Print the prediction
cat("Predicted spyclose3day:", new_prediction, "\n")
                                  