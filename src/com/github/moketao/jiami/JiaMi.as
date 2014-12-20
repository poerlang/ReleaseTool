package com.github.moketao.jiami
{
	import com.github.moketao.fileutil.FileX;
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.DESKey;
	import com.hurlant.util.Base64;
	
	import flash.utils.ByteArray;

	/**
	 * 加密类，可加密字符串、二进制。
	 * 从如下链接copy的代码，稍加整理成类：
	 * http://www.cnblogs.com/kongfuzhoublogs/archive/2012/11/17/2774414.html
	 * 使用了类库：https://github.com/timkurvers/as3-crypto
	 */
	public class JiaMi
	{
		private var hasInit:Boolean;
		private var cbc:CBCMode;
		
		/** 加密类，可加密字符串、二进制。*/
		public function JiaMi(keyString:String):void{
			init(keyString);
		}
		/**初始化JiaMi模块，用于设置密码（密匙）。如果密码变化，需再次执行此函数**/
		public function init(keyString:String=null):void{
			var iv:ByteArray= new ByteArray();
			iv.writeUTFBytes(seed);
			
			if(keyString!=null){
				var key:ByteArray = new ByteArray();
				key.writeUTFBytes(keyString);
				
				var des:DESKey = new DESKey(key);                        
				cbc = new CBCMode(des); //加密模式,有多种模式供你选择
			}
			if(cbc==null) throw new Error("JiaMi 模块第一次执行init时，keyString参数不能为空");
			cbc.IV = iv; 			//设置加密的IV
			
			hasInit = true;
		}
		
		/**
		 * iv，以游戏为例，每次登陆，整合iv字符串到协议中，传输给玩家，
		 * 可以认为是双层密码，或者动态密码。
		 * 这样处理后，就算每天玩家的操作是一样的，但是每天的密文却是不一样的，
		 * 增加了密文的随机性，就算黑客对比前一天的密文，也不可能破解。
		 * 如果iv变动更频繁，比如一个小时一次，那么黑客则更不可能短时间内破解密码。
		 * 当然，也可以使用固定密文，比如"github.com/moketao"什么的，这样等于只是使用了单层密码。
		 */
		public var seed:String = "!s.d#62,9sp[";

		public function setSeed(_seed:String,keyString:String=null):void{
			seed = _seed;
			init(keyString);
		}
		
		/**输出加密文本（生成火星文）
		 * 得到的密文长度和明文的长度有关,规律大致是:明文<8 密文=12 ,明文<16 密文=24 ,明文>=16 密文=32...以此类推**/
		public function encodeString(str:String):String{
			var tmp:ByteArray = convertStringToByteArray(str); 		//转换成二进制编码 (该函数自己定义)
			cbc.encrypt(tmp);										//利用加密模式对数据进行加密
			return Base64.encodeByteArray(tmp);						//利用base64对密文进行编码
		}
		
		/**解密出明文（生成原文）**/
		public function decodeString(as3Str:String):String{
			var tmp:ByteArray = Base64.decodeToByteArray(as3Str);	//因为刚才加密的是把密文进行base64编码了,现在解码
			cbc.decrypt(tmp);										//利用加密模式的解密算法解码
			return convertByteArrayToString(tmp);					//把二进制数据转换成字符串 函数代码如下
		}
		
		public function encodeByte(b:ByteArray):ByteArray{
			cbc.encrypt(b);
			return b;
		}
		public function decodeByte(b:ByteArray):ByteArray{
			cbc.decrypt(b);
			b.position = 0;
			return b;
		}
		public function encodeFile(s1:*,s2:*):void{
			var tmp:ByteArray = FileX.FileToBytes(s1);
			var tmp2:ByteArray = encodeByte(tmp);
			FileX.bytesToFile(tmp2,s2);
		}
		public function decodeFile(s1:*,s2:*):void{
			var tmp:ByteArray = FileX.FileToBytes(s1);
			var tmp2:ByteArray = decodeByte(tmp);
			FileX.bytesToFile(tmp2,s2);
		}
		
		public function convertStringToByteArray(str:String):ByteArray{
			var tmp:ByteArray = new ByteArray();
			tmp.writeUTFBytes(str);
			return tmp;
		}
		public function convertByteArrayToString(bytes:ByteArray):String{
			bytes.position=0;
			return bytes.readUTFBytes(bytes.length);
		} 
	}
}