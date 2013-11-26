(function()
{
	// crossbrowser init
	if (document.readyState === "complete") 
	{
		init();
	}
	else if (document.addEventListener) 
	{
		document.addEventListener("DOMContentLoaded", init, false);
		window.addEventListener("load", init, false);
	}
	else if(window.attachEvent) 
	{
		document.attachEvent("onreadystatechange", init);
		window.attachEvent("onLoad", init);
	} 
	else
	{
		setTimeout(init,2000);
	};
	
	function init()
	{
		if (arguments.callee.done) return;
		arguments.callee.done = true;
	
		var summary = new Summary( document.getElementsByTagName("body")[0], document.getElementById("SummaryContent") );
		summary.create();
	};
	
	function Summary(contentElement, outputElement) 
	{
		this.contentElement = contentElement;
		this.outputElement = outputElement;
	}
	
	Summary.prototype.create = function()
	{
		this.outputElement.innerHTML = this.getContent(["h1", "h2", "h3","h4","h5","h6"]);
	}
	
	Summary.prototype.getContent = function(tagList)
	{
		var elements = this.getByTagName(tagList);
		
		var output = "";
		
		for (var i = 0, leni = elements.length; i < leni; i++) 
		{
			var heading = elements[i];
			var headingText = heading.innerHTML;
			var headingID = heading.getAttribute("id");
			var headingNodeName = heading.nodeName.toLowerCase();
			
			if (!headingID) 
			{
				headingID = (heading.innerText || heading.textContent).split(" ").join("-").toLowerCase();
				heading.setAttribute("id", headingID);
			};
			
			if (headingID.toLowerCase() != "summary")
			{
				output += "<li class='summary-"+headingNodeName+"'><a href='#" + (headingID).toString() + "'>" + headingText + "</a></li>\n"
			}
		};
		return output;
	};
	
	Summary.prototype.getByTagName = function(nodeNames)
	{
		var nodes = [];
		
		var all = document.getElementsByTagName("*");

		for (var i = 0, leni = all.length; i < leni; i++) 
		{
			var element = all[i];
			var nodeName = element.nodeName;
			for (var j = 0, lenj = nodeNames.length; j < lenj; j++) 
			{
				if (nodeName.toLowerCase() === nodeNames[j].toLowerCase())
				{
					nodes.push(element);
				};
			};
		};
		return nodes;
	};
	
})();