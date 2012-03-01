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
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**
	 * Interface that contains all the properties of a DisplayObject. This interface is implemented by all
	 * DisplayObjects of the Temple, but not by Flash native DisplayObects. This interface is extended by
	 * other interface to force they can only be implemented by DisplayObjects. 
	 * 
	 * @author Arjan van Wijk
	 */
	public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable
	{
		function get accessibilityProperties():AccessibilityProperties;
		function set accessibilityProperties(value:AccessibilityProperties):void;

		function get alpha():Number;
		function set alpha(value:Number):void;

		function get blendMode():String;
		function set blendMode(value:String):void;

		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap(value:Boolean):void;

		function get filters():Array;
		function set filters(value:Array):void;

		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;

		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;

		function globalToLocal(point:Point):Point;

		function get height():Number;
		function set height(value:Number):void;

		function hitTestObject(obj:DisplayObject):Boolean;

		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;

		function get loaderInfo():LoaderInfo;

		function localToGlobal(point:Point):Point;

		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;

		function get mouseX():Number;
		
		function get mouseY():Number;

		function get name():String;
		function set name(value:String):void;

		function get opaqueBackground():Object;
		function set opaqueBackground(value:Object):void;

		function get parent():DisplayObjectContainer;

		function get root():DisplayObject;

		function get rotation():Number;
		function set rotation(value:Number):void;

		function get scale9Grid():Rectangle;
		function set scale9Grid(innerRectangle:Rectangle):void;

		function get scaleX():Number;
		function set scaleX(value:Number):void;
	
		function get scaleY():Number;
		function set scaleY(value:Number):void;

		function get scrollRect():Rectangle;
		function set scrollRect(value:Rectangle):void;

		function get stage():Stage;

		function get transform():Transform;
		function set transform(value:Transform):void;

		function get visible():Boolean;
		function set visible(value:Boolean):void;

		function get width():Number;
		function set width(value:Number):void;

		function get x():Number;
		function set x(value:Number):void;

		function get y():Number;
		function set y(value:Number):void;
	}
}
