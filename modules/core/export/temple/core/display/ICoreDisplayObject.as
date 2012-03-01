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
	import flash.geom.Point;
	import temple.core.ICoreObject;
	import temple.core.events.ICoreEventDispatcher;


	/**
	 * The <code>ICoreDisplayObjects</code> extends Flash native DisplayObject classes, like <code>Sprite</code>,
	 * <code>MovieClip</code> and <code>Loader</code>. The <code>ICoreDisplayObjects</code> extends
	 * <code>ICoreObject</code> and are enhanced with some basic functionality, like a better stage and parent check and
	 * '<code>autoAlpha</code>'.
	 * 
	 * <p>Even when an <code>ICoreDisplayObject</code> is not on the stage he has a stage. Since he get his stage
	 * reference from the <code>StageProvider</code> who holds a global reference to the stage.</p>
	 * 
	 * <p>ICoreDisplayObject are automatically destructed when the SWF is unloaded. When a ICoreDisplayObject is
	 * destructed we will call also destruct its children, grandchildren etcetera.</p>
	 * 
	 * @see temple.core.display.StageProvider
	 * 
	 * @includeExample CoreDisplayObjectsExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreDisplayObject extends IDisplayObject, ICoreObject, ICoreEventDispatcher
	{
		/**
		 * Returns <code>true</code> if this object is on the <code>Stage</code>, <code>false</code> if not.
		 * <p>Needed since the <code>stage</code> property can't be trusted for timeline objects.</p>
		 * 
		 * <p><strong>NOTE:</strong> The <code>stage</code> property is set even when the <code>ICoreDisplayObject</code>
		 * is not on the stage. The ICoreDisplayObject gets the stage from the StageProvider</p>
		 * 
		 * @see temple.core.display.StageProvider
		 */
		function get onStage():Boolean;

		/**
		 * Returns true if this object has a parent.
		 * 
		 * <p>Needed since <code>parent</code> property can't be trusted for timeline objects.</p>
		 */
		function get hasParent():Boolean;
	
		/**
		 * Same as <code>alpha</code>, but the visible property will automatically be set. 
		 * 
		 * <p>When value is 0 <code>visible</code> will be false, else <code>visible</code> will be true.
		 * If alpha > 0, but visible == false, then autoAlpha will return 0</p>
		 */
		function get autoAlpha():Number;

		/**
		 * @private
		 */
		function set autoAlpha(value:Number):void;

		/**
		 * Get or set to position of the object as a <code>Point</code>. It is not possible to set x and/or y directy on
		 * the Point. Use x and/or y of the DisplayObject instead.
		 */
		function get position():Point;
		
		/**
		 * @private
		 */
		function set position(value:Point):void;

		/**
		 * Get and set <code>scaleX</code> and <code>scaleY</code> in one property. If <code>scaleX</code> is not the
		 * same as <code>scaleY</code> <code>NaN</code> is returned.
		 */
		function get scale():Number;
		
		/**
		 * @private
		 */
		function set scale(value:Number):void;

		/**
		 * A Boolean which indicates if the object must be destructed if the loader from which it is loaded is unloaded.
		 * Default: true
		 */
		function get destructOnUnload():Boolean;

		/**
		 * @private
		 */
		function set destructOnUnload(value:Boolean):void;
	}
}
