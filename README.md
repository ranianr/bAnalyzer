bAnalyzer
=========
Description: 
============
What does this project do and who does it serve?
bAnalyzer is a machine learning tool that provides simple UI enabling the user to easily select the feature extraction, 
feature selection, feature enhancement and classification method. This tool then provides statistics about different compinations 
between classifiers and pre-processing methods. according to the resulted accuracy in each path. 

Supported methods: 
==================
- Apply CAR or not (noise removal)
- Select preprocessing methos
   * Butterworth Filter
   * Ideal filter
- Feature Extraction methos :
    * Mean Mu and Beta
    * Min Mu and Max Beta
    * Min Mu Max Beta, mean Mu Mean Beta
    * Min Mu Max Mu, Min Beta Max Beta 
    * Min Mu Max Mu, Min Beta Max Beta, mean Mu mean Beta
- Feature enhancements methods :
    * LDA
    * PCA 
    * No enhancement (None)
- Classifiers 
    * KNN
    * Fisher (Not tested)
    * Least Squares
    * likelihood 
    
this tools allows the user to test classifers on the same training file or new detection file (ALL FILES MUST BE .CSV)
the .CSV for detection should have the correct classes for each point to calculate the detection accuracy.

Project Setup: 
==============
install all dependancies by running ./Install.sh
create a file named "GooglespreadSheetConfig" and place it in "/Configurations" folder the file should look like this: 

#account
email    = 'YourEmail'
password = 'YourPassword'

#Spreadsheet details
title = 'Spreadsheet name'
url   = 'Spreadsheet URL'
sheet1_title ='working sheet number/name'



create a file named "GooglespreadSheetConfig" and place it in "/Configurations" folder the file should look like this: 

email    = 'YourEmail'

password = 'YourPassword'

title = 'Spreadsheet name'

url   = 'Spreadsheet URL'

sheet1_title ='working sheet number/name'


Testing: 
=========
Run bAnalyzer by ./bAnalyzer.sh
select the training file path and your prefered path then click Train to create the classifier parameters, Select the detection data 
then click detect to check the accuracy of the given path 
you can click bulk Detect to choose many paths to run and show thier summary 
in bulk detection mode this summary will be written in the google spread sheet you mentioned in "GooglespreadSheetConfig" file


