# DefectPredictor
This is defect predicting tool for projects using Mozilla Crash Reporter.

To use this tool, you need installing Ruby version 2.0.0 or later and Nokogiri(scraping tool, you can get from gem).

After you clone this repository and prepare crash reports html files, you can use this tool by type below command.

"ruby main_defpred.rb Product Version Crash_Directory"

"Product" and "Version" are product and version  you want to predict defects.

"Crash_Directory" is full path for directory which contains crash reports you prepared.

You can see the result of predict in "result" directory made in "DefectPredictor" directory when run this tool.
