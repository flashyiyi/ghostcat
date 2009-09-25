package ghostcat.manager
{
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import ghostcat.text.TextUtil;
	import ghostcat.util.Singleton;
	import ghostcat.util.Util;

	/**
	 * 这个类用于保存字体样式以及帮助嵌入字体。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FontManager extends Singleton
	{
		static public function get instance():FontManager
		{
			return Singleton.getInstanceOrCreate(FontManager) as FontManager;
		}
		
		/**
		 * 将需要陷入的文字作为参数输入，将会trace出一段代码。
		 * 添加这段代码即可成功嵌入文字。
		 * 
		 * 最近发现有人做了一个工具，和这个的原理一样，包含导入文本文件并滤字的功能，非常好用。我这个可以无视了。
		 * http://kevincao.com/2009/06/font-converter-update/
		 * 
		 * @param fontName	FLASH内部的字体名称，内部将以这个名字为准
		 * @param systemName	系统字体名称
		 * @param italic	是否是粗体
		 * @param weight	是否是斜体
		 * @param text	需要嵌入的文字
		 * 
		 */
		public static function traceEmbedFontCode(fontName:String, systemFont:String, italic:Boolean = false, weight:Boolean = false,text:String=null):void
		{
			var result:String = "";
			result += '[Embed(systemFont="'+ systemFont +'", fontName="'+ fontName +'",mimeType="application/x-font"';
			if (italic) 
				result+= ', fontStyle="italic"';
			if (weight) 
				result+= ', fontWeight="bold"';
				
			if (text)
			{
				var textArr:Array = [];
				for (var i:int = 0;i < text.length;i++)
					textArr.push(text.charCodeAt(i));
				textArr.sort(Array.NUMERIC);
				
				var unicodeRange:String="";
				var prev:uint;
				for (i = 0;i < textArr.length;i++)
				{
					var now:uint = textArr[i];
					if (now != prev)
					{
						if (unicodeRange!="")
							unicodeRange += ",";
						unicodeRange += "U+" + TextUtil.fillZeros(now.toString(16).toUpperCase(),4);
					}
					prev = now;
				}
				result += ', unicodeRange="'+ unicodeRange +'"';
			}
			result += ')]';
			trace(result);
			trace('var '+ fontName +':Class;');
			trace('Font.registerFont('+ fontName +');');
		}
		
		private var textFormats:Dictionary = new Dictionary();
		
		/**
		 * 注册一个字体样式
		 * 
		 * @param name	样式名称
		 * @param fontObj	字体属性对象
		 * 
		 */
		public function registerTextFormat(name:String,fontObj:*):void
		{
			var textFormat:TextFormat;
			if (fontObj is TextFormat)
				textFormat = fontObj as TextFormat;
			else
				textFormat = Util.createObject(TextFormat,fontObj);
				
			textFormats[name] = textFormat;
		}
		
		/**
		 * 获取已注册的字体样式
		 * 
		 * @param name	样式名称
		 * @return 
		 * 
		 */
		public function getTextFormat(name:String):TextFormat
		{
			return textFormats[name];
		}
		
		/**
		 * 按名称获得字体
		 * 
		 * @param name	字体名
		 * @param fontStyle	字体类型
		 * @param deviceFont	是否包括设备字体
		 * @return 
		 * 
		 */
		public function getFontByName(name:String,fontStyle:String = FontStyle.REGULAR, deviceFont:Boolean = false):Font
		{
			var arr:Array = Font.enumerateFonts(deviceFont);
			for (var i:int = 0;i < arr.length;i++)
			{
				var f:Font = arr[i] as Font;
				if (f.fontName == name && f.fontStyle == fontStyle)
					return f;
			}
			return null;
		}
		
		/**
		 * 从TextFormat中获得字体类型
		 * 
		 * @param textFormat
		 * @return 
		 * 
		 */
		public function getFontStyle(textFormat:TextFormat):String
		{
			var bold:Boolean = textFormat.bold;
			var italic:Boolean = textFormat.italic;
			if (bold && italic)
				return FontStyle.BOLD_ITALIC;
			else if (bold)
				return FontStyle.BOLD;
			else if (italic)
				return FontStyle.ITALIC;
			else
				return FontStyle.REGULAR;
				
			return null;
		}
		
		/**
		 * 判断文本的字体是否已经嵌入
		 *  
		 * @param text
		 * 
		 */
		public function isEmbed(text:String,textFormat:TextFormat):Boolean
		{
			var font:Font = getFontByName(textFormat.font,getFontStyle(textFormat),false);
			return font && font.hasGlyphs(text)
		}
		
		/**
		 * 根据字体嵌入情况自动设置文本框的embedFonts属性，仅适用于使用defaultTextFormat的情况
		 * @param text
		 * 
		 */
		public function autoEmbedFonts(textField:TextField):void
		{
			textField.embedFonts = isEmbed(textField.text,textField.defaultTextFormat);
		}
	}
}