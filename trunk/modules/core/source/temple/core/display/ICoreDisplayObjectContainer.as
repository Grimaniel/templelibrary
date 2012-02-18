/*
include "../includes/License.as.inc";
 */

package temple.core.display 
{
	import flash.display.DisplayObject;
	
	/**
	 * Interface for the <code>DisplayObjectContainers</code> of the Temple.
	 * 
	 * <p><code>ICoreDisplayObjectContainer</code> adds the property <code>children</code> to the object. This property
	 * is an easy way to access the display list children of the object.</p> 
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreDisplayObjectContainer extends ICoreDisplayObject, IDisplayObjectContainer 
	{
		/**
		 * Returns all children as Vector. The Vector is generated on demand. Modifying the Vector does not changes the object.
		 */
		function get children():Vector.<DisplayObject>;
	}
}
