Time Series Forecasting of Housing Prices
Overview
This project presents a comprehensive approach to forecasting housing prices using time series data. It demonstrates the application of both naive and sophisticated Recurrent Neural Network (RNN) models, specifically focusing on data pertaining to housing prices in Florida.

Data Description
The dataset used in this project includes historical housing prices for Florida, ranging from the year 2000 to 2024. The data is structured with dates and corresponding average home prices, which serve as the basis for our time series analysis.

Methodology
The analysis is carried out in several distinct steps:

Data Preparation
Data is initially cleaned, with dates converted to the appropriate datetime format.
The date column is set as the index for the time series data, allowing for more efficient operations and visualizations.
Null value checks ensure data integrity.
Visualization
A preliminary plot provides a visual understanding of the data's trend and seasonality over time.
Data Splitting
The dataset is split into training and test sets using an 80/20 ratio to validate the model's performance on unseen data.
Baseline Model (Naive Forecast)
A naive forecast serves as the baseline model, using the last known value as the prediction for the next time step.
Recurrent Neural Network (RNN) Model
A more advanced RNN model is built, leveraging the sequential nature of the data.
The RNN model is composed of several LSTM layers, designed to capture long-term dependencies in the data.
Training and Evaluation
Both models are trained on the dataset, and their predictions are evaluated against actual historical prices using standard metrics such as MAE, MSE, RMSE, MAPE, and MASE.
Comparison and Analysis
The performance of both models is compared, revealing insights into the complexity and capability of RNNs in capturing time series patterns versus simpler models.
Results
The analysis revealed that while the naive forecast performed with relative accuracy as per the simplicity of its assumption, the RNN model underperformed in comparison. This outcome serves as a stepping stone for further model improvements and tuning.
