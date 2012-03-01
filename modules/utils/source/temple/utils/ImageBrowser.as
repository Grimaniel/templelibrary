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
