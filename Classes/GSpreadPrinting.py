import gspread
import GooglespreadSheetConfig as GSC

class GSpreadPrintingUtilities():
    @staticmethod
    def getEmptyRowIndex(colToCheck):
        gc = gspread.login( GSC.email , GSC.password)
        sh = gc.open(GSC.title) 
        worksheet = sh.worksheet(GSC.sheet_title)

        #investigate the followin columns
        prev_index = -1
        index = -1
        for i in colToCheck:
            values_list = worksheet.col_values(i)
            curr_index = len(values_list)

            if (curr_index > prev_index):
                index = curr_index

#            print "---- getEmptyRowIndex test ----"
#            print "--------"
#            print index
#            print "--------"


            prev_index = curr_index

        return index + 1
