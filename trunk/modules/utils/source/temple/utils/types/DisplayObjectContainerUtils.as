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

package temple.utils.types
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * This class contains some functions for DisplayObjectContainers.
	 * 
	 * 
	 * var field:TextField = DisplayObjectContainerUtils.getTextField(this, 'mcLogo', 'mcInner', 'mcInnerNested', 'txtField');
	 * 
	 * will throw an error when a sub-contianer doenst exists, or child is bad type etc
	 * 
	 * @author Thijs Broerse
	 */
	public final class DisplayObjectContainerUtils
	{
		/**
		 * Searches the display list for a child of a specific type. Returns the first found child
		 * 
		 * @param container The DisplayObjectContainer that has the child
		 * @param type the Class of the child to find
		 * @param recursive is set to true also children (and grandchildren etc) will be searched for the type
		 * 
		 * @return the first child of the type
		 */
		public static function getChildOfType(container:DisplayObjectContainer, type:Class, recursive:Boolean = false):DisplayObject
		{
			if (recursive) var queue:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			var i:uint, leni:int, child:DisplayObject;

			while (container)
			{
				for (i = 0, leni = container.numChildren; i < leni; i++)
				{
					child = container.getChildAt(i);
					if (child is type)
					{
						return child;
					}
					else if (recursive && child is DisplayObjectContainer)
					{
						queue.push(child);
					}
				}
				container = recursive && queue.length ? queue.shift() : null;
			}
			return null;
		}
		
		/**
		 * Searches the display list for children of a specific type.
		 * 
		 * @param container The DisplayObjectContainer that has the child
		 * @param type the Class of the child to find
		 * @param recursive is set to true also children (and grandchildren etc) will be searched for the type
		 * @param addTo optional Array to push children into
		 * 
		 * @return all children of the type
		 */
		public static function getChildrenOfType(container:DisplayObjectContainer, type:Class, recursive:Boolean = false, addTo:Array = null):Array
		{
			if (!container) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'null or empty container'));
			if (!type) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'null or empty type'));

			addTo = addTo ? addTo : [];

			var child:DisplayObject;
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni;i++)
			{
				child = container.getChildAt(i);

				if (child is type)
				{
					addTo.push(child);
				}
				else if (recursive && child is DisplayObjectContainer)
				{
					DisplayObjectContainerUtils.getChildrenOfType(child as DisplayObjectContainer, type, recursive, addTo);
				}
			}
			return addTo;
		}
		
		/**
		 * Searches the display list for a child with a specific name.
		 * 
		 * @param container The DisplayObjectContainer that has the child
		 * @param name The the name of the child to find
		 * @param type the Class of the child to find
		 * 
		 * @return all children of the type
		 */
		public static function getDescendantByName(container:DisplayObjectContainer, name:String, type:Class = null):DisplayObject
		{
			var queue:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
			
			var i:uint, leni:int, child:DisplayObject;

			while (container)
			{
				for (i = 0, leni = container.numChildren; i < leni; i++)
				{
					child = container.getChildAt(i);
					if (child.name == name && (type == null || child is type))
					{
						return child;
					}
					else if (child is DisplayObjectContainer)
					{
						queue.push(child);
					}
				}
				container = queue.length ? queue.shift() : null;
			}
			return null;
		}

		/**
		 * Searches for a child with a specific name. Throws an TempleArgumentError if no child is found
		 * 
		 * @param container the DisplayObjectContainer which contains the child
		 * @param name the name of the child to find
		 * 
		 * @return the child with the name
		 */
		public static function getDisplayObject(container:DisplayObjectContainer, name:String, ...names):DisplayObject
		{
			if (container == null) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'container is null while looking for \'' + name + '\''));
			if (!name) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'name is null or empty'));
			names.unshift(name);

			return DisplayObjectContainerUtils.getDescendantByNames(container, names);
		}

		/**
		 * Finds a TextField with a specific name. Throws an TempleArgumentError if no child is found or if the object is not a TextField
		 * 
		 * @param container the DisplayObjectContainer which contains the TextField
		 * @param name the name of the TextField to find
		 * @param optional arguments specify (unlimited) deeper nested containers (last name is the requested child)
		 * 
		 *  @return the TextField with the name
		 */
		public static function getTextField(container:DisplayObjectContainer, name:String, ...names):TextField
		{
			if (container == null) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'container is null while looking for \'' + name + '\''));
			if (!name) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'name is null or empty'));
			names.unshift(name);

			var child:DisplayObject = DisplayObjectContainerUtils.getDescendantByNames(container, names);
			if (!(child is TextField))
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the child named \'' + child.name + '\' is not a TextField'));
			}
			return child as TextField;
		}

		/**
		 * Finds a MovieClip with a specific name. Throws an TempleArgumentError if no child is found or if the object is not a MovieClip
		 * 
		 * @param container the DisplayObjectContainer which contains the MovieClip
		 * @param name the name of the MovieClip to find
		 * @param optional arguments specify (unlimited) deeper nested containers (last name is the requested child)
		 * 
		 * @return the MovieClip with the name
		 */
		public static function getMovieClip(container:DisplayObjectContainer, name:String, ...names):MovieClip
		{
			if (container == null) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'container is null while looking for \'' + name + '\''));
			if (!name) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'name is null or empty'));
			names.unshift(name);

			var child:DisplayObject = DisplayObjectContainerUtils.getDescendantByNames(container, names);
			if (!(child is MovieClip))
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the child named \'' + name + '\' is not a MovieClip'));
			}
			return child as MovieClip;
		}

		/**
		 * Find a descendant in a container, recursive: var clip = getDescendantByNames(this, ['mcHolder', 'mcSub', 'mcNested', 'mcTarget']);
		 * throwErrror() on each step for easy debugging
		 * (helper for other getChild-types)
		 */
		public static function getDescendantByNames(container:DisplayObjectContainer, names:Array):DisplayObject
		{
			// no param checks for private

			var name:String = names.shift();
			var child:DisplayObject = container.getChildByName(name);
			if (child == null)
			{
				throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'cannot find a child named \'' + name + '\' in container \'' + container.name + '\' (' + container + ')'));
			}

			if (names.length > 0)
			{
				if (!(child is DisplayObjectContainer))
				{
					throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'the child named \'' + name + '\' in container \'' + container.name + '\' (' + container + ') is not a DisplayObjectContainerUtils'));
				}
				else
				{
					return DisplayObjectContainerUtils.getDescendantByNames(DisplayObjectContainer(child), names);
				}
			}
			return child;
		}
		
		/**
		 * Check if a descendant exists in a container, recursive.
		 */
		public static function hasDescendant(container:DisplayObjectContainer, name:String, ...names):Boolean
		{
			if (container == null) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'container is null while looking for \'' + name + '\''));
			if (!name) throwError(new TempleArgumentError(DisplayObjectContainerUtils, 'name is null or empty'));
			names.unshift(name);

			return DisplayObjectContainerUtils.hasDescendantByNames(container, names);
		}
		
		/**
		 * Check if a descendant exists in a container, recursive.
		 */
		public static function hasDescendantByNames(container:DisplayObjectContainer, names:Array):Boolean
		{
			// no param checks for private

			var name:String = names.shift();
			var child:DisplayObject = container.getChildByName(name);
			if (child == null)
			{
				return false;
			}

			if (names.length > 0)
			{
				if (!(child is DisplayObjectContainer))
				{
					return false;
				}
				else
				{
					return DisplayObjectContainerUtils.hasDescendantByNames(DisplayObjectContainer(child), names);
				}
			}
			return true;
		}

		/**
		 * Disables the mouse on all children, works quite the same as mouseChildren = false, but you can enable some children after this
		 */
		public static function mouseChildren(container:DisplayObjectContainer, recursive:Boolean = true, enabled:Boolean = false, debug:Boolean = false):void
		{
			if (container == null) return;

			container.mouseChildren = true;

			var child:DisplayObject;

			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni;i++)
			{
				child = container.getChildAt(i);

				if (debug) Log.debug("mouseDisableChildren: " + child, DisplayObjectContainer);

				if (child is InteractiveObject)
				{
					InteractiveObject(child).mouseEnabled = enabled;

					if (recursive && child is DisplayObjectContainer)
					{
						DisplayObjectContainer(child).mouseChildren = true;
						DisplayObjectContainerUtils.mouseChildren(DisplayObjectContainer(child), recursive, enabled, debug);
					}
				}
			}
		}

		/**
		 * Reset scaling of container
		 */
		public static function resetScaling(container:DisplayObjectContainer):void
		{
			var len:int = container.numChildren;
			for (var i:int = 0;i < len;i++)
			{
				container.getChildAt(i).width *= container.scaleX;
				container.getChildAt(i).height *= container.scaleY;
			}
			container.scaleX = container.scaleY = 1;
		}

		/**
		 * Moves a displayobject from one container to another and keeps its position
		 */
		public static function moveToContainer(target:DisplayObject, container:DisplayObjectContainer):void
		{
			if (target.parent != container)
			{
				var p:Point = new Point(target.x, target.y);
				if (target.parent)
				{
					p = target.parent.localToGlobal(p);
				}
				p = container.globalToLocal(p);
				container.addChild(target);
				target.x = p.x;
				target.y = p.y;
			}
		}

		/**
		 * Return an array with children, optionally recursive OR remove them
		 */
		public static function getChildren(container:DisplayObjectContainer, recurse:Boolean = false, remove:Boolean = false, into:Array = null):Array
		{
			into ||= [];
			
			var i:int;
			if (remove)
			{
				for (i = container.numChildren - 1;i > -1;i--)
				{
					into.unshift(container.removeChildAt(i));
				}
			}
			else
			{
				var lim:int = container.numChildren;
				for (i = 0;i < lim;i++)
				{
					var disp:DisplayObject = container.getChildAt(i);
					into.push(disp);

					if (recurse && disp is DisplayObjectContainer)
					{
						DisplayObjectContainerUtils.getChildren(DisplayObjectContainer(disp), true, false, into);
					}
				}
			}
			return into;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(DisplayObjectContainerUtils);
		}
	}
}
