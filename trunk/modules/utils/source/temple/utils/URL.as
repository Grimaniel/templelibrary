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
	import flash.net.URLVariables;
	
	/**
	 * Class for easy creating and manipulating URLs.
	 * 
	 * Syntax:
	 * 
	 * <code>protocol:(//)domain(|port)/path?query#hash</code>
	 * 
	 * or
	 * 
	 * <code>protocol:username:password(at)domain(|port)/path?query#hash</code>
	 * 
	 * @see http://en.wikipedia.org/wiki/Uniform_resource_locator
	 * 
	 * @includeExample URLExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class URL
	{
		/**
		 * Hypertext Transfer Protocol
		 */
		public static const HTTP:String = "http";
		
		/**
		 * HTTP Secure
		 */
		public static const HTTPS:String = "https";
		
		/**
		 * File Transfer Protocol
		 */
		public static const FTP:String = "ftp";
		
		/**
		 * Secure File Transfer Protocol 
		 */
		public static const SFTP:String = "sftp";
		
		/**
		 * Local file
		 */
		public static const FILE:String = "file";
		
		/**
		 * URLs of this form are intended to be used to open the new message window of the user's email client when the
		 * URL is activated, with the address as defined by the URL in the "To:" field.
		 */
		public static const MAILTO:String = "mailto";

		private var _protocol:String;
		private var _domain:String;
		private var _port:uint;
		private var _path:String;
		private var _variables:URLVariables;
		private var _hashList:Vector.<String>;
		private var _username:String;
		private var _password:String;

		public function URL(href:String = null)
		{
			if (href) this.href = href;
		}

		/**
		 * The full string of the URL
		 */
		public function get href():String
		{
			if (_protocol == URL.MAILTO)
			{
				return scheme + email;
			}
			
			var href:String = scheme || "";
			var auth:String = authentication;
			if (auth)
			{
				href += auth + "@";
			}
			if (_domain) href += _domain;
			if (_port) href += ":" + _port;
			if (_path) href += _path;
			
			var query:String = query;
			if (query) href += "?" + query;
			if (_hashList) href += "#" + hash;
			
			return href;
		}

		/**
		 * @private
		 */
		public function set href(value:String):void
		{
			_protocol = null; 
			_domain = null;   
			_port = 0;       
			_path = null;     
			_variables = null;
			_hashList = null;
			_username = null;
			_password = null;
			
			if (value)
			{
				var temp:Array = value.split('#');
				hash = temp[1];
				
				temp = String(temp[0]).split('?');
				query = temp[1];
				
				var href:String = temp[0];
				
				if (href.indexOf(":") != -1)
				{
					_protocol = href.split(":")[0];
				}
				
				if (_protocol)
				{
					href = href.substr(_protocol.length + 1);
					if (href.substr(0, 2) == "//") href = href.substr(2);
				}
				
				if (_protocol == URL.MAILTO)
				{
					email = href;
				}
				else if (_protocol)
				{
					var slash:int = href.indexOf("/");
					if (slash != -1)
					{
						_domain = href.substr(0, slash);
						_path = href.substr(slash);
					}
					else
					{
						_domain = href;
						_path = null;
					}
					if (_domain.indexOf("@") != -1)
					{
						temp = _domain.split("@");
						authentication = temp[0];
						_domain = temp[1];
					}
					if (_domain.indexOf(":") != -1)
					{
						temp = _domain.split(":");
						_domain = temp[0];
						_port = temp[1];
					}
				}
				else
				{
					_domain = null;
					_path = href || null;
					_port = 0;
				}
			} 
		}

		/**
		 * The protocol of the URL
		 * 
		 * @example
		 * <listing version="3.0">
		 * http
		 * ftp
		 * https
		 * mailto
		 * </listing>
		 */
		public function get protocol():String
		{
			return _protocol;
		}

		/**
		 * @private
		 */
		public function set protocol(value:String):void
		{
			_protocol = value;
		}

		/**
		 * Set the protocol of the URL
		 */
		public function setProtocol(value:String):URL
		{
			_protocol = value;
			return this;
		}

		/**
		 * Domain of the URL
		 */
		public function get domain():String
		{
			return _domain;
		}

		/**
		 * @private
		 */
		public function set domain(value:String):void
		{
			_domain = value;
		}

		/**
		 * Set the domain of the URL
		 */
		public function setDomain(value:String):URL
		{
			_domain = value;
			return this;
		}

		/**
		 * The port of the URL.
		 * 
		 * 0 means no port.
		 */
		public function get port():uint
		{
			return _port;
		}

		/**
		 * @private
		 */
		public function set port(value:uint):void
		{
			_port = value;
		}

		/**
		 * Set the port of the URL.
		 */
		public function setPort(value:uint):URL
		{
			_port = value;
			return this;
		}
		
		/**
		 * The path of the URL
		 */
		public function get path():String
		{
			return _path;
		}

		/**
		 * @private
		 */
		public function set path(value:String):void
		{
			_path = value;
		}

		/**
		 * The variables of the URL.
		 */
		public function get variables():URLVariables
		{
			return _variables;
		}

		/**
		 * @private
		 */
		public function set variables(value:URLVariables):void
		{
			_variables = value;
		}

		/**
		 * Checks if the URL has a variable
		 */
		public function hasVariable(name:String):Boolean
		{
			return _variables && _variables.hasOwnProperty(name);
		}

		/**
		 * Get a variable of the URL.
		 */
		public function getVariable(name:String):*
		{
			return _variables ? _variables[name] : null;
		}

		/**
		 * Set a variable on the URL.
		 */
		public function setVariable(name:String, value:*):URL
		{
			if (!_variables) _variables = new URLVariables();
			_variables[name] = value;
			
			return this;
		}
		
		/**
		 * Removes a variable from the URL
		 */
		public function deleteVariable(name:String):void
		{
			delete _variables[name];
		}

		/**
		 * Name/value paired string, which comes after the question sign ('?').
		 * 
		 * @example
		 * <listing version="3.0">
		 * http://www.domain.com/index.html?lorem=ipsum&amp;dolor=sit&amp;amet=consectetur
		 * </listing>
		 */
		public function get query():String
		{
			return _variables ? _variables.toString() : null;
		}

		/**
		 * @private
		 */
		public function set query(value:String):void
		{
			if (!value)
			{
				_variables = null;
			}
			else
			{
				try
				{
					if (_variables)
					{
						_variables.decode(value);
					}
					else
					{
						_variables = new URLVariables(value);
					}
				}
				catch (error:Error)
				{
					// ignore
				}
			}
		}

		/**
		 * The value after the hash (#)
		 * 
		 * @example
		 * <listing version="3.0">
		 * #hash
		 * </listing>
		 */
		public function get hash():String
		{
			var length:uint = _hashList ? _hashList.length : 0;
			
			if (!length)
			{
				return null;
			}
			else if (length == 1)
			{
				return _hashList[0];
			}
			else
			{
				var hash:String = "";
				for (var i:int = 0; i < length; i++)
				{
					hash += "/" + (_hashList[i] || "-");
				}
				return hash;
			}
		}

		/**
		 * @private
		 */
		public function set hash(value:String):void
		{
			if (value)
			{
				if (value.charAt() == "/") value = value.substr(1);
				_hashList = Vector.<String>(value.split("/"));
			}
			else
			{
				_hashList;
			}
		}

		/**
		 * Set the hash of the URL
		 */
		public function setHash(value:String):URL
		{
			hash = value;
			return this;
		}
		
		/**
		 * List of the elements of the hash (splitted by '/')
		 */
		public function get hashList():Vector.<String>
		{
			return _hashList;
		}

		/**
		 * Returns a part of the hash
		 */
		public function getHashPart(index:uint):String
		{
			return index < _hashList.length ? _hashList[index] : null;
		}

		/**
		 * Set one part of the hash
		 */
		public function setHashPart(index:uint, value:String):URL
		{
			_hashList ||= new Vector.<String>(index + 1);
			
			if (index >= _hashList.length)
			{
				_hashList.length = index + 1;
			}
			_hashList[index] = value;
			
			return this;
		}


		/**
		 * A Boolean which indicates if this is an absolute URL
		 * 
		 * @example
		 * <listing version="3.0">
		 * http://www.domain.com/index.html
		 * </listing>
		 */
		public function get isAbsolute():Boolean
		{
			return _protocol != null;
		}

		/**
		 * A Boolean which indicates if this is a relative URL
		 * 
		 * @example
		 * <listing version="3.0">
		 * /index.html#value/1
		 * </listing>
		 */
		public function get isRelative():Boolean
		{
			return _protocol == null;
		}

		/**
		 * A Boolean which indicates if this is a secure URL.
		 * 
		 * Only https and sftp are secure.
		 */
		public function get isSecure():Boolean
		{
			return _protocol == URL.HTTPS || _protocol == URL.SFTP;
		}

		/**
		 * The postfix for a URL, including protocol, : and (if needed) slashes.
		 * 
		 * @example
		 * <listing version="3.0">
		 * http://
		 * ftp://
		 * mailto:
		 * </listing>
		 */
		public function get scheme():String
		{
			switch (_protocol)
			{
				case null:
					return null;
				
				case URL.HTTP:
				case URL.HTTPS:
				case URL.FTP:
				case URL.SFTP:
				case URL.FILE:
					return _protocol + "://";

				case URL.MAILTO:
				default:
					return _protocol + ":";
			}
		}
		
		/**
		 * @private
		 */
		public function set scheme(value:String):void
		{
			_protocol = value ? value.split(":")[0] : null;
		}

		public function get username():String
		{
			return _username;
		}

		/**
		 * @private
		 */
		public function set username(value:String):void
		{
			_username = value;
		}

		public function get password():String
		{
			return _password;
		}

		/**
		 * @private
		 */
		public function set password(value:String):void
		{
			_password = value;
		}

		/**
		 * Authentication for FTP as {username}:{password}
		 * 
		 * @example
		 * <listing version="3.0">
		 * thijs:AbCdE
		 * </listing>
		 */
		public function get authentication():String
		{
			if (_protocol != URL.MAILTO && _username)
			{
				if (_password)
				{
					return _username + ":" + _password;
				}
				else
				{
					return _username;
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		public function set authentication(value:String):void
		{
			if (value)
			{
				var a:Array = value.split(":");
				_username = a[0];
				_password = a[1];
			}
			else
			{
				_username = null;
				_password = null;
			}
		}
		
		/**
		 * The email address of a mailto link.
		 * 
		 * @example
		 * <listing version="3.0">
		 * mailto:thijs[at]mediamonks.com
		 * </listing>
		 */
		public function get email():String
		{
			return _protocol == URL.MAILTO && _username && _domain ? _username + "@" + _domain : null;
		}

		/**
		 * @private
		 */
		public function set email(value:String):void
		{
			_protocol = URL.MAILTO;
			if (value)
			{
				var temp:Array = value.split("@"); 
				_username = temp[0];
				_domain = temp[1];
			}
		}

		public function toString():String
		{
			return href;
		}
	}
}