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

package temple.facebook.api
{
	import temple.core.CoreObject;
	import temple.facebook.data.vo.FacebookCanvasPageInfoData;
	import temple.facebook.data.vo.IFacebookCanvasPageInfoData;
	import temple.facebook.service.IFacebookService;

	import flash.external.ExternalInterface;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookCanvasAPI extends CoreObject implements IFacebookCanvasAPI
	{
		private var _service:IFacebookService;
		
		private var _callback:Function;
		
		public function FacebookCanvasAPI(service:IFacebookService)
		{
			_service = service;
			
			if (ExternalInterface.available) ExternalInterface.addCallback("setPageInfo", setPageInfo);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get available():Boolean
		{
			return ExternalInterface.available && ExternalInterface.call(<script><![CDATA[function (){ return FB != null; } ]]></script>);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPageInfo(callback:Function):void
		{
			if (available && callback != null)
			{
				_callback = callback;
				
				ExternalInterface.call(
					<script><![CDATA[
						function () {
							return FB.Canvas.getPageInfo(
								function(info) {
									FBAS.getSwf().setPageInfo(info);
								});
						}
					]]></script>);
			}
            else
        	{
                logError("Canvas not available, can't do: getPageInfo()");
            }
		}
		
		private function setPageInfo(info:*):void
		{
			if (info)
			{
				var data:IFacebookCanvasPageInfoData = _service.parser.parse(info, FacebookCanvasPageInfoData) as IFacebookCanvasPageInfoData;
			}
			_callback.call(this, data);
		}

		/**
		 * @inheritDoc
		 */
		public function scrollTo(x:int, y:int):void
		{
			if (available)
			{
				ExternalInterface.call(String(<script><![CDATA[function (x, y){ FB.Canvas.scrollTo(x, y); }]]></script>), x, y);
			}
			else
			{
				logWarn("Canvas not available, can't do: scrollTo(" + x + ", " + y + ")");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function setAutoGrow():void
		{
			if (available)
			{
				ExternalInterface.call(String(<script><![CDATA[function (){ FB.Canvas.setAutoGrow(); } ]]></script>));
			}
			else
			{
				logWarn("Canvas not available, can't do: setAutoGrow()");
			}
		}
		
		/**
         * @inheritDoc
         */
        public function setSize(width:Number = NaN, height:Number = NaN):void
        {
            if (available)
            {
				if (!isNaN(width) || !isNaN(height))
				{
	                var object:Object = {};
	                if (!isNaN(width)) object['width'] = int(width);
	                if (!isNaN(height)) object['height'] = int(height);
				}
                ExternalInterface.call(String(<script><![CDATA[function (object){ FB.Canvas.setSize(object); } ]]></script>), object);
            }
            else
            {
                logWarn("Canvas not available, can't do: setSize()");
            }
        }

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_service = null;
			
			super.destruct();
		}
	}
}
