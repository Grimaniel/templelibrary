/*
include "../includes/License.as.inc";
 */

package temple.core.debug
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Adds an object to the DebugManager, but only when the DebugManager is available.
	 * 
	 * @param object the object to add to the DebugManager
	 * @param parent if profided, the object will also be added as child of this parent
	 * 
	 * @see temple.core.debug.DebugManager#add()
	 * @see temple.core.debug.DebugManager#addAsChild()
	 * 
	 * @author Thijs Broerse
	 */
	public function addToDebugManager(object:IDebuggable, parent:IDebuggable = null):void
	{
		const definition:String = "temple.core.debug.DebugManager";
		const add:String = "add";
		const addAsChild:String = "addAsChild";
		
		if (ApplicationDomain.currentDomain.hasDefinition(definition))
		{
			var debugManager:Class = getDefinitionByName(definition) as Class;
			
			if (debugManager)
			{
				if ((add in debugManager) && (debugManager[add] is Function))
				{
					debugManager[add](object);
					if (parent) debugManager[addAsChild](object, parent);
				}
			}
		}
	}
}
