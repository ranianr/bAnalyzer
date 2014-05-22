UI_Path=../UI
pyuic4 -o $UI_Path/MainUI/gui_main.py $UI_Path/MainUI/gui_main.ui
pyuic4 -o $UI_Path/NavigateUI/gui_navigate.py $UI_Path/NavigateUI/gui_navigate.ui
python FeatureGUI.py
