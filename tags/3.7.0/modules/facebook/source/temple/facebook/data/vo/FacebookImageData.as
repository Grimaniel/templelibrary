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

package temple.facebook.data.vo
{
	import temple.core.CoreObject;
	import temple.facebook.data.facebook;

	/**
	 * @private
	 * 
	 * @author Thijs Broerse
	 */
	public class FacebookImageData extends CoreObject implements IFacebookImageData
	{
		facebook var source:String;
		facebook var width:Number;
		facebook var height:Number;
		
		facebook var photo:IFacebookPhotoData;
		
		public function FacebookImageData()
		{
			super();
			toStringProps.push("source", "width", "height");
		}
		
		/**
		 * @inheritDoc
		 */
		public function get source():String
		{
			return facebook::source;
		}

		/**
		 * @private
		 */
		public function set source(value:String):void
		{
			facebook::source = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return facebook::width;
		}
		
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			facebook::width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return facebook::height;
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			facebook::height = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get photo():IFacebookPhotoData
		{
			return facebook::photo;
		}
		
		/**
		 * @private
		 */
		public function set photo(value:IFacebookPhotoData):void
		{
			facebook::photo = value;
		}
	}
}
