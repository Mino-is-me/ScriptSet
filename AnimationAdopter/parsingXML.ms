dotNet.loadAssembly "system.xml"
xmlDoc=dotNetObject "system.xml.xmlDocument"
clearListener()
format "Properties\n"
showProperties xmlDoc
format "\nMethods\n"
showMethods xmlDoc

