/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import flash.utils.getQualifiedClassName;
	import temple.core.Temple;

	
	/**
	 * Creates a nice readable class name of an object or class. Uses <code>getQualifiedClassName</code> internally but
	 * you can disablefull package display in the <code>Temple</code> class.
	 * 
	 * @see temple.core.Temple#displayFullPackageInToString()
	 * 
	 * @author Thijs Broerse
	 */
	public function getClassName(object:*):String
	{
		var qualifiedClassName:String = object is String ? object : getQualifiedClassName(object);
		
		if (Temple.displayFullPackageInToString || qualifiedClassName.indexOf('::') == -1)
		{
			return qualifiedClassName;
		}
		else
		{
			if (qualifiedClassName.indexOf('<') != -1)
			{
				// Vector exception
				var a:Array = qualifiedClassName.match(/(?<=::)\w+/g);
				var s:String = a.shift();
				var e:String = "";
				while (a.length)
				{
					s += ".<" + a.shift();
					e += ">";
				}
				return s + e;
			}
			else
			{
				return qualifiedClassName.split('::')[1];
			}
		}
	}
}
