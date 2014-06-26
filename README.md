bAnalyzer
=========
Description: 
============
What does this project do and who does it serve?
bAnalyzer is a machine learning tool that provides simple UI enabling the user to easily select the feature extraction, 
feature selection, feature enhancement and classification method. This tool then provides statistics about different compinations 
between classifiers and pre-processing methods. according to the resulted accuracy in each path. it has bulk detection option to select many paths and check thier result written in a spreadsheet. The super bulk detection mode enable the user to select a folder that has set of training files it brings all detection files for this training session and apply all selected paths to them, results are written in the spread sheet too.

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
    
This tools allows the user to test classifers on the same training file or new detection file (ALL FILES MUST BE .CSV), for the same file option the user can specify the offset of data to be used as training of testing set (for cross validation of the classifier 80% of the data training data - 20% testing data the start index of both testing data depends on the selected offset)

The .CSV for detection should have the correct classes for each point to calculate the detection accuracy.

Project Setup: 
==============
install all dependancies by running ./Install.sh
create a file named "GooglespreadSheetConfig.py" and place it in "/Configurations" folder the file should look like this: 

email    = 'YourEmail'

password = 'YourPassword'

title = 'Spreadsheet name'

url   = 'Spreadsheet URL'

sheet1_title ='working sheet number/name'


Testing: 
=========
Run bAnalyzer by ./bAnalyzer.sh
select the training file path and your prefered path then click Train to create the classifier parameters, Select the detection data 
then click detect to check the accuracy of the given path.

You can click bulk Detect select all desired paths, you can select path for traing and detection files folder to enter super bulk detection mode.
In bulk detection mode this summary will be written in the google spread sheet you mentioned in "GooglespreadSheetConfig" file


