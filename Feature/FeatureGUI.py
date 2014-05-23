import signal
import sys
sys.path.append('../UI/Features')
sys.path.append('../UI/NavigateUI')

import os
from PyQt4 import QtCore, QtGui
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from gui_main_extended import Ui_FeatureAnalysisWindow_Extended
import FeatureAnalysisConfig

if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    app.setWindowIcon(QtGui.QIcon('Resources/IMGs/app_icon_64.png'))
    
    #MainUI
    MainWindow = QtGui.QMainWindow()
    ui_main = Ui_FeatureAnalysisWindow_Extended()
    ui_main.setupUi(MainWindow)
    ui_main.InitializeUI(MainWindow, app)
    
    MainWindow.show()
    
    sys.exit(app.exec_())
