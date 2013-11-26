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

package temple.ui 
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.common.interfaces.IHasBackground;
	import temple.core.debug.IDebuggable;
	import temple.core.display.CoreSprite;
	import temple.core.net.ILoader;
	import temple.data.cache.CacheLoader;
	import temple.data.cache.ICacheable;

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
	 * 	<listing version="3.0" >var imageLoaderExample:ImageLoader = new ImageLoader("image.jpg", 100, 200, ScaleMode.NO_SCALE, null, true);</listing>
	 * 	
	 * 	Load the image with a preloader 	
	 * 	<listing version="3.0" >var imageLoaderExample:ImageLoader = new ImageLoader(null, 100, 200, ScaleMode.NO_SCALE, null, true);
imageLoaderExample.load("image.jpg");</listing>
	 * 	
	 * 	Load the image from a ByteArray
	 * 	<listing version="3.0">var imageLoaderExample:ImageLoader = new ImageLoader(pngByteArray, 100, 200, ScaleMode.NO_SCALE, null, true);</listing>
	 * 
	 * @includeExample ImageLoaderExample.as
	 * @includeExample ImageLoaderScaleModeExample.as
	 * 
	 * @author Arjan van Wijk, Thijs Broerse
	 */
	public class ImageLoader extends CoreSprite implements ILoader, IDebuggable, ICacheable, IHasBackground
	{
		private var _loader:CacheLoader;
		private var _width:Number;
		private var _height:Number;
		private var _clipping:Boolean;
		private var _scaleMode:String;
		private var _align:String;
		private var _upscaleEnabled:Boolean = true;
		private var _smoothing:Boolean;
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
		 * @param loaderContext
		 */
		public function ImageLoader(url:* = null, width:Number = NaN, height:Number = NaN, scaleMode:String = 'noScale', align:String = null, clipping:Boolean = true, smoothing:Boolean = false, loaderContext:LoaderContext = null, cache:Boolean = false)
		{
			toStringProps.push('url');
			_width = !isNaN(width) ? width : (super.width ? super.width : NaN);
			_height = !isNaN(height) ? height : (super.height ? super.height : NaN);
			 
			_scaleMode = scaleMode;
			_align = align;
			_smoothing = smoothing;
			
			_loaderContext = loaderContext;
			
			// loader
			_loader = new CacheLoader(true, cache);
			_loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			_loader.addEventListener(Event.OPEN, handleLoadStart);
			_loader.addEventListener(Event.INIT, dispatchEvent);
			_loader.addEventListener(Event.UNLOAD, dispatchEvent);
			_loader.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.DISK_ERROR, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, dispatchEvent);
			_loader.addEventListener(IOErrorEvent.VERIFY_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, dispatchEvent);
			addChild(_loader);
			
			// init
			this.clipping = clipping;
			
			if (url)
			{
				if (url is ByteArray)
				{
					loadBytes(url);
				}
				else if (url is String)
				{
					load(url, loaderContext);
				}
				else
				{
					logError("Unknown url type. url: " + url + " type: " + typeof(url));
				}
			}
		}

		/**
		 * @param url The url of the image to load
		 * @param context Used for securety settings
		 */
		public function load(url:String, context:LoaderContext = null):void
		{
			if (_debug) logDebug("load: '" + url + "' context: " + context);
			_loader.load(new URLRequest(url), !context && _loaderContext ? _loaderContext : context);
		}
		
		/**
		 * @param url The date of the image to load
		 * @param context Used for securety settings
		 */
		public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			if (_loaderContext) _loaderContext.checkPolicyFile = false;
			_loader.loadBytes(bytes, !context && _loaderContext ? _loaderContext : context);
		}
		
		/**
		 * Cancels a load() method operation that is currently in progress for the Loader instance.
		 */
		public function close():void 
		{
			_loader.close();
		}

		/**
		 * Unloads the current loaded image.
		 */
		public function unload():void 
		{
			_loader.unload();
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
			_width = width;
			_height = height;
			layoutImage();
		}
		
		/**
		 * The width of the image container (is masked and fitted)
		 */
		override public function get width():Number
		{
			return _clipping && !isNaN(_width) ? _width : super.width;
		}

		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			_width = value;
			layoutImage();
		}
		
		/**
		 * The height of the image container (is masked and fitted)
		 */
		override public function get height():Number
		{
			return _clipping && !isNaN(_height) ? _height : super.height;
		}

		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			_height = value;
			layoutImage();
		}
		
		/**
		 * The scaleMode for fitting the image (use ScaleMode class as values)
		 */
		public function get scaleMode():String
		{
			return _scaleMode;
		}

		/**
		 * @private
		 */
		[Inspectable(name="ScaleMode", type="String", defaultValue="noScale", enumeration="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(value:String):void
		{
			_scaleMode = value;
			
			layoutImage();
		}
		
		/**
		 * The align mode for the image in the clipped area (use Align class as values)
		 */
		public function get align():String
		{
			return _align;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Align", type="String", defaultValue="none", enumeration="none,left,center,right,top,middle,bottom,topLeft,topRight,bottomLeft,bottomRight")]
		public function set align(value:String):void
		{
			_align = value;
			
			layoutImage();
		}
		
		/**
		 * When you set the scaleMode to a property other than NO_SCALE, and clipping mode is enabled, every image is scaled.
		 * When you set upscaleEnabled to false, images that are smaller than the clippingRect are not scaled.
		 * @default true
		 */
		public function get upscaleEnabled():Boolean
		{
			return _upscaleEnabled;
		}

		/**
		 * @private
		 */
		public function set upscaleEnabled(value:Boolean):void
		{
			_upscaleEnabled = value;
		}
		
		/**
		 * Use clipping (mask) so only the content in width-height-rectangle are shown
		 */
		public function get clipping():Boolean
		{
			return _clipping;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Clipping", type="Boolean", defaultValue="true")]
		public function set clipping(value:Boolean):void
		{
			_clipping = value;
			
			layoutImage();
		}
		
		/**
		 * If an image is loaded, set smoothing property on the Bitmap after loading
		 */
		public function get smoothing():Boolean
		{
			return _smoothing;
		}

		/**
		 * @private
		 */
		[Inspectable(name="Smooting", type="Boolean", defaultValue="false")]
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			if (content is Bitmap) Bitmap(content).smoothing = _smoothing;
		}
		
		/**
		 * @return the url that is loaded
		 */
		public function get url():String
		{
			return _loader ? _loader.url : 'error getting url';
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
			return content as Bitmap;
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
			return content && content is Bitmap ? Bitmap(content).bitmapData : null;
		}
		
		/**
		 * Returns the content of the Loader
		 */
		public function get content():DisplayObject
		{
			if (!isLoaded) return null;
			
			var content:DisplayObject;
			
			try
			{
				 content = _loader.content;
			}
			catch (error:SecurityError)
			{
				logError("No crossdomain! : " + error.getStackTrace());
			}
			return content;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _loader.isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _loader.isLoaded;
		}
		
		/**
		 * Returns a reference of the Loader
		 */
		public function get loader():CacheLoader
		{
			return _loader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get cache():Boolean
		{
			return _loader.cache;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set cache(value:Boolean):void
		{
			_loader.cache = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get background():Boolean
		{
			return _background;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set background(value:Boolean):void
		{
			_background = value;
			setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			setBackground();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			setBackground();
		}
		
		/**
		 * LoaderContext for loading the images
		 */
		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}

		/**
		 * @private
		 */
		public function set loaderContext(value:LoaderContext):void
		{
			_loaderContext = value;
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

		private function handleLoadStart(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function handleLoadComplete(event:Event):void
		{
			if (_debug) logDebug("handleLoadComplete");
			
			if (_smoothing && content is Bitmap) Bitmap(content).smoothing = true;
			
			layoutImage();
			
			dispatchEvent(event);
		}

		private function layoutImage():void
		{
			if (!_loader || !_loader.isLoaded) return;
			
			if (debug) logDebug("layoutImage: clipping=" + _clipping + ", scaleMode='" + _scaleMode + "', align='" + _align + "', upscaleEnabled:" + _upscaleEnabled);
			
			if (_clipping)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
			else
			{
				scrollRect = null;
			}
			
			if (isNaN(_width)) _width = _loader.width;
			if (isNaN(_height)) _height = _loader.height;
			
			// calculate scale ratios
			var ratioX:Number = _width / (_loader.width * (1 / _loader.scaleX));
			var ratioY:Number = _height / (_loader.height * (1 / _loader.scaleY));
			var scale:Number;
			
			// scale
			switch (_scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					_loader.width = _width;
					_loader.height = _height;
					
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					scale = Math.min(ratioX, ratioY);
					_loader.scaleX = _loader.scaleY = _upscaleEnabled ? scale : Math.min(1, scale);
					
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					scale = Math.max(ratioX, ratioY);
					_loader.scaleX = _loader.scaleY = _upscaleEnabled ? scale : Math.min(1, scale);
					
					break;
				}
				default:
				{
					// don't scale
					break;
				}
			}
			
			// align
			if (_scaleMode != ScaleMode.EXACT_FIT)
			{
				// align horizontal
				switch (_align)
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
						_loader.x = (_width - _loader.width);
						
						break;
					}
					
					case Align.TOP:
					case Align.BOTTOM:
					default:
					{
						_loader.x = (_width - _loader.width) * .5;
						
						break;
					}
				}
				
				// align vertical
				switch (_align)
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
						_loader.y = (_height - _loader.height);
						
						break;
					}
					
					case Align.LEFT:
					case Align.RIGHT:
					default:
					{
						_loader.y = (_height - _loader.height) * .5;
						
						break;
					}
				}
			}
			setBackground();
			
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function setBackground():void 
		{
			graphics.clear();
			if (_background)
			{
				graphics.beginFill(_backgroundColor, _backgroundAlpha);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_loader)
			{
				_loader.destruct();
				_loader = null;
			}
			_scaleMode = null;
			_align = null;
			_loaderContext = null;
			
			super.destruct();
		}
	}
}
