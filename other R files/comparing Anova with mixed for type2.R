
m1 <- lmer(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec)

(m2 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec, type = 2))

(m3 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec, type = 3))

Anova(m1, test.statistic = "F")
## Analysis of Deviance Table (Type II Wald F tests with Kenward-Roger df)
## 
## Response: RT
##                           F Df Df.res           Pr(>F)    
## Correct                8.15  1   1628          0.00437 ** 
## Trial                  7.57  1   1592          0.00599 ** 
## PrevType              52.11  1   1606 0.00000000000081 ***
## meanWeight            15.34  1     75          0.00020 ***
## Frequency             56.53  1     76 0.00000000009076 ***
## NativeLanguage         6.64  1     19          0.01845 *  
## Length                 7.06  1     75          0.00965 ** 
## PrevType:meanWeight    6.18  1   1601          0.01300 *  
## NativeLanguage:Length 14.24  1   1555          0.00017 ***
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

Anova(m1, test.statistic = "F", type = 3)
## Analysis of Deviance Table (Type III Wald F tests with Kenward-Roger df)
## 
## Response: RT
##                              F Df Df.res               Pr(>F)    
## (Intercept)           13573.10  1     97 < 0.0000000000000002 ***
## Correct                   8.15  1   1628              0.00437 ** 
## Trial                     7.57  1   1592              0.00599 ** 
## PrevType                  0.17  1   1605              0.68019    
## meanWeight               14.85  1     75              0.00024 ***
## Frequency                56.53  1     76       0.000000000091 ***
## NativeLanguage            0.70  1     27              0.41167    
## Length                    8.70  1     76              0.00424 ** 
## PrevType:meanWeight       6.18  1   1601              0.01300 *  
## NativeLanguage:Length    14.24  1   1555              0.00017 ***
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 


m1b <- lmer(RT ~ Correct + Trial + PrevType + meanWeight + Frequency + NativeLanguage + Length + (1|Subject) + (1|Word), data = lexdec)

Anova(m1b, test.statistic = "F")

## Analysis of Deviance Table (Type II Wald F tests with Kenward-Roger df)
## 
## Response: RT
##                    F Df Df.res           Pr(>F)    
## Correct         6.49  1   1630          0.01097 *  
## Trial           7.02  1   1595          0.00813 ** 
## PrevType       51.78  1   1608 0.00000000000095 ***
## meanWeight     15.15  1     75          0.00021 ***
## Frequency      55.80  1     76 0.00000000011232 ***
## NativeLanguage  6.69  1     19          0.01813 *  
## Length          7.13  1     75          0.00928 ** 
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
## 
