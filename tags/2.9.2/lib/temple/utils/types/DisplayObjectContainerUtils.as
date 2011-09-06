/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
package temple.utils.types
{
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.debug.log.Log;
	import temple.debug.objectToString;

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
		public static function findChildOfType(container:DisplayObjectContainer, type:Class, recursive:Boolean = false):DisplayObject
		{
			var child:DisplayObject;
			var leni:int = container.numChildren;
			for (var i:int = 0;i < leni;i++)
			{
				child = container.getChildAt(i);

				if (child is type)
				{
					return child;
				}
				else if (recursive && child is DisplayObjectContainer)
				{
					child = DisplayObjectContainerUtils.findChildOfType(child as DisplayObjectContainer, type, recursive);
					if (child != null) return child;
				}
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
		private static function getDescendantByNames(container:DisplayObjectContainer, names:Array):DisplayObject
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

		public static function toString():String
		{
			return objectToString(DisplayObjectContainerUtils);
		}
	}
}
