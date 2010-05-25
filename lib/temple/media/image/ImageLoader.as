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
 */

package temple.media.image 
{
	import flash.events.SecurityErrorEvent;
	import temple.core.CoreSprite;
	import temple.data.encoding.image.JPGEncoder;
	import temple.data.encoding.image.PNGEncoder;
	import temple.data.loader.ILoader;
	import temple.data.loader.cache.CacheLoader;
	import temple.data.loader.cache.ICacheable;
	import temple.data.loader.preload.IPreloadable;
	import temple.data.loader.preload.IPreloader;
	import temple.data.loader.preload.PreloaderMode;
	import temple.debug.IDebuggable;
	import temple.ui.layout.Align;
	import temple.ui.layout.ScaleMode;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	[Event(name="open", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="init", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="unload", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Loads an image in a container with scaling, aligning, clipping, smoothing and has support for a Preloader.
	 * 
	 * @example
	 * 	Load the image from an url
	 * 	<listing version="3.0" >var imageLoaderExample:ImageLoader = new ImageLoader("http://weblogs2.nrc.nl/discussie/wp-content/uploads/2007_juli/model.jpg", 100, 200, ScaleMode.NO_SCALE, null, true);</listing>
	 * 	
	 * 	Load the image with a preloader 	
	 * 	<listing version="3.0" >var imageLoaderExample:ImageLoader = new ImageLoader(null, 100, 200, ScaleMode.NO_SCALE, null, true);
imageLoaderExample.preloader = new (getDefinitionByName("PreloaderClip"))();
imageLoaderExample.load("http://weblogs2.nrc.nl/discussie/wp-content/uploads/2007_juli/model.jpg");</listing>
	 * 	
	 * 	Load the image from a ByteArray
	 * 	<listing version="3.0">var imageLoaderExample:ImageLoader = new ImageLoader(pngByteArray, 100, 200, ScaleMode.NO_SCALE, null, true);</listing>
	 * 
	 * @author Arjan van Wijk, Thijs Broerse
	 */
	public class ImageLoader extends CoreSprite implements ILoader, IPreloadable, IDebuggable, ICacheable
	{
		private var _loader:CacheLoader;
		private var _width:Number;
		private var _height:Number;
		private var _clipping:Boolean;
		private var _scaleMode:String;
		private var _align:String;
		private var _smoothing:Boolean;
		private var _context:LoaderContext;
		private var _preloaderMode:String;
		
		private var _debug:Boolean;

		/**
		 * @param url If supplied, start loading this url, can be an url (String) or the data (ByteArray)
		 * @param width The width of the image container (is masked and fitted)
		 * @param height The height of the image container (is masked and fitted)
		 * @param scaleMode The scaleMode for fitting the image (use ScaleMode class as values)
		 * @param align The align mode for the image in the clipped area (use Align class as values)
		 * @param clipping Use clipping (mask) so only the content in width-height-rectangle are shown
		 * @param smoothing If an image is loaded, set smoothing property on the Bitmap after loading
		 * @param preloader Use a DisplayObject that implements the IPreloader interface, the preloader is centered in the width-height-rectangle.
		 * @param preloaderMode Indicates how the ImageLoader uses the preloader. When set to PreloaderMode.OWN_PRELOADER it addChilds and centers the preloader.
		 * @param context
		 */
		public function ImageLoader(url:* = null, width:Number = NaN, height:Number = NaN, scaleMode:String = 'noScale', align:String = null, clipping:Boolean = true, smoothing:Boolean = false, preloader:IPreloader = null, preloaderMode:String = PreloaderMode.OWN_PRELOADER, context:LoaderContext = null, cache:Boolean = false)
		{
			this._width = !isNaN(width) ? width : (super.width ? super.width : NaN);
			this._height = !isNaN(height) ? height : (super.height ? super.height : NaN);
			 
			this._scaleMode = scaleMode;
			this._align = align;
			this._smoothing = smoothing;
			
			this._context = context;
			
			// loader
			this._loader = new CacheLoader(true, cache);
			this._loader.addEventListener(Event.COMPLETE, this.handleLoadComplete);
			this._loader.addEventListener(Event.OPEN, this.handleLoadStart);
			this._loader.addEventListener(Event.INIT, this.dispatchEvent);
			this._loader.addEventListener(Event.UNLOAD, this.dispatchEvent);
			this._loader.addEventListener(ProgressEvent.PROGRESS, this.dispatchEvent);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._loader.addEventListener(IOErrorEvent.DISK_ERROR, this.dispatchEvent);
			this._loader.addEventListener(IOErrorEvent.NETWORK_ERROR, this.dispatchEvent);
			this._loader.addEventListener(IOErrorEvent.VERIFY_ERROR, this.dispatchEvent);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.dispatchEvent);
			this.addChild(this._loader);
			
			// init
			this.clipping = clipping;
			
			this._preloaderMode = preloaderMode;
			if (preloader) this.preloader = preloader;
			if (url)
			{
				if(url is ByteArray)
				{
					this.loadBytes(url);
				}
				else if(url is String)
				{
					this.load(url, context);
				}
				else
				{
					this.logError("Unknown url type. url: " + url + " type: " + typeof(url));
				}
			}
		}
		
		/**
		 * @param url The url of the image to load
		 * @param context Used for securety settings
		 */
		public function load(url:String, context:LoaderContext = null):void
		{
			if (this._debug) this.logDebug("load: " + url);
			this._loader.load(new URLRequest(url), !context && this._context ? this._context : context);
		}
		
		/**
		 * @param url The date of the image to load
		 * @param context Used for securety settings
		 */
		public function loadBytes(image:ByteArray, context:LoaderContext = null):void
		{
			this._loader.loadBytes(image, !context && this._context ? this._context : context);
		}

		/**
		 * Unloads the current loaded image
		 */
		public function unload():void 
		{
			this._loader.unload();
		}
		
		/**
		 * Get or set the IPreloader.
		 * Use a DisplayObject that implements the IPreloader interface.
		 * If preloaderMode is set to PreloaderMode.OWN_PRELOADER, the preloader is addChilded in the ImageLoder
		 * and centered in the width-height-rectangle.
		 */
		public function get preloader():IPreloader
		{
			return this._loader.preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._loader.preloader = value;
		}
		
		/**
		 * Get or set the preloaderMode using a constant from the PreloaderMode class.
		 * <p>Indicates how the ImageLoader uses the preloader. When set to PreloaderMode.OWN_PRELOADER it addChilds and centers the preloader.</p>
		 */
		public function get preloaderMode():String
		{
			return this._preloaderMode;
		}
		
		/**
		 * @private
		 */
		public function set preloaderMode(value:String):void
		{
			this._preloaderMode = value;
		}
		
		/**
		 *	change image size
		 *	
		 *	@param width new width of the image
		 *	@param height new height of the image
		 *	@param fillcolor the color to fill up the background, use NaN for no bckground
		 */
		public function resize(width:Number, height:Number, fillcolor:Number = 0x000000):void 
		{
			this._width = width;
			this._height = height;
			
			if(!isNaN(fillcolor))
			{
				this.graphics.clear();
				this.graphics.beginFill(fillcolor);
				this.graphics.drawRect(0, 0, width, height);
				this.graphics.endFill();
			}
			this.layoutImage();
		}
		
		/**
		 * @param width The width of the image container (is masked and fitted)
		 */
		override public function get width():Number
		{
			return this._clipping && !isNaN(this._width) ? this._width : super.width;
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this._width = value;
			this.layoutImage();
		}
		
		/**
		 * @param height The height of the image container (is masked and fitted)
		 */
		override public function get height():Number
		{
			return this._clipping && !isNaN(this._height) ? this._height : super.height;
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			this._height = value;
			this.layoutImage();
		}
		
		/**
		 * @param scaleMode The scaleMode for fitting the image (use ScaleMode class as values)
		 */
		public function get scaleMode():String
		{
			return this._scaleMode;
		}

		/**
		 * @private
		 */
		[Inspectable(name="ScaleMode", type="String", defaultValue="noScale", enumeration="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(value:String):void
		{
			this._scaleMode = value;
			
			this.layoutImage();
		}
		
		/**
		 * @param align The align mode for the image in the clipped area (use Align class as values)
		 */
		public function get align():String
		{
			return this._align;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Align", type="String", defaultValue="none", enumeration="none,left,center,right,top,middle,bottom,topLeft,topRight,bottomLeft,bottomRight")]
		public function set align(value:String):void
		{
			this._align = value;
			
			this.layoutImage();
		}
		
		/**
		 * Use clipping (mask) so only the content in width-height-rectangle are shown
		 */
		public function get clipping():Boolean
		{
			return this._clipping;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Clipping", type="Boolean", defaultValue="true")]
		public function set clipping(value:Boolean):void
		{
			this._clipping = value;
			
			this.layoutImage();
			this.layoutPreloader();
		}
		
		/**
		 * If an image is loaded, set smoothing property on the Bitmap after loading
		 */
		public function get smoothing():Boolean
		{
			return this._smoothing;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Smooting", type="Boolean", defaultValue="false")]
		public function set smoothing(value:Boolean):void
		{
			this._smoothing = value;
			if (this.content is Bitmap) Bitmap(this.content).smoothing = this._smoothing;
		}
		
		/**
		 * @return the url that is loaded
		 */
		public function get url():String
		{
			return this._loader ? this._loader.url : 'error getting url';
		}
		
		/**
		 *	returns the BitmapData of the loaded image
		 */
		public function get bitmapData():BitmapData 
		{
			return this.content ? Bitmap(this.content).bitmapData : null;
		}
		
		/**
		 *	returns the original image as JPG encoded ByteArray
		 *	@param quality encoding quality
		 */
		public function getDataAsJPG(quality:Number = 50):ByteArray 
		{
			if (!this.isLoaded()) return null;
			
			return new JPGEncoder(quality).encode(Bitmap(this.content).bitmapData);
		}
		
		/**
		 *	returns the original image as PNG encoded ByteArray
		 */
		public function getDataAsPNG():ByteArray 
		{
			if (!this.isLoaded()) return null;
			
			return PNGEncoder.encode(Bitmap(this.content).bitmapData);
		}
		
		/**
		 *	returns the clipped image as JPG encoded ByteArray
		 *	@param quality encoding quality
		 */
		public function getClippedDataAsJPG(quality:Number = 50):ByteArray 
		{
			if (!this.isLoaded()) return null;
			
			var bmd:BitmapData = new BitmapData(this.width, this.height, true, 0x00FFFFFF);
			bmd.draw(this);
			
			return new JPGEncoder(quality).encode(bmd);
		}
		
		/**
		 *	returns the clipped image as PNG encoded ByteArray
		 */
		public function getClippedDataAsPNG():ByteArray 
		{
			if (!this.isLoaded()) return null;
			
			var bmd:BitmapData = new BitmapData(this.width, this.height, true, 0x00FFFFFF);
			bmd.draw(this);
			
			return PNGEncoder.encode(bmd);
		}

		/**
		 * Returns the content of the Loader
		 */
		public function get content():DisplayObject
		{
			if (!this.isLoaded()) return null;
			
			var content:DisplayObject;
			
			try
			{
				 content = this._loader.content;
			}
			catch (error:SecurityError)
			{
				this.logError("No crossdomain! : " + error.getStackTrace());
			}
			return content;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoading():Boolean
		{
			return this._loader.isLoading();
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoaded():Boolean
		{
			return this._loader.isLoaded();
		}
		
		/**
		 * Returns a reference of the Loader
		 */
		public function get loader():CacheLoader
		{
			return this._loader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return this._loader.cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			this._loader.cache = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		private function handleLoadStart(event:Event):void
		{
			this.layoutPreloader();
			this.dispatchEvent(event);
		}

		private function handleLoadComplete(event:Event):void
		{
			if (this._debug) this.logDebug("handleLoadComplete");
			
			if (this._smoothing && this.content is Bitmap) Bitmap(this.content).smoothing = true;
			
			this.layoutImage();
			
			this.dispatchEvent(event);
		}

		/**
		 * PRIVATE METHODS
		 */

		private function layoutImage():void
		{
			if (!this._loader.isLoaded()) return;
			
			if (this._clipping)
			{
				this.scrollRect = new Rectangle(0, 0, this.width, this.height);
			}
			else
			{
				this.scrollRect = null;
			}
			
			if (isNaN(this._width)) this._width = this._loader.width;
			if (isNaN(this._height)) this._height = this._loader.height;
			
			// calculate scale ratios
			var ratioX:Number = this._width / (this._loader.width * (1 / this._loader.scaleX));
			var ratioY:Number = this._height / (this._loader.height * (1 / this._loader.scaleY));
			
			// scale
			switch(this._scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					this._loader.width = this._width;
					this._loader.height = this._height;
					
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					this._loader.scaleX = this._loader.scaleY = ratioX < ratioY ? ratioX : ratioY;
					
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					this._loader.scaleX = this._loader.scaleY = ratioX > ratioY ? ratioX : ratioY;
					
					break;
				}
				default:
				{
					// don't scale
					break;
				}
			}
			
			// align
			if (this._scaleMode != ScaleMode.EXACT_FIT)
			{
				// align horizontal
				switch(this._align)
				{
					case Align.TOP_LEFT:
					case Align.LEFT:
					case Align.BOTTOM_LEFT:
					{
						// do nothing
						
						break;
					}
					
					case Align.TOP_RIGHT:
					case Align.RIGHT:
					case Align.BOTTOM_RIGHT:
					{
						this._loader.x = (this._width - this._loader.width);
						
						break;
					}
					
					case Align.TOP:
					case Align.BOTTOM:
					default:
					{
						this._loader.x = (this._width - this._loader.width) / 2;
						
						break;
					}
				}
				
				// align vertical
				switch(this._align)
				{
					case Align.TOP_LEFT:
					case Align.TOP:
					case Align.TOP_RIGHT:
					{
						// do nothing
						
						break;
					}
					
					case Align.BOTTOM_LEFT:
					case Align.BOTTOM:
					case Align.BOTTOM_RIGHT:
					{
						this._loader.y = (this._height - this._loader.height);
						
						break;
					}
					
					case Align.LEFT:
					case Align.RIGHT:
					default:
					{
						this._loader.y = (this._height - this._loader.height) / 2;
						
						break;
					}
				}
			}
			if (this._loader.isLoading()) this.layoutPreloader();
			
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function layoutPreloader():void
		{
			if (this._loader.preloader && this._loader.preloader is DisplayObject)
			{
				if (this._preloaderMode == PreloaderMode.OWN_PRELOADER && this._loader.preloader.parent != this)
				{
					this.addChild(this._loader.preloader as DisplayObject);
				}
				
				if (this._clipping && this._loader.preloader.parent == this)
				{
					this._loader.preloader.x = (this._width - this._loader.preloader.width) * 0.5;
					this._loader.preloader.y = (this._height - this._loader.preloader.height) * 0.5;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + (this.url ? ' (url="' + this.url + '")' : '');
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._loader)
			{
				this._loader.destruct();
				this._loader = null;
			}
			this._scaleMode = null;
			this._align = null;
			
			super.destruct();
		}
	}
}
