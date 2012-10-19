
function build()
{
	var properties = loadProperties();
	
	updateLibraryPath(properties);
	
	publish(properties);
	
	save(properties);
}

function test()
{
	Superdoc.file.test.movie();
}

function loadProperties()
{
	var properties = {};
	
	properties.url = Superdoc.file.properties.uri;
	properties.module = properties.url.match(/(modules\/)(\w+)/)[2];
	
	// general properties
	var propertiesXML = new XML(xjsfl.file.load(URI.toURI("../ant/temple-properties.xml")));
	for each (var property in propertiesXML.property)
	{
		if (property.@name) properties[property.@name] = property.@value.toString();
	}
	
	// module specific properties
	if (properties.module)
	{
		var moduleXML =  new XML(xjsfl.file.load(URI.toURI("../../modules/" + properties.module + "/tools/ant/build-" + properties.module + ".xml"))); 
		Output.inspect(moduleXML);
		
		for each (var property in moduleXML.property)
		{
			if (property.@name) properties[property.@name] = property.@value.toString();
		}
	}
	
	// example specific properties
	if (properties.module)
	{
		var moduleXML =  new XML(xjsfl.file.load(URI.toURI(properties.url.substr(0, properties.url.length - 3) + "xml"))); 
		Output.inspect(moduleXML);
		
		for each (var property in moduleXML.property)
		{
			if (property.@name) properties[property.@name] = property.@value.toString();
		}
	}
	
	Output.inspect(properties);
	
	return properties;
}

function updateLibraryPath(properties)
{
	var depth = properties.url.substring(properties.url.indexOf(properties.module)).split("/").length - 2;
	
	var prefix = "";
	for (var i = 0; i < depth; i++)
	{
		prefix += "../";
	}
	
	var dependencies = properties.dependencies.split(",");
	var libraries = []
	
	for (var i = 0; i < dependencies.length; i++)
	{
		libraries.push(prefix + "lib/temple-" + dependencies[i] + "_" + properties.version + ".swc");
	}
	
	if (properties['extra-dependencies'])
	{
		var extra = properties['extra-dependencies'].split(",");
		
		for (var i = 0; i < extra.length; i++)
		{
			if (extra[i].indexOf("extended") == -1)
			{
				libraries.push(prefix + "../../modules/" + extra[i] + "/bin/temple-" + extra[i] + "_" + properties.version + ".swc");
			}
			else
			{
				libraries.push(prefix + "../../modules/" + extra[i].split("-")[0] + "/bin/temple-" + extra[i] + "_" + properties.version + ".swc");
			}
		}
	}
	if (properties['libraries'])
	{
		var libs = properties['libraries'].split(",");
		for (var i = 0; i < libs.length; i++)
		{
			libraries.push(prefix + "lib/" + libs[i]);
		}
		
	}
	
	Output.inspect(libraries);
	
	Superdoc.settings.as3.libraryPath = libraries.join(";");
}

/**
 *	Publish currently open file
 *	@return true if no errors were found, otherwise false
 */
function publish(properties)
{
	Superdoc.file.publish();

	fl.compilerErrors.save(URI.toURI(properties["root.dir"] + "/tools/jsfl/output.txt"));
}

function save(properties)
{
	// Temporary save to an other name to force a save
	fl.saveDocument(fl.documents[0], properties.url);
}