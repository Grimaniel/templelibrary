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

package temple.utils.iso
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;

	/**
	 * ISO 3166-1 is part of the ISO 3166 standard published by the International Organization for Standardization (ISO),
	 * and defines codes for the names of countries, dependent territories, and special areas of geographical interest. 
	 * 
	 * @author Thijs Broerse
	 */
	public final class Country
	{
		public static const AFGHANISTAN:String = "AF";
		public static const ALAND_ISLANDS:String = "AX";
		public static const ALBANIA:String = "AL";
		public static const ALGERIA:String = "DZ";
		public static const AMERICAN_SAMOA:String = "AS";
		public static const ANDORRA:String = "AD";
		public static const ANGOLA:String = "AO";
		public static const ANGUILLA:String = "AI";
		public static const ANTARCTICA:String = "AQ";
		public static const ANTIGUA_AND_BARBUDA:String = "AG";
		public static const ARGENTINA:String = "AR";
		public static const ARMENIA:String = "AM";
		public static const ARUBA:String = "AW";
		public static const AUSTRALIA:String = "AU";
		public static const AUSTRIA:String = "AT";
		public static const AZERBAIJAN:String = "AZ";
		public static const BAHAMAS:String = "BS";
		public static const BAHRAIN:String = "BH";
		public static const BANGLADESH:String = "BD";
		public static const BARBADOS:String = "BB";
		public static const BELARUS:String = "BY";
		public static const BELGIUM:String = "BE";
		public static const BELIZE:String = "BZ";
		public static const BENIN:String = "BJ";
		public static const BERMUDA:String = "BM";
		public static const BHUTAN:String = "BT";
		public static const BOLIVIA_PLURINATIONAL_STATE_OF:String = "BO";
		public static const BONAIRE_SINT_EUSTATIUS_AND_SABA:String = "BQ";
		public static const BOSNIA_AND_HERZEGOVINA:String = "BA";
		public static const BOTSWANA:String = "BW";
		public static const BOUVET_ISLAND:String = "BV";
		public static const BRAZIL:String = "BR";
		public static const BRITISH_INDIAN_OCEAN_TERRITORY:String = "IO";
		public static const BRUNEI_DARUSSALAM:String = "BN";
		public static const BULGARIA:String = "BG";
		public static const BURKINA_FASO:String = "BF";
		public static const BURUNDI:String = "BI";
		public static const CAMBODIA:String = "KH";
		public static const CAMEROON:String = "CM";
		public static const CANADA:String = "CA";
		public static const CAPE_VERDE:String = "CV";
		public static const CAYMAN_ISLANDS:String = "KY";
		public static const CENTRAL_AFRICAN_REPUBLIC:String = "CF";
		public static const CHAD:String = "TD";
		public static const CHILE:String = "CL";
		public static const CHINA:String = "CN";
		public static const CHRISTMAS_ISLAND:String = "CX";
		public static const COCOS_KEELING_ISLANDS:String = "CC";
		public static const COLOMBIA:String = "CO";
		public static const COMOROS:String = "KM";
		public static const CONGO:String = "CG";
		public static const CONGO_THE_DEMOCRATIC_REPUBLIC_OF_THE:String = "CD";
		public static const COOK_ISLANDS:String = "CK";
		public static const COSTA_RICA:String = "CR";
		public static const COTE_D_IVOIRE:String = "CI";
		public static const CROATIA:String = "HR";
		public static const CUBA:String = "CU";
		public static const CURACAO:String = "CW";
		public static const CYPRUS:String = "CY";
		public static const CZECH_REPUBLIC:String = "CZ";
		public static const DENMARK:String = "DK";
		public static const DJIBOUTI:String = "DJ";
		public static const DOMINICA:String = "DM";
		public static const DOMINICAN_REPUBLIC:String = "DO";
		public static const ECUADOR:String = "EC";
		public static const EGYPT:String = "EG";
		public static const EL_SALVADOR:String = "SV";
		public static const EQUATORIAL_GUINEA:String = "GQ";
		public static const ERITREA:String = "ER";
		public static const ESTONIA:String = "EE";
		public static const ETHIOPIA:String = "ET";
		public static const FALKLAND_ISLANDS_MALVINAS:String = "FK";
		public static const FAROE_ISLANDS:String = "FO";
		public static const FIJI:String = "FJ";
		public static const FINLAND:String = "FI";
		public static const FRANCE:String = "FR";
		public static const FRENCH_GUIANA:String = "GF";
		public static const FRENCH_POLYNESIA:String = "PF";
		public static const FRENCH_SOUTHERN_TERRITORIES:String = "TF";
		public static const GABON:String = "GA";
		public static const GAMBIA:String = "GM";
		public static const GEORGIA:String = "GE";
		public static const GERMANY:String = "DE";
		public static const GHANA:String = "GH";
		public static const GIBRALTAR:String = "GI";
		public static const GREECE:String = "GR";
		public static const GREENLAND:String = "GL";
		public static const GRENADA:String = "GD";
		public static const GUADELOUPE:String = "GP";
		public static const GUAM:String = "GU";
		public static const GUATEMALA:String = "GT";
		public static const GUERNSEY:String = "GG";
		public static const GUINEA:String = "GN";
		public static const GUINEA_BISSAU:String = "GW";
		public static const GUYANA:String = "GY";
		public static const HAITI:String = "HT";
		public static const HEARD_ISLAND_AND_MCDONALD_ISLANDS:String = "HM";
		public static const HOLY_SEE_VATICAN_CITY_STATE:String = "VA";
		public static const HONDURAS:String = "HN";
		public static const HONG_KONG:String = "HK";
		public static const HUNGARY:String = "HU";
		public static const ICELAND:String = "IS";
		public static const INDIA:String = "IN";
		public static const INDONESIA:String = "ID";
		public static const IRAN_ISLAMIC_REPUBLIC_OF:String = "IR";
		public static const IRAQ:String = "IQ";
		public static const IRELAND:String = "IE";
		public static const ISLE_OF_MAN:String = "IM";
		public static const ISRAEL:String = "IL";
		public static const ITALY:String = "IT";
		public static const JAMAICA:String = "JM";
		public static const JAPAN:String = "JP";
		public static const JERSEY:String = "JE";
		public static const JORDAN:String = "JO";
		public static const KAZAKHSTAN:String = "KZ";
		public static const KENYA:String = "KE";
		public static const KIRIBATI:String = "KI";
		public static const KOREA_DEMOCRATIC_PEOPLE_S_REPUBLIC_OF:String = "KP";
		public static const KOREA_REPUBLIC_OF:String = "KR";
		public static const KUWAIT:String = "KW";
		public static const KYRGYZSTAN:String = "KG";
		public static const LAO_PEOPLE_S_DEMOCRATIC_REPUBLIC:String = "LA";
		public static const LATVIA:String = "LV";
		public static const LEBANON:String = "LB";
		public static const LESOTHO:String = "LS";
		public static const LIBERIA:String = "LR";
		public static const LIBYA:String = "LY";
		public static const LIECHTENSTEIN:String = "LI";
		public static const LITHUANIA:String = "LT";
		public static const LUXEMBOURG:String = "LU";
		public static const MACAO:String = "MO";
		public static const MACEDONIA_THE_FORMER_YUGOSLAV_REPUBLIC_OF:String = "MK";
		public static const MADAGASCAR:String = "MG";
		public static const MALAWI:String = "MW";
		public static const MALAYSIA:String = "MY";
		public static const MALDIVES:String = "MV";
		public static const MALI:String = "ML";
		public static const MALTA:String = "MT";
		public static const MARSHALL_ISLANDS:String = "MH";
		public static const MARTINIQUE:String = "MQ";
		public static const MAURITANIA:String = "MR";
		public static const MAURITIUS:String = "MU";
		public static const MAYOTTE:String = "YT";
		public static const MEXICO:String = "MX";
		public static const MICRONESIA_FEDERATED_STATES_OF:String = "FM";
		public static const MOLDOVA_REPUBLIC_OF:String = "MD";
		public static const MONACO:String = "MC";
		public static const MONGOLIA:String = "MN";
		public static const MONTENEGRO:String = "ME";
		public static const MONTSERRAT:String = "MS";
		public static const MOROCCO:String = "MA";
		public static const MOZAMBIQUE:String = "MZ";
		public static const MYANMAR:String = "MM";
		public static const NAMIBIA:String = "NA";
		public static const NAURU:String = "NR";
		public static const NEPAL:String = "NP";
		public static const NETHERLANDS:String = "NL";
		public static const NEW_CALEDONIA:String = "NC";
		public static const NEW_ZEALAND:String = "NZ";
		public static const NICARAGUA:String = "NI";
		public static const NIGER:String = "NE";
		public static const NIGERIA:String = "NG";
		public static const NIUE:String = "NU";
		public static const NORFOLK_ISLAND:String = "NF";
		public static const NORTHERN_MARIANA_ISLANDS:String = "MP";
		public static const NORWAY:String = "NO";
		public static const OMAN:String = "OM";
		public static const PAKISTAN:String = "PK";
		public static const PALAU:String = "PW";
		public static const PALESTINIAN_TERRITORY_OCCUPIED:String = "PS";
		public static const PANAMA:String = "PA";
		public static const PAPUA_NEW_GUINEA:String = "PG";
		public static const PARAGUAY:String = "PY";
		public static const PERU:String = "PE";
		public static const PHILIPPINES:String = "PH";
		public static const PITCAIRN:String = "PN";
		public static const POLAND:String = "PL";
		public static const PORTUGAL:String = "PT";
		public static const PUERTO_RICO:String = "PR";
		public static const QATAR:String = "QA";
		public static const REUNION:String = "RE";
		public static const ROMANIA:String = "RO";
		public static const RUSSIAN_FEDERATION:String = "RU";
		public static const RWANDA:String = "RW";
		public static const SAINT_BARTHELEMY:String = "BL";
		public static const SAINT_HELENA_ASCENSION_AND_TRISTAN_DA_CUNHA:String = "SH";
		public static const SAINT_KITTS_AND_NEVIS:String = "KN";
		public static const SAINT_LUCIA:String = "LC";
		public static const SAINT_MARTIN_FRENCH_PART:String = "MF";
		public static const SAINT_PIERRE_AND_MIQUELON:String = "PM";
		public static const SAINT_VINCENT_AND_THE_GRENADINES:String = "VC";
		public static const SAMOA:String = "WS";
		public static const SAN_MARINO:String = "SM";
		public static const SAO_TOME_AND_PRINCIPE:String = "ST";
		public static const SAUDI_ARABIA:String = "SA";
		public static const SENEGAL:String = "SN";
		public static const SERBIA:String = "RS";
		public static const SEYCHELLES:String = "SC";
		public static const SIERRA_LEONE:String = "SL";
		public static const SINGAPORE:String = "SG";
		public static const SINT_MAARTEN_DUTCH_PART:String = "SX";
		public static const SLOVAKIA:String = "SK";
		public static const SLOVENIA:String = "SI";
		public static const SOLOMON_ISLANDS:String = "SB";
		public static const SOMALIA:String = "SO";
		public static const SOUTH_AFRICA:String = "ZA";
		public static const SOUTH_GEORGIA_AND_THE_SOUTH_SANDWICH_ISLANDS:String = "GS";
		public static const SOUTH_SUDAN:String = "SS";
		public static const SPAIN:String = "ES";
		public static const SRI_LANKA:String = "LK";
		public static const SUDAN:String = "SD";
		public static const SURINAME:String = "SR";
		public static const SVALBARD_AND_JAN_MAYEN:String = "SJ";
		public static const SWAZILAND:String = "SZ";
		public static const SWEDEN:String = "SE";
		public static const SWITZERLAND:String = "CH";
		public static const SYRIAN_ARAB_REPUBLIC:String = "SY";
		public static const TAIWAN_PROVINCE_OF_CHINA:String = "TW";
		public static const TAJIKISTAN:String = "TJ";
		public static const TANZANIA_UNITED_REPUBLIC_OF:String = "TZ";
		public static const THAILAND:String = "TH";
		public static const TIMOR_LESTE:String = "TL";
		public static const TOGO:String = "TG";
		public static const TOKELAU:String = "TK";
		public static const TONGA:String = "TO";
		public static const TRINIDAD_AND_TOBAGO:String = "TT";
		public static const TUNISIA:String = "TN";
		public static const TURKEY:String = "TR";
		public static const TURKMENISTAN:String = "TM";
		public static const TURKS_AND_CAICOS_ISLANDS:String = "TC";
		public static const TUVALU:String = "TV";
		public static const UGANDA:String = "UG";
		public static const UKRAINE:String = "UA";
		public static const UNITED_ARAB_EMIRATES:String = "AE";
		public static const UNITED_KINGDOM:String = "GB";
		public static const UNITED_STATES:String = "US";
		public static const UNITED_STATES_MINOR_OUTLYING_ISLANDS:String = "UM";
		public static const URUGUAY:String = "UY";
		public static const UZBEKISTAN:String = "UZ";
		public static const VANUATU:String = "VU";
		public static const VENEZUELA_BOLIVARIAN_REPUBLIC_OF:String = "VE";
		public static const VIET_NAM:String = "VN";
		public static const VIRGIN_ISLANDS_BRITISH:String = "VG";
		public static const VIRGIN_ISLANDS_US:String = "VI";
		public static const WALLIS_AND_FUTUNA:String = "WF";
		public static const WESTERN_SAHARA:String = "EH";
		public static const YEMEN:String = "YE";
		public static const ZAMBIA:String = "ZM";
		public static const ZIMBABWE:String = "ZW";
		
		/**
		 * Name used in a specific language for a geographical feature situated outside the area where that language is
		 * spoken, and differing in its form from the name used in an official or well-established language of that area
		 * where the geographical feature is located.
		 */
		public static function exonym(country:String):String
		{
			switch (country)
			{
				case Country.AFGHANISTAN : return "Afghanistan";
				case Country.ALAND_ISLANDS : return "Åland Islands";
				case Country.ALBANIA : return "Albania";
				case Country.ALGERIA : return "Algeria";
				case Country.AMERICAN_SAMOA : return "American Samoa";
				case Country.ANDORRA : return "Andorra";
				case Country.ANGOLA : return "Angola";
				case Country.ANGUILLA : return "Anguilla";
				case Country.ANTARCTICA : return "Antarctica";
				case Country.ANTIGUA_AND_BARBUDA : return "Antigua and Barbuda";
				case Country.ARGENTINA : return "Argentina";
				case Country.ARMENIA : return "Armenia";
				case Country.ARUBA : return "Aruba";
				case Country.AUSTRALIA : return "Australia";
				case Country.AUSTRIA : return "Austria";
				case Country.AZERBAIJAN : return "Azerbaijan";
				case Country.BAHAMAS : return "Bahamas";
				case Country.BAHRAIN : return "Bahrain";
				case Country.BANGLADESH : return "Bangladesh";
				case Country.BARBADOS : return "Barbados";
				case Country.BELARUS : return "Belarus";
				case Country.BELGIUM : return "Belgium";
				case Country.BELIZE : return "Belize";
				case Country.BENIN : return "Benin";
				case Country.BERMUDA : return "Bermuda";
				case Country.BHUTAN : return "Bhutan";
				case Country.BOLIVIA_PLURINATIONAL_STATE_OF : return "Bolivia, Plurinational State of";
				case Country.BONAIRE_SINT_EUSTATIUS_AND_SABA : return "Bonaire, Sint Eustatius and Saba";
				case Country.BOSNIA_AND_HERZEGOVINA : return "Bosnia and Herzegovina";
				case Country.BOTSWANA : return "Botswana";
				case Country.BOUVET_ISLAND : return "Bouvet Island";
				case Country.BRAZIL : return "Brazil";
				case Country.BRITISH_INDIAN_OCEAN_TERRITORY : return "British Indian Ocean Territory";
				case Country.BRUNEI_DARUSSALAM : return "Brunei Darussalam";
				case Country.BULGARIA : return "Bulgaria";
				case Country.BURKINA_FASO : return "Burkina Faso";
				case Country.BURUNDI : return "Burundi";
				case Country.CAMBODIA : return "Cambodia";
				case Country.CAMEROON : return "Cameroon";
				case Country.CANADA : return "Canada";
				case Country.CAPE_VERDE : return "Cape Verde";
				case Country.CAYMAN_ISLANDS : return "Cayman Islands";
				case Country.CENTRAL_AFRICAN_REPUBLIC : return "Central African Republic";
				case Country.CHAD : return "Chad";
				case Country.CHILE : return "Chile";
				case Country.CHINA : return "China";
				case Country.CHRISTMAS_ISLAND : return "Christmas Island";
				case Country.COCOS_KEELING_ISLANDS : return "Cocos (Keeling) Islands";
				case Country.COLOMBIA : return "Colombia";
				case Country.COMOROS : return "Comoros";
				case Country.CONGO : return "Congo";
				case Country.CONGO_THE_DEMOCRATIC_REPUBLIC_OF_THE : return "Congo, the Democratic Republic of the";
				case Country.COOK_ISLANDS : return "Cook Islands";
				case Country.COSTA_RICA : return "Costa Rica";
				case Country.COTE_D_IVOIRE : return "Côte d'Ivoire";
				case Country.CROATIA : return "Croatia";
				case Country.CUBA : return "Cuba";
				case Country.CURACAO : return "Curaçao";
				case Country.CYPRUS : return "Cyprus";
				case Country.CZECH_REPUBLIC : return "Czech Republic";
				case Country.DENMARK : return "Denmark";
				case Country.DJIBOUTI : return "Djibouti";
				case Country.DOMINICA : return "Dominica";
				case Country.DOMINICAN_REPUBLIC : return "Dominican Republic";
				case Country.ECUADOR : return "Ecuador";
				case Country.EGYPT : return "Egypt";
				case Country.EL_SALVADOR : return "El Salvador";
				case Country.EQUATORIAL_GUINEA : return "Equatorial Guinea";
				case Country.ERITREA : return "Eritrea";
				case Country.ESTONIA : return "Estonia";
				case Country.ETHIOPIA : return "Ethiopia";
				case Country.FALKLAND_ISLANDS_MALVINAS : return "Falkland Islands (Malvinas)";
				case Country.FAROE_ISLANDS : return "Faroe Islands";
				case Country.FIJI : return "Fiji";
				case Country.FINLAND : return "Finland";
				case Country.FRANCE : return "France";
				case Country.FRENCH_GUIANA : return "French Guiana";
				case Country.FRENCH_POLYNESIA : return "French Polynesia";
				case Country.FRENCH_SOUTHERN_TERRITORIES : return "French Southern Territories";
				case Country.GABON : return "Gabon";
				case Country.GAMBIA : return "Gambia";
				case Country.GEORGIA : return "Georgia";
				case Country.GERMANY : return "Germany";
				case Country.GHANA : return "Ghana";
				case Country.GIBRALTAR : return "Gibraltar";
				case Country.GREECE : return "Greece";
				case Country.GREENLAND : return "Greenland";
				case Country.GRENADA : return "Grenada";
				case Country.GUADELOUPE : return "Guadeloupe";
				case Country.GUAM : return "Guam";
				case Country.GUATEMALA : return "Guatemala";
				case Country.GUERNSEY : return "Guernsey";
				case Country.GUINEA : return "Guinea";
				case Country.GUINEA_BISSAU : return "Guinea-Bissau";
				case Country.GUYANA : return "Guyana";
				case Country.HAITI : return "Haiti";
				case Country.HEARD_ISLAND_AND_MCDONALD_ISLANDS : return "Heard Island and McDonald Islands";
				case Country.HOLY_SEE_VATICAN_CITY_STATE : return "Holy See (Vatican City State)";
				case Country.HONDURAS : return "Honduras";
				case Country.HONG_KONG : return "Hong Kong";
				case Country.HUNGARY : return "Hungary";
				case Country.ICELAND : return "Iceland";
				case Country.INDIA : return "India";
				case Country.INDONESIA : return "Indonesia";
				case Country.IRAN_ISLAMIC_REPUBLIC_OF : return "Iran, Islamic Republic of";
				case Country.IRAQ : return "Iraq";
				case Country.IRELAND : return "Ireland";
				case Country.ISLE_OF_MAN : return "Isle of Man";
				case Country.ISRAEL : return "Israel";
				case Country.ITALY : return "Italy";
				case Country.JAMAICA : return "Jamaica";
				case Country.JAPAN : return "Japan";
				case Country.JERSEY : return "Jersey";
				case Country.JORDAN : return "Jordan";
				case Country.KAZAKHSTAN : return "Kazakhstan";
				case Country.KENYA : return "Kenya";
				case Country.KIRIBATI : return "Kiribati";
				case Country.KOREA_DEMOCRATIC_PEOPLE_S_REPUBLIC_OF : return "Korea, Democratic People's Republic of";
				case Country.KOREA_REPUBLIC_OF : return "Korea, Republic of";
				case Country.KUWAIT : return "Kuwait";
				case Country.KYRGYZSTAN : return "Kyrgyzstan";
				case Country.LAO_PEOPLE_S_DEMOCRATIC_REPUBLIC : return "Lao People's Democratic Republic";
				case Country.LATVIA : return "Latvia";
				case Country.LEBANON : return "Lebanon";
				case Country.LESOTHO : return "Lesotho";
				case Country.LIBERIA : return "Liberia";
				case Country.LIBYA : return "Libya";
				case Country.LIECHTENSTEIN : return "Liechtenstein";
				case Country.LITHUANIA : return "Lithuania";
				case Country.LUXEMBOURG : return "Luxembourg";
				case Country.MACAO : return "Macao";
				case Country.MACEDONIA_THE_FORMER_YUGOSLAV_REPUBLIC_OF : return "Macedonia, the former Yugoslav Republic of";
				case Country.MADAGASCAR : return "Madagascar";
				case Country.MALAWI : return "Malawi";
				case Country.MALAYSIA : return "Malaysia";
				case Country.MALDIVES : return "Maldives";
				case Country.MALI : return "Mali";
				case Country.MALTA : return "Malta";
				case Country.MARSHALL_ISLANDS : return "Marshall Islands";
				case Country.MARTINIQUE : return "Martinique";
				case Country.MAURITANIA : return "Mauritania";
				case Country.MAURITIUS : return "Mauritius";
				case Country.MAYOTTE : return "Mayotte";
				case Country.MEXICO : return "Mexico";
				case Country.MICRONESIA_FEDERATED_STATES_OF : return "Micronesia, Federated States of";
				case Country.MOLDOVA_REPUBLIC_OF : return "Moldova, Republic of";
				case Country.MONACO : return "Monaco";
				case Country.MONGOLIA : return "Mongolia";
				case Country.MONTENEGRO : return "Montenegro";
				case Country.MONTSERRAT : return "Montserrat";
				case Country.MOROCCO : return "Morocco";
				case Country.MOZAMBIQUE : return "Mozambique";
				case Country.MYANMAR : return "Myanmar";
				case Country.NAMIBIA : return "Namibia";
				case Country.NAURU : return "Nauru";
				case Country.NEPAL : return "Nepal";
				case Country.NETHERLANDS : return "Netherlands";
				case Country.NEW_CALEDONIA : return "New Caledonia";
				case Country.NEW_ZEALAND : return "New Zealand";
				case Country.NICARAGUA : return "Nicaragua";
				case Country.NIGER : return "Niger";
				case Country.NIGERIA : return "Nigeria";
				case Country.NIUE : return "Niue";
				case Country.NORFOLK_ISLAND : return "Norfolk Island";
				case Country.NORTHERN_MARIANA_ISLANDS : return "Northern Mariana Islands";
				case Country.NORWAY : return "Norway";
				case Country.OMAN : return "Oman";
				case Country.PAKISTAN : return "Pakistan";
				case Country.PALAU : return "Palau";
				case Country.PALESTINIAN_TERRITORY_OCCUPIED : return "Palestinian Territory, Occupied";
				case Country.PANAMA : return "Panama";
				case Country.PAPUA_NEW_GUINEA : return "Papua New Guinea";
				case Country.PARAGUAY : return "Paraguay";
				case Country.PERU : return "Peru";
				case Country.PHILIPPINES : return "Philippines";
				case Country.PITCAIRN : return "Pitcairn";
				case Country.POLAND : return "Poland";
				case Country.PORTUGAL : return "Portugal";
				case Country.PUERTO_RICO : return "Puerto Rico";
				case Country.QATAR : return "Qatar";
				case Country.REUNION : return "Réunion";
				case Country.ROMANIA : return "Romania";
				case Country.RUSSIAN_FEDERATION : return "Russian Federation";
				case Country.RWANDA : return "Rwanda";
				case Country.SAINT_BARTHELEMY : return "Saint Barthélemy";
				case Country.SAINT_HELENA_ASCENSION_AND_TRISTAN_DA_CUNHA : return "Saint Helena, Ascension and Tristan da Cunha";
				case Country.SAINT_KITTS_AND_NEVIS : return "Saint Kitts and Nevis";
				case Country.SAINT_LUCIA : return "Saint Lucia";
				case Country.SAINT_MARTIN_FRENCH_PART : return "Saint Martin (French part)";
				case Country.SAINT_PIERRE_AND_MIQUELON : return "Saint Pierre and Miquelon";
				case Country.SAINT_VINCENT_AND_THE_GRENADINES : return "Saint Vincent and the Grenadines";
				case Country.SAMOA : return "Samoa";
				case Country.SAN_MARINO : return "San Marino";
				case Country.SAO_TOME_AND_PRINCIPE : return "Sao Tome and Principe";
				case Country.SAUDI_ARABIA : return "Saudi Arabia";
				case Country.SENEGAL : return "Senegal";
				case Country.SERBIA : return "Serbia";
				case Country.SEYCHELLES : return "Seychelles";
				case Country.SIERRA_LEONE : return "Sierra Leone";
				case Country.SINGAPORE : return "Singapore";
				case Country.SINT_MAARTEN_DUTCH_PART : return "Sint Maarten (Dutch part)";
				case Country.SLOVAKIA : return "Slovakia";
				case Country.SLOVENIA : return "Slovenia";
				case Country.SOLOMON_ISLANDS : return "Solomon Islands";
				case Country.SOMALIA : return "Somalia";
				case Country.SOUTH_AFRICA : return "South Africa";
				case Country.SOUTH_GEORGIA_AND_THE_SOUTH_SANDWICH_ISLANDS : return "South Georgia and the South Sandwich Islands";
				case Country.SOUTH_SUDAN : return "South Sudan";
				case Country.SPAIN : return "Spain";
				case Country.SRI_LANKA : return "Sri Lanka";
				case Country.SUDAN : return "Sudan";
				case Country.SURINAME : return "Suriname";
				case Country.SVALBARD_AND_JAN_MAYEN : return "Svalbard and Jan Mayen";
				case Country.SWAZILAND : return "Swaziland";
				case Country.SWEDEN : return "Sweden";
				case Country.SWITZERLAND : return "Switzerland";
				case Country.SYRIAN_ARAB_REPUBLIC : return "Syrian Arab Republic";
				case Country.TAIWAN_PROVINCE_OF_CHINA : return "Taiwan, Province of China";
				case Country.TAJIKISTAN : return "Tajikistan";
				case Country.TANZANIA_UNITED_REPUBLIC_OF : return "Tanzania, United Republic of";
				case Country.THAILAND : return "Thailand";
				case Country.TIMOR_LESTE : return "Timor-Leste";
				case Country.TOGO : return "Togo";
				case Country.TOKELAU : return "Tokelau";
				case Country.TONGA : return "Tonga";
				case Country.TRINIDAD_AND_TOBAGO : return "Trinidad and Tobago";
				case Country.TUNISIA : return "Tunisia";
				case Country.TURKEY : return "Turkey";
				case Country.TURKMENISTAN : return "Turkmenistan";
				case Country.TURKS_AND_CAICOS_ISLANDS : return "Turks and Caicos Islands";
				case Country.TUVALU : return "Tuvalu";
				case Country.UGANDA : return "Uganda";
				case Country.UKRAINE : return "Ukraine";
				case Country.UNITED_ARAB_EMIRATES : return "United Arab Emirates";
				case Country.UNITED_KINGDOM : return "United Kingdom";
				case Country.UNITED_STATES : return "United States";
				case Country.UNITED_STATES_MINOR_OUTLYING_ISLANDS : return "United States Minor Outlying Islands";
				case Country.URUGUAY : return "Uruguay";
				case Country.UZBEKISTAN : return "Uzbekistan";
				case Country.VANUATU : return "Vanuatu";
				case Country.VENEZUELA_BOLIVARIAN_REPUBLIC_OF : return "Venezuela, Bolivarian Republic of";
				case Country.VIET_NAM : return "Viet Nam";
				case Country.VIRGIN_ISLANDS_BRITISH : return "Virgin Islands, British";
				case Country.VIRGIN_ISLANDS_US : return "Virgin Islands, U.S.";
				case Country.WALLIS_AND_FUTUNA : return "Wallis and Futuna";
				case Country.WESTERN_SAHARA : return "Western Sahara";
				case Country.YEMEN : return "Yemen";
				case Country.ZAMBIA : return "Zambia";
				case Country.ZIMBABWE : return "Zimbabwe";
			}
			Log.error("Unknown country '" + country + "'", Country);

			return null;
		}
		
		/**
		 * Name of a geographical feature in an official or well-established language occurring in that area where the
		 * feature is located.
		 */
		public static function endonym(country:String):String
		{
			switch (country)
			{
				case Country.BELGIUM: return "België";
				case Country.FRANCE: return "La France";
				case Country.GERMANY: return "Deutschland";
				case Country.NETHERLANDS: return "Nederland";
			}
			Log.warn("No endonym found for '" + country + "', use exonym", Country);

			return Country.exonym(country);
		}
		
		public static function toString():String
		{
			return objectToString(Country);
		}
	}
}
