UI_Path=UI

clear

echo -e "\e[1;31m   Generating MainUI"

pyuic4 -o $UI_Path/Analyzer.py $UI_Path/Analyzer.ui

echo -e "\e[1;31m   Generating BulkDetectionUI"

pyuic4 -o $UI_Path/BulkDetection.py $UI_Path/BulkDetection.ui

echo -e "\e[1;31m   Generating FeatureAnalysisUI"

pyuic4 -o $UI_Path/Features/gui_main.py $UI_Path/Features/gui_main.ui

echo -e "\e[1;31m   Generating FeatureNavigationUI"

pyuic4 -o $UI_Path/Features/gui_navigate.py $UI_Path/Features/gui_navigate.ui

echo -e "\e[1;37m\nStarting Braingizer-Analyzer\n\e[0m"
python AnalyzerGUI.py
