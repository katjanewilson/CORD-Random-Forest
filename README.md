# COVID-19 Prediction Tool

Central to the debate of ethical algorithm design is a consideration of mis-classification costs for supervised learning methods. By building in asymmetric costs through sampling, machine learning engineers can take heed of policy makers’ desired cost-ratios. This random forest algorithm takes asymmetric sampling into account when predicting death rates of coronavirus patients in South Korea using the Kaggle COVID-19 Open Research Dataset.

## Table of Contents

<p align="center">
<img src="https://github.com/katjanewilson/CORD-Random-Forest/blob/master/images/covid.png"
  alt="Size Limit comment in pull request about bundle size changes"
  width="686" height="289">
</p>


[GitHub action]: https://github.com/andresz1/size-limit-action
[cult-img]:      http://cultofmartians.com/assets/badges/badge.svg
[cult]:          http://cultofmartians.com/tasks/size-limit-config.html

## Data

* [CORD research data set](https://www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge)

Open data on Kaggle includes over 2000 observations of individuals in South Korea who attended the hospital for COVID-19 from late 2019 to early 2020.
Arguments could theoretically be made both ways on the independence of the data. On one hand, the virus affects people randomly, since it is highly contagious. More than that, the strain of the coronavirus is relatively the same. These assumptions would back up an assertion that the data is IID. On the other hand, arguments for the data not being IID point to the fact that those who are infected may infect other people in the same sample, given that they are in the same location or the same hospital. Additionally, the data at hand is not from a joint probability distribution. Instead, it is Korea’s tested population, which, while substantial, has selection bias. It is not possible to know how the tested population systematically differs from the Korean population at large, so the stronger assumption here is that the data is not IID.
In order to go to a Level 2 analysis, IID data is necessary. However, random forests provide one way to proceed. Random forests address the nature of the data through sampling with replacement, random sampling of predictors, and the algorithm provides built in test data through the OOB data. Since the randomness is built into the random forest algorithm by design, then randomness is a great tool and allows us to get test data automatically. However, the confusion table only gives a sense of how well the random forest would perform at forecasting outcomes in new data. It wouldn’t necessarily operate the same for new data that were not selected IID from the same joint probability distribution as the analytic sample. As noted before, it is a big assumption to make that the sample at hand represents the infected
1
population of all of Korea, and thus using the prediction error and confusion table to forecast at triage would be specious and inappropriate. Making the previous lofty and unwarranted assumption would be the only way to generalize our findings to a broader population. Since the data are not IID, the resulting tree has limitations in that it could only be used to forecast patients’ unknown outcomes when the future patient data are IID realizations from the same population that produced the training and test data.

The original dataset contained 2119 entries of patients and 18 variables. Multiple variables contained missing values. The sex variable included 230 missing values. In order to keep the information that would be lost if list wise deletion were employed, I coded these values as “absent”. Likewise, I recode the order variable with 4, the most common present order, if missing. For variables missing the age, values of 25 were imputed in missing values, since 25 was the most frequently observed age, and the provided variable does not give insight into the distribution of ages between decades. After this recoding, 2 variables remained missing from the outcome of interest, the State 3 variable. Looking into these two variables, both their State 2 values were “Lived”, so I recode State 3 to released for these two observations. Limitations to this approach of recoding are that the values imputed could stray from the true values of these variables, and that something explaining the missingness could contribute to the outcomes for these observations.
In choosing the predictors for the final model, the birth year variable, which is already captured in the age variable is left out of the model. Additionally, the country variable, which only 12 values are from outside Korea is left out of the analysis data set, since, with such a small number outside of Korea, no cases may end up being sampled in the random forest. Likewise, dates of infection and symptom onset, with no knowledge of how the data were collected could be subject to much bias, and these are left out. The final random forest model includes the predictors Order, Sex, Province, Age, and confirmed date.

## Packages

* [Random Forest](https://cran.r-project.org/web/packages/randomForest/randomForest.pdf)


## How It Works

1. Step1
2. Step 2
3. Step 3
   

Various cost ratios of false negatives to false positives were applied to the stratified sampling procedure with replacement. The sample of the deceased was set to 21, and after that, adjustments were made to sample the isolated and released in response. Table 1 is the confusion matrix from the OOB estimates. Because there is a large imbalance in outcome distribution (less than 2% of individuals die from the disease), then it is difficult to arrive at fully sensible cost ratios through the sampling method. Table 2 is
the confusion table for deaths and released. The intent was to make a false negative death 20 more costly than a false positive. Stakeholders noted that a false negative death predicted to be a released would be the most costly decision possible, and avoided at the highest costs. The confusion table from the OOB estimates shows the random forest classification avoided all false negatives in this case. Table 3 is the confusion table for deceased and isolated. The intent was to make a false negative death 10 times as
costly, and the confusion table shows a larger ratio at 20 to 1, achieved due to the high number of people isolated, and under-sampling from this parameter. Table 4 is the confusion table for the released and isolated, which was asked by stakeholders to be the situation that could be the closest to a 1:1 cost ratio. The ratio intended by stakeholders was to be a ratio of 2:1, and the actual ratio that result was around 1.2 to 1. The tradeoff makes sense, because this is
the decision with the least repercussions, according to stakeholders. Stakeholders noted that failing to identify someone who should have been isolated as having been released, then they are likely to go back
into their communities and be isolated anyways, with such protective measures and stay at home orders already in place.

## Oucome

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

<p align="center">
<img src="https://github.com/katjanewilson/CORD-Random-Forest/blob/master/images/forecasting_importance.png"
  alt="Size Limit comment in pull request about bundle size changes"
  width="400" height="200">
</p>
