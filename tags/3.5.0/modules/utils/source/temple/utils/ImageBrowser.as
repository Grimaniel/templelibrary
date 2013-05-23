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
	import temple.core.debug.IDebuggable;
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
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name = "complete", type = "flash.events.Event")]

	/**
	 * @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name = "error", type = "flash.events.ErrorEvent")]

	/**
	 * Opens a file select window for selecting an image. Loads the images and converts to BitmapData.
	 * 
	 * @example
	 * <listing version="3.0">
	 * _imageBrowser = new ImageBrowser();
	 * _imageBrowser.addEventListener(Event.COMPLETE, handleImageComplete);
	 * _imageBrowser.browse();
	 * 
	 * private function handleImageComplete(event:Event):void
	 * {
	 *		// BitmapData is now available via 
	 *		_imageBrowser.data;
	 * }
	 * </listing>
	 * 
	 * @author Thijs Broerse
	 */
	public class ImageBrowser extends CoreEventDispatcher implements IDebuggable
	{
		public static const _IMAGES_FILTER:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		
		private var _file:CoreFileReference;
		private var _loader:CoreLoader;
		private var _maxImageSize:Number;
		private var _instantLoad:Boolean;
		private var _debug:Boolean;

		public function ImageBrowser(instantLoad:Boolean = true)
		{
			_instantLoad = instantLoad;

			_file = new CoreFileReference();
			_file.addEventListener(Event.SELECT, handleFileSelect);
			_file.addEventListener(Event.CANCEL, handleFileCancel);
			_file.addEventListener(Event.COMPLETE, handleFileComplete);

			_loader = new CoreLoader();
			_loader.addEventListener(Event.COMPLETE, handleLoaderComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
		}

		public function browse():Boolean
		{
			if (debug) logDebug("browse");
			return _file.browse([_IMAGES_FILTER]);
		}

		public function get file():CoreFileReference
		{
			return _file;
		}

		public function get data():BitmapData
		{
			return _loader.content is Bitmap ? Bitmap(_loader.content).bitmapData : null;
		}

		public function get rawData():ByteArray
		{
			return _file ? _file.data : null;
		}

		public function get maxImageSize():Number
		{
			return _maxImageSize;
		}

		public function set maxImageSize(value:Number):void
		{
			_maxImageSize = value;
		}

		public function load():void
		{
			if (debug) logDebug("load");
			if (_file.data)
			{
				_loader.loadBytes(_file.data);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		private function handleFileSelect(event:Event):void
		{
			if (debug) logDebug("handleFileSelect: '" + _file.name + "'");
			if (!isNaN(_maxImageSize) && _file.size > _maxImageSize * 1024)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			else
			{
				_file.load();
			}
		}
		
		private function handleFileCancel(event:Event):void
		{
			if (debug) logDebug("handleFileCancel");
			dispatchEvent(new Event(Event.CANCEL));
		}

		private function handleFileComplete(event:Event):void
		{
			if (debug) logDebug("handleFileComplete: '" + _file.name + "'");
			if (_instantLoad)
			{
				_loader.loadBytes(_file.data);
			}
		}

		private function handleLoaderComplete(event:Event):void
		{
			if (debug) logDebug("handleLoaderComplete");
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_file)
			{
				_file.destruct();
				_file = null;
			}
			if (_loader)
			{
				_loader.destruct();
				_loader = null;
			}

			super.destruct();
		}
	}
}
