#Luigi


# Question 1: Leading CovidData
setwd("/Users/kwabenabayity/Documents/GitHub/Quiz2_Kwabena")
covid_data <- read.csv("/Users/kwabenabayity/Documents/GitHub/Quiz2_Kwabena/covid.csv" )

#Printing data to see if i am using the right data or i am on the right path
print(covid_data)

# Check the formatting of the variables:
# View the structure of the data
str(covid_data)

# View the row names
head(covid_data)

# Summary of the data
summary(covid_data)

# Load necessary package
library(dplyr)

#Checking to the names of the rows
names(covid_data)

### Question 2: Convert Variables to Factors and Characters
covid_data$Hospitalization.type <- as.factor(covid_data$Hospitalization.type)
covid_data$Symptoms <- as.factor(covid_data$Symptoms)
covid_data$Outcome <- as.factor(covid_data$Outcome)
covid_data$Epidemiological.link...Notes <- as.character(covid_data$Epidemiological.link...Notes)


#Question 3 and 4: Recoding Outcome Variable
# Replace "Disease in progress" with "Deceased" and ensure Outcome has only two levels: "Healed" and "Deceased"
covid_data$Outcome <- recode(covid_data$Outcome, "Disease in progress" = "Deceased")
covid_data$Outcome <- factor(covid_data$Outcome, levels = c("Healed", "Deceased"))

#Question 5: Order Data by Diagnosis Date
covid_data <- covid_data[order(as.Date(covid_data$Date.of.diagnosis, format="%Y-%m-%d")), ]

#Question 6: Count Cases Born After 1981 or Healed, and in Home Isolation
count_cases <- sum((covid_data$Year.of.birth > 1981 | covid_data$Outcome == "Healed") & 
                     covid_data$Hospitalization.type == "Home isolation")
print(count_cases)

# Question 7: Add Age Column
covid_data$Age <- as.integer((Sys.Date() - as.Date(covid_data$Date.of.birth, format="%Y-%m-%d")) / 365)

#Viewed covid_data$Age to check if i am on the right path
print(covid_data$Age)

#Question 8: Add Positive Column
covid_data$Positive <- grepl("positive", covid_data$Epidemiological.link...Notes, ignore.case = TRUE)


# Question 9: Fit a Logistic Model
risk_model <- glm(Outcome ~ Age + Hospitalization.type + Symptoms + Positive, 
                  data = covid_data, family = "binomial")

## Question 10: Predict Death Probabilities
pred_prob <- predict(risk_model, type = "response")
print(pred_prob)

# Question 11: Classify Predicted Deaths
pred_death <- ifelse(pred_prob > 0.5, "Pred_Deceased", "Pred_Healed")
print(pred_death)

# Question 12: Remove Rows with NA in Hospitalization.type
covid_nona <- covid_data[!is.na(covid_data$Hospitalization.type), ]

#Question 13: Creating a confsion Matrix
conf_matrix <- table(covid_nona$Outcome, pred_death)
print(conf_matrix)

# Comment on the Model’s Performance
# I think the confusion matrix results shows how well or correct our prediction is interms of predicted cases counted.


##Question 14: Predict Death Probability for New Data provided 
new_covid <- data.frame(Age = 50, Hospitalization.type = "Intensive care", Symptoms = "Symptomatic", Positive = TRUE)
new_pred_prob <- predict(risk_model, newdata = new_covid, type = "response")
print(new_pred_prob)



# Question 15: Creating a program that takes new data

# function to evaluate risk level based on new data
evaluate_risk <- function(new_covid) {
  
  # Predict the probability of "Deceased" for the new data
  pred_prob <- predict(risk_model, new_covid = new_covid, type = "response")
  
  # risk level
  risk_level <- ifelse(pred_prob < 0.4, "Low Risk",
                       ifelse(pred_prob < 0.7, "Medium Risk", "High Risk"))
  
  # Print the risk level
  cat("Predicted probability of death:", round(pred_prob, 4), "\n")
  cat("Risk Level:", risk_level, "\n")
}
 print(risk_model)
 
 print(risk_level)
 