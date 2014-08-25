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
	import temple.data.index.AbstractIndexable;
	import temple.data.index.Indexer;
	import temple.facebook.data.facebook;

	/**
	 * @author Thijs Broerse
	 */
	internal class FacebookProfileData extends AbstractIndexable implements IFacebookProfileData
	{
		/**
		 * Used by Indexer
		 * @see temple.data.index.Indexer#INDEX_CLASS
		 */
		public static function get indexClass():Class
		{
			return IFacebookProfileData;
		}
		
		facebook var name:String;
		facebook var type:String;
		facebook var start_time:Date;
		facebook var end_time:Date;
		facebook var location:Object;
		facebook var timezone:String;
		facebook var category:String;
		facebook var description:String;
		facebook var url:String;
		facebook var version:String;
		facebook var category_list:Object;
		
		private var _object:IFacebookObjectData;

		public function FacebookProfileData(id:String = null, name:String = null, type:String = null)
		{
			super(null, IFacebookProfileData);
			
			this.id = id;
			facebook::name = name;
			facebook::type = type;
			
			toStringProps.length = 0;
			toStringProps.push("name", "id", "type");
		}
		
		/**
		 * @private
		 */
		[Transient]
		override public final function get indexClass():Class
		{
			return super.indexClass;
		}
		
		public function get name():String
		{
			return object && _object.name ? _object.name : facebook::name;
		}

		public function get type():String
		{
			return facebook::type;
		}

		public function get object():IFacebookObjectData
		{
			return _object ||= id ? Indexer.get(IFacebookObjectData, id) as IFacebookObjectData : null;
		}
	}
}
