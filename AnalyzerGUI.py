import sys
sys.path.append('UI')
sys.path.append('Classes')

from PyQt4 import QtCore, QtGui
from Analyzer_extended import Ui_MainWindow_Extended


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)

    #MainUI
    MainWindow = QtGui.QMainWindow()
    ui_main = Ui_MainWindow_Extended()
    ui_main.setupUi(MainWindow)
    ui_main.InitializeUI()
    
    MainWindow.show()

    sys.exit(app.exec_())
