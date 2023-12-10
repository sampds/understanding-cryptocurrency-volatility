# Cryptocurrency Market Analysis: Volatility and Predictive Modeling

## Description

This project, centered around the fluctuating value of cryptocurrencies, afforded me a deep dive into the complexities of financial data and predictive modeling. This was my first group project in the program and required extensive collaboration with my teammates in IST 687, Applied Data Science.

### Motivation

To understand factors affecting cryptocurrency prices, explore correlations between different cryptocurrencies, and develop predictive models for price movements.

## Problems Addressed

Data needed extensive cleaning and transforming for use in SVMs.

### Learning Experience

- Regularly aligning with my teammates to refine the scope of our project and divide up the work was critical to our success. Sharing our code and offering insight to each other when we ran into issues was helpful in putting together a working script and building our models.
- Tranforming data for modeling is challenging but rewarding, and requires creativity as well as technical prowess.

## Impact and Results

- The analysis revealed strong correlations between Bitcoin and other cryptocurrencies, although some like EOS showed independent trends.
- The SVM models were particularly effective in predicting high-volatility days, with some models achieving over 90% accuracy as measured by confusion matrices.

## Installation

To set up the development environment, follow these steps:

1. Clone the repository to your local machine.
2. Install the libraries using the script. For specifics about versions and dependencies, see the requirements.txt file.
3. Ensure your version of R is compatible with the libraries. The last time I ran the script, I used R version 4.3.2 (2023-10-31 ucrt) -- "Eye Holes"
4. Change the filepaths of datasets to match your machine's filepaths.

## Usage

### Data Acquisition and Cleaning 

Data acquired via Kaggle from a user who pulled data from the CoinMarketCap API. The data is processed using R. This involved cleaning, transforming, and aggregating the data for analysis.

### Descriptive Statistics and Correlation Analysis

We examined the relationships between different cryptocurrencies, particularly the correlation between Bitcoin and altcoins.

### Predictive Modeling 

We utilized support-vector machines (SVMs) to predict cryptocurrency price movements. The focus was on identifying days with high volatility (over 5% daily returns).

## Future Development

I am interested in pulling API data on a recurring basis from CoinMarketCap as well as other sources to explore variables to use for new models.

## Credits

Developed with Clifford Huang and Glory Onyeugbo in IST 687, Applied Data Science.