UI_Path=../UI
pyuic4 -o $UI_Path/Features/gui_main.py $UI_Path/Features/gui_main.ui
pyuic4 -o $UI_Path/Features/gui_navigate.py $UI_Path/Features/gui_navigate.ui
python FeatureGUI.py
