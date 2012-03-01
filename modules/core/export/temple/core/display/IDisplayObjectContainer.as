/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *
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
