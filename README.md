<p style="color:blue;font-size:2px;">This is demo text</p> 

# COVID-19 Prediction Tool

Central to the debate of ethical algorithm design is a consideration of mis-classification costs for supervised learning methods. By building in asymmetric costs through sampling, machine learning engineers can take heed of policy makers’ desired cost-ratios. This random forest algorithm takes asymmetric sampling into account when predicting death rates of coronavirus patients in South Korea using the Kaggle COVID-19 Open Research Dataset.

## Table of Contents

<p align="center">
<img src="https://github.com/katjanewilson/CORD-Random-Forest/blob/master/images/covid.png"
  alt="Size Limit comment in pull request about bundle size changes"
  width="300" height="100">
</p>


[GitHub action]: https://github.com/andresz1/size-limit-action
[cult-img]:      http://cultofmartians.com/assets/badges/badge.svg
[cult]:          http://cultofmartians.com/tasks/size-limit-config.html

## Data

* [CORD research data set](https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge)

## Cleaning Notes
The original dataset contained 2119 entries of patients and 18 variables. Multiple variables contained missing values. The sex variable included 230 missing values. In order to keep the information that would be lost if list wise deletion were employed, I coded these values as “absent”. Likewise, I recode the order variable with 4, the most common present order, if missing. For variables missing the age, values of 25 were imputed in missing values, since 25 was the most frequently observed age, and the provided variable does not give insight into the distribution of ages between decades. After this recoding, 2 variables remained missing from the outcome of interest, the State 3 variable. Looking into these two variables, both their State 2 values were “Lived”, so I recode State 3 to released for these two observations. Limitations to this approach of recoding are that the values imputed could stray from the true values of these variables, and that something explaining the missingness could contribute to the outcomes for these observations.
In choosing the predictors for the final model, the birth year variable, which is already captured in the age variable is left out of the model. Additionally, the country variable, which only 12 values are from outside Korea is left out of the analysis data set, since, with such a small number outside of Korea, no cases may end up being sampled in the random forest. Likewise, dates of infection and symptom onset, with no knowledge of how the data were collected could be subject to much bias, and these are left out. The final random forest model includes the predictors Order, Sex, Province, Age, and confirmed date.

## Packages

* [Random Forest](https://cran.r-project.org/web/packages/randomForest/randomForest.pdf)

## How It Works

1. Various cost ratios of false negatives to false positives were applied to the stratified sampling procedure with replacement. Because there is a large imbalance in outcome distribution (less than 2% of individuals die from the disease), then it is difficult to arrive at fully sensible cost ratios through the sampling method. The intent is to make a false negative death 20 more costly than a false positive.

2. With resampling, the algorithms' forecasting accuracy is improved upon previously stated forecasts at baseline made without such a tool. The intent is to make a false negative death 10 times as
costly, and the confusion table shows a larger ratio at 20 to 1, achieved due to the high number of people isolated, and under-sampling from this parameter.
3. The classification accuracy on the right side of the table shows that the random forest gets those who die classified correctly greater than 80% of the time, so a majority of these rare events are classified
correctly. The forecasting accuracy, on the other hand, depends on the cost ratio. A forecast of deceased is correct 19% of the time. That may seem small, but it is a jump from our previous ability to forecast the deceased at 1.5%. Another way to look at this would be that we avoided the worst type of forecasting error, which would be to forecast someone who died as being released. Likewise, our ability to forecast the isolated and released raise to 92% and 53%, respectively, and both are improvements from baseline. This has the other effect of increasing the number of false positives of those who are forecasted to die, which was a tradeoff accepted by policy makers and stakeholders, whose previous forecasts, without an algorithm, did not take cost benefits into account.

## Evaluation

<p align="center">
<img src="https://github.com/katjanewilson/CORD-Random-Forest/blob/master/images/confusion_table1.png"
  alt="Size Limit comment in pull request about bundle size changes"
  width="400" height="200">
</p>


<p align="center">
<img src="https://github.com/katjanewilson/CORD-Random-Forest/blob/master/images/confusion_table2.png"
  alt="Size Limit comment in pull request about bundle size changes"
  width="400" height="200">
</p>



## Margins
Random forest algorithms aggregate the votes across trees for each outcome class in the spirit of bootstrap aggregation. When the vote percentages are large one way or the other, then the algorithm is classifying with high reliability (it may not be accurate, but it is reliable). However, when the vote percentages are nearly identical, little reliability is present in the outcome class. The maximum
proportion of times that a case is classified correctly, and a maximum proportion of times it is classified incorrectly, are compared to find the margin. The larger the margin, the more confident the classification.
Figure 4.2 maps the margin for a deceased classification onto a histogram. A majority of the classifications have margins greater than 0.5. Very few are close to the 0.0 mark, and these that are sway towards the negative direction. Five votes in total were classified incorrectly, and two of these with reliability over 0.5. The margin here is lopsided in favor of the correct class, so despite the noise introduced by bagging resampling, most of the time the cases are classified correctly, and the classification is highly reliable in the valid (right) direction for the death outcome.
Since the purpose of our tool is for forecasting, then the stakeholders are most likely interested in the forecasting error, which show when projections are likely to be correct. In the same vein, looking at the margins for the other two outcomes (released and isolated), the distributions are less strongly skewed in the same way that the distribution for the outcome of death was. The algorithm is less reliable in these forecasts, which, as mentioned, is complemented by the forecasting accuracy. Since there is no line in the sand way to determine reliability, then again decision makers should be the ones to also decide on how decisive a vote should be for classification in respective outcomes.

Limitations of the analysis include omitted variables. One can imagine many other possible variables as predictive of the outcome that were not collected in the dataset at hand. Additionally, the random forest cannot be extended to forecasts beyond the data at hand, since the data is not IID.
Perhaps the biggest point of pause, however, is the very high cost ratio that was achieved in the outcome of deceased and isolated (Table 3). Although the policy makers asked for a high cost ratio since doctors are hoping to save as many lives as possible, this may change in the future as more and more individuals enter the hospital, and less resources are available. As resources become more scarce, then the costs of a false positive (classifying someone as high risk who actually can just be isolated) may become costlier, and the stakeholders will actually prefer to take on more false negatives in this category. In this case, the parameters can be re-sampled at different rates to achieve the desired cost ratio.
The task was to improve upon decisions that were already being made by doctors and nurses who received COVID-19 cases in the ER. Despite the difficulty in obtaining the exact cost ratios that were requested by policy officials, the model provides forecasts that are superior to baseline practice. Additionally, the model accounts for the cost ratios that were requested by policy makers, which prior baseline practices did not take into account. Such a tool could be used in conjunction with the expertise of doctors and nurses in the field for allocating COVID-19 patients proper resources.
