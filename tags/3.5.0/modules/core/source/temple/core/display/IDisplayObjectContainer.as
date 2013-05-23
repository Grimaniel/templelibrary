/*
include "../includes/License.as.inc";
 */

package temple.core.display 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextSnapshot;

	/**
	 * Interface that contains all the properties of a DisplayObjectContainer. This interface is implemented by all
	 * DisplayObjectContainesr of the Temple, but not by Flash native DisplayObjectContainers. This interface is
	 * extended by other interface to force they can only be implemented by DisplayObjectContainers. 
	 * 
	 * @author Thijs Broerse
	 */
	public interface IDisplayObjectContainer extends IDisplayObject
	{
		function addChild(child:DisplayObject):DisplayObject;
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		
		function areInaccessibleObjectsUnderPoint(point:Point):Boolean;
		
		function contains(child:DisplayObject):Boolean;
		
		function getChildAt(index:int):DisplayObject;
		function getChildByName(name:String):DisplayObject;
		function getChildIndex(child:DisplayObject):int;
		
		function getObjectsUnderPoint(point:Point):Array;
		
		function get mouseChildren():Boolean;
		function set mouseChildren(enable:Boolean):void;
		
		function get numChildren():int;
		
		function removeChild(child:DisplayObject):DisplayObject;
		function removeChildAt(index:int):DisplayObject;
		
		function setChildIndex(child:DisplayObject, index:int):void;
		
		function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
		function swapChildrenAt(index1:int, index2:int):void;
		
		function get tabChildren():Boolean;
		function set tabChildren(enable:Boolean):void;
		
		function get textSnapshot():TextSnapshot;
	}
}
