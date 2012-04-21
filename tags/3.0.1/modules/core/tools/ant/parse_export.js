// imports
importPackage(java.net);
importPackage(java.io);
importPackage(java.lang);
importPackage(java.util);


// Access to Ant-Properties by their names
var base      = project.getProperty("base.dir");

var includesMap = {};

// echo what we are doing
echo = project.createTask("echo");
echo.setMessage("Get the content of all the include files:");
echo.perform();

// Get includes
var includesDir = base + "/source/temple/core/includes"
var includesFileset = project.createDataType("fileset");
includesFileset.setDir(new File(includesDir));
includesFileset.setIncludes("**/*.inc");

// Get the files (array) of that fileset
var includesFiles = includesFileset.getDirectoryScanner(project).getIncludedFiles();

// iterate over that array
for (i=0; i< includesFiles.length; i++)
{
	var contents = new StringBuilder();
	var fileName = includesFiles[i];
	var input = new BufferedReader(new FileReader(includesDir + "/" + fileName));
	var line = null;
	while ((line = input.readLine()) !== null)
	{
		contents.append(line);
		contents.append("\n");
	}

	var echo = project.createTask("echo");
	echo.setMessage(" - " + fileName);
	echo.perform();
	
	// Fill the map based on the filename (without extension) and the content of the file
	includesMap[fileName.substring(0, fileName.indexOf("."))] = contents.toString()
}


//echo what we are doing
echo = project.createTask("echo");
echo.setMessage("Parse all .as files:");
echo.perform();

// Get includes
var sourceDir = base + "/source/temple/core"
var exportDir = base + "/export/temple/core"
var sourceFileset = project.createDataType("fileset");
sourceFileset.setDir(new File(sourceDir));
sourceFileset.setIncludes("**/*.as");

// Get the files (array) of that fileset
var sourceFiles = sourceFileset.getDirectoryScanner(project).getIncludedFiles();

var regExp = /^[\t ]*include ["'][\.\/]+includes\/(\w+).*["'];/;

// iterate over that array
for (i=0; i< sourceFiles.length; i++)
{
	var fileName = sourceFiles[i];
	var input = new BufferedReader(new FileReader(sourceDir + "/" + fileName));
	
	var output = new DataOutputStream(new FileOutputStream(exportDir + "/" + fileName));
	
	var line = null;
	while ((line = input.readLine()) !== null)
	{
		// convert to a "real" string :-S
		line = "" + line;
		
		if (regExp.test(line))
		{
			line = line.replace(regExp, includesMap[line.match(regExp)[1]]);
		}
		else
		{
			line = line + "\n";
		}
		
		output.writeBytes(line);
	}

	var echo = project.createTask("echo");
	echo.setMessage(" - " + fileName);
	echo.perform();
	
}