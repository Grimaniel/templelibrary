/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.core.display 
{
	import temple.core.events.ICoreEventDispatcher;

	import flash.geom.Point;

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
	public interface ICoreDisplayObject extends IDisplayObject, ICoreEventDispatcher
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
		 * Removes the object from his parent.
		 */
		function removeFromParent():void;
	
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
