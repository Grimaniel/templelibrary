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

package temple.utils
{
	import temple.core.display.CoreLoader;
	import temple.core.events.CoreEventDispatcher;
	import temple.core.net.CoreFileReference;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	/**
	 * Opens a file select window for selecting an image. Loads the images and converts to BitmapData.
	 * 
	 * @example
	 * <listing version="3.0">
	 * this._imageBrowser = new ImageBrowser();
	 * this._imageBrowser.addEventListener(Event.COMPLETE, this.handleImageComplete);
	 * this._imageBrowser.browse();
	 * 
	 * private function handleImageComplete(event:Event):void
	 * {
	 *		// BitmapData is now available via 
	 *		this._imageBrowser.data;
	 * }
	 * </listing>
	 * 
	 * @author Thijs Broerse
	 */
	public class ImageBrowser extends CoreEventDispatcher
	{
		public static const _IMAGES_FILTER:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		
		private var _file:CoreFileReference;
		private var _loader:CoreLoader;
		private var _maxImageSize:Number;
		private var _instantLoad:Boolean;

		public function ImageBrowser(instantLoad:Boolean = true)
		{
			this._instantLoad = instantLoad;

			this._file = new CoreFileReference();
			this._file.addEventListener(Event.SELECT, this.handleFileSelect);
			this._file.addEventListener(Event.COMPLETE, this.handleFileComplete);

			this._loader = new CoreLoader();
			this._loader.addEventListener(Event.COMPLETE, this.handleLoaderComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
		}

		public function browse():Boolean
		{
			return this._file.browse([_IMAGES_FILTER]);
		}

		public function get file():CoreFileReference
		{
			return this._file;
		}

		public function get data():BitmapData
		{
			return this._loader.content is Bitmap ? Bitmap(this._loader.content).bitmapData : null;
		}

		public function get rawData():ByteArray
		{
			return this._file ? this._file.data : null;
		}

		public function get maxImageSize():Number
		{
			return this._maxImageSize;
		}

		public function set maxImageSize(value:Number):void
		{
			this._maxImageSize = value;
		}

		public function load():void
		{
			if (this._file.data)
			{
				this._loader.loadBytes(this._file.data);
			}
		}

		private function handleFileSelect(event:Event):void
		{
			if (!isNaN(this._maxImageSize) && this._file.size > this._maxImageSize * 1024)
			{
				this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			else
			{
				this._file.load();
			}
		}

		private function handleFileComplete(event:Event):void
		{
			if(this._instantLoad)
			{
				this._loader.loadBytes(this._file.data);
			}
		}

		private function handleLoaderComplete(event:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function destruct():void
		{
			if (this._file)
			{
				this._file.destruct();
				this._file = null;
			}
			if (this._loader)
			{
				this._loader.destruct();
				this._loader = null;
			}

			super.destruct();
		}
	}
}
