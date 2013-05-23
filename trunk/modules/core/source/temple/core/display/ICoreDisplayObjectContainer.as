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
		 * Returns all children as <code>Vector</code>. The Vector is generated on demand. Modifying the Vector does not
		 * changes the object.
		 */
		function get children():Vector.<DisplayObject>;
		
		/**
		 * Adds a <code>DisplayObject</code> on the display list on the specified <code>x</code> and <code>y</code>.
		 * @param child the <code>DisplayObject</code> to add
		 * @param x the x position of the child
		 * @param y the y position of the child
		 * @param index the index of the child. If the index has a negative value, it will be placed on top.
		 */
		function addChildAtPosition(child:DisplayObject, x:Number, y:Number, index:int = -1):DisplayObject;

	}
}
