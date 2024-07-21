# S&P 500 (SPY) 3-day close price prediction model via Random Forest Regression

## Motivation:
The purpose of this github repository is to demonstrate a random forest model which predicts the S&P 500 ETF ticker "SPY" 3-day out close price. This is in part made possible by using historical data and training the model on the actual closing price of the ETF in 3 days time, along with data from a given day. 

This was an interesting and helpful learning project as I learned to deploy and use in concert various operating systems and Python packages. As an example, the random forest model is implemented in RStudio Server, running within Windows Subshell for Linux (WSL), on PC running Windows 11 Home. The rstudio server is accessed via a web browser (Firefox).

## Model:
The predictors for the SPY 3-day closing price are: `spyopen, spyhigh, spylow, spyclose, spyvolume, polarity, subjectivity, goldopen, goldhigh, goldlow, goldclose, goldvolume, oilopen, oilhigh, oillow, oilclose, oilvolume, m2_supply, fed_assets`. Most of these predictors are self-explanatory. `polarity` and `subjectivity` are measures of the polarity and subjectivity of the given date's headlines, as scraped and generated from custom Python scripts which make use of a news feed API, and the `textblob` and `spacy` packages for natural language processing. The Python scripts include "fetch_write_headlines_v3.py", "news_headlines_cleaner.py", and "sentinment_analysis.py". 

The news API script "fetch_write_headlines_v3.py" pulls all news articles found with the given keyword "economy". These headlines are written to an output text file `news_headlines_{date}.txt`. A second script "news_headlines_cleaner.py" corrects issues caused by utf-8 encoding (unusual or unexpected symbols) and produces a .csv file with the cleaned healines. Finally, "sentinment_analysis.py" operates on this cleaned headlines .csv to perform natural language processing on the headlines and generate the subjectivity and polarity ratings for each. These are then averaged together to give an aggregate subjectivity and polarity rating for that date. Polarity is a float from -1.0 to 1.0 which reflects the positive (1.0) neutral (0.0), or negative (-1.0) nature of the headline along a continuous manner (non-discrete). Positive sentiments indicate "good news" regarding matters of the economy, et cetera. Subjectivity is a measure of how subjective a statement the news headline was taken to be (float from 0.0 to 1.0), with 0 being very subjective and 1.0 being very objective a headline. 

The averaged polarity and subjectivity ratings are entered into the primary/main .csv containing the training data. Other predictors are looked up from disparate sources and keyed in manually into this primary .csv, as are the polarity and subjectivity. A flow chart has been created to better describe the workflow:

## Flowchart for Python scripts, input and output files:
![Screenshot 2024-07-21 130022](https://github.com/user-attachments/assets/63b20d2f-8d95-4af1-845c-b90a69354984)

The variable to be predicted is `spy_3day_close.` The formula in R is: `formula <- spyclose3day ~ spyopen + spyhigh + spylow + spyclose + spyvolume + polarity + subjectivity +
  goldopen + goldhigh + goldlow + goldclose + goldvolume + oilopen + oilhigh + oillow + 
  oilclose + oilvolume + m2_supply + fed_assets`

## rstudio-server screenshot showing R script and new input predictor values:

![rstudio_server](https://github.com/user-attachments/assets/648ed06d-f4a7-4be7-a2e2-685b51ca9cbc)

## Model Output:
Running the R script produces a **prediction for the SPY 3 day close price ($542.48 at the time of this writing)** and summary data:

## Summary Data:
![summary](https://github.com/user-attachments/assets/ba1ea1d8-7693-427c-a55a-d06d840a4a2b)

## Relative Importance of Features:
![fig1](https://github.com/user-attachments/assets/4cfb5b09-1c56-4e47-b327-af6b3c0226a4)

The percent increase in mean squared error (`%IncMSE`) and increase in node purity (`IncNodePurity`) are measures of the importance of each predictor in the modelling of the response variable. Regarding the percent increase in mean squared error, higher numbers indicate greater importance in accurately modelling the response variable, as that predictor's permutation causes larger increases in the mean squared error of the overall model. Similarly with increase in node purity, higher values indicate greater importance in predicting the response. We therefore can look at the relative importance of each input variable in predicting the response. Some values are unsuprising, e.g., that `spyhigh` is very important for predicting the closing price in 3 days. Interestingly the federal reserve assets are "more important" for predicting the closing 3 day price than the SPY low price, according to the percent increase in mean squared error metric (not the case however for this predictor but the increase in node purity value). The predictors `spyhigh, spyclose, spyopen, spylow, fed_assets, goldlow, and m2_supply` seem to be separated from the rest of the variables on the IncNodePurity graph, and one could potentially make the case that such predictors are carried forward into a new model, while dropping the others. 

This prediction system would (with near certainty) be more appropriate for predicting the price of a single commodity such as soy, wheat, et cetera. However, this was a learning exercise and the "SPY" ticker was chosen for learning purpose, with particular emphasis on whether the news headlines tagged with the word "economy" could be used to predict the 3-day closing price. This seems to not be the case. 

## Concluding Remarks:
In this exercise, I learned how to make use of Rstudio server, R scripts, Python scripts, and Python packages to build a random forest model to predict the 3-day closing price of the S&P 500 ETF "SPY", given data from the current day's date. After training, one can input current data to get a prediction for the closing price of the S&P in 3 days time. The model takes as input the closing price of the ticker, so must be run after market close on a given day (4pm ET).

