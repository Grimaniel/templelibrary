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

package temple.media.image 
{
	import temple.core.CoreSprite;
	import temple.data.loader.ILoader;
	import temple.data.loader.cache.CacheLoader;
	import temple.data.loader.cache.ICacheable;
	import temple.data.loader.preload.IPreloadable;
	import temple.data.loader.preload.IPreloader;
	import temple.data.loader.preload.PreloaderMode;
	import temple.debug.IDebuggable;
	import temple.ui.IHasBackground;
	import temple.ui.layout.Align;
	import temple.ui.layout.ScaleMode;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
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
	public class ImageLoader extends CoreSprite implements ILoader, IDebuggable, ICacheable, IPreloadable, IHasBackground
	{
		private var _loader:CacheLoader;
		private var _width:Number;
		private var _height:Number;
		private var _clipping:Boolean;
		private var _scaleMode:String;
		private var _align:String;
		private var _upscaleEnabled:Boolean = true;
		private var _smoothing:Boolean;
		private var _preloader:IPreloader;
		private var _preloaderMode:String;
		private var _background:Boolean;
		private var _backgroundColor:uint;
		private var _backgroundAlpha:Number = 1;
		private var _debug:Boolean;
		private var _loaderContext:LoaderContext;

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
		 * @param loaderContext
		 */
		public function ImageLoader(url:* = null, width:Number = NaN, height:Number = NaN, scaleMode:String = 'noScale', align:String = null, clipping:Boolean = true, smoothing:Boolean = false, preloader:IPreloader = null, preloaderMode:String = 'ownPreloader', loaderContext:LoaderContext = null, cache:Boolean = false)
		{
			this.toStringProps.push('name', 'url');
			this._width = !isNaN(width) ? width : (super.width ? super.width : NaN);
			this._height = !isNaN(height) ? height : (super.height ? super.height : NaN);
			 
			this._scaleMode = scaleMode;
			this._align = align;
			this._smoothing = smoothing;
			
			this._loaderContext = loaderContext;
			
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
			
			if (preloader)
			{
				this.preloader = preloader;
			}
			else if (this._preloader)
			{
				this._loader.preloader = this._preloader;
			}
			if (url)
			{
				if (url is ByteArray)
				{
					this.loadBytes(url);
				}
				else if (url is String)
				{
					this.load(url, loaderContext);
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
			if (this._debug) this.logDebug("load: " + url + ' context: ' + context);
			this._loader.load(new URLRequest(url), !context && this._loaderContext ? this._loaderContext : context);
		}
		
		/**
		 * @param url The date of the image to load
		 * @param context Used for securety settings
		 */
		public function loadBytes(image:ByteArray, context:LoaderContext = null):void
		{
			this._loader.loadBytes(image, !context && this._loaderContext ? this._loaderContext : context);
		}
		
		/**
		 * Cancels a load() method operation that is currently in progress for the Loader instance.
		 */
		public function close():void 
		{
			this._loader.close();
		}

		/**
		 * Unloads the current loaded image.
		 */
		public function unload():void 
		{
			this._loader.unload();
		}
		
		/**
		 * Get or set the IPreloader.
		 * Use a DisplayObject that implements the IPreloader interface.
		 * If preloaderMode is set to PreloaderMode.OWN_PRELOADER, the preloader is addChilded in the ImageLoader
		 * and centered in the width-height-rectangle.
		 */
		public function get preloader():IPreloader
		{
			return this._preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloader = value;
			if (this._loader) this._loader.preloader = value;
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
		public function resize(width:Number, height:Number):void 
		{
			this._width = width;
			this._height = height;
			this.layoutImage();
		}
		
		/**
		 * The width of the image container (is masked and fitted)
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
		 * The height of the image container (is masked and fitted)
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
		 * The scaleMode for fitting the image (use ScaleMode class as values)
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
		 * The align mode for the image in the clipped area (use Align class as values)
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
		 * When you set the scaleMode to a property other than NO_SCALE, and clipping mode is enabled, every image is scaled.
		 * When you set upscaleEnabled to false, images that are smaller than the clippingRect are not scaled.
		 * @default true
		 */
		public function get upscaleEnabled():Boolean
		{
			return this._upscaleEnabled;
		}

		/**
		 * @private
		 */
		public function set upscaleEnabled(value:Boolean):void
		{
			this._upscaleEnabled = value;
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
		 *	Returns the Bitmap of the loaded image.
		 *	
		 *	Use the bitmapdata to get the JPG or PNG byteArray of the loaded data:
		 *	new JPGEncoder(quality).encode(imageLoader.bitmapData);
		 *	PNGEncoder.encode(imageLoader.bitmapData);
		 */
		public function get bitmap():Bitmap 
		{
			return this.content as Bitmap;
		}
		
		/**
		 *	Returns the BitmapData of the loaded image.
		 *	
		 *	You can use this to get the JPG or PNG byteArray of th eloaded data:
		 *	new JPGEncoder(quality).encode(imageLoader.bitmapData);
		 *	PNGEncoder.encode(imageLoader.bitmapData);
		 */
		public function get bitmapData():BitmapData 
		{
			return this.content && this.content is Bitmap ? Bitmap(this.content).bitmapData : null;
		}
		
		/**
		 * Returns the content of the Loader
		 */
		public function get content():DisplayObject
		{
			if (!this.isLoaded) return null;
			
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
		public function get isLoading():Boolean
		{
			return this._loader.isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._loader.isLoaded;
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
		public function get background():Boolean
		{
			return this._background;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set background(value:Boolean):void
		{
			this._background = value;
			this.setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundColor(value:uint):void
		{
			this._backgroundColor = value;
			this.setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundAlpha():Number
		{
			return this._backgroundAlpha;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundAlpha(value:Number):void
		{
			this._backgroundAlpha = value;
			this.setBackground();
		}
		
		/**
		 * LoaderContext for loading the images
		 */
		public function get loaderContext():LoaderContext
		{
			return this._loaderContext;
		}

		/**
		 * @private
		 */
		public function set loaderContext(value:LoaderContext):void
		{
			this._loaderContext = value;
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

		protected function handleLoadComplete(event:Event):void
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
			if (!this._loader.isLoaded) return;
			
			if (this.debug) this.logDebug("layoutImage: clipping=" + this._clipping + ", scaleMode='" + this._scaleMode + "', align='" + this._align + "', upscaleEnabled:" + this._upscaleEnabled);
			
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
			var scale:Number;
			
			// scale
			switch (this._scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					this._loader.width = this._width;
					this._loader.height = this._height;
					
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					scale = ratioX < ratioY ? ratioX : ratioY;
					this._loader.scaleX = this._loader.scaleY = this._upscaleEnabled ? scale : Math.min(1, scale);
					
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					scale = ratioX > ratioY ? ratioX : ratioY;
					this._loader.scaleX = this._loader.scaleY = this._upscaleEnabled ? scale : Math.min(1, scale);
					
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
				switch (this._align)
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
				switch (this._align)
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
			if (this._loader.isLoading) this.layoutPreloader();
			
			this.setBackground();
			
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
		
		private function setBackground():void 
		{
			this.graphics.clear();
			if (this._background)
			{
				this.graphics.beginFill(this._backgroundColor, this._backgroundAlpha);
				this.graphics.drawRect(0, 0, this.width, this.height);
				this.graphics.endFill();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._loader)
			{
				this._loader.destruct();
				this._loader = null;
			}
			this._preloader = null;
			this._scaleMode = null;
			this._align = null;
			this._loaderContext = null;
			
			super.destruct();
		}
	}
}
