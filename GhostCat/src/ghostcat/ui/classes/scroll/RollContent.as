package ghostcat.ui.classes.scroll
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	/**
	 * 不设置滚动区域的方式
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RollContent extends EventDispatcher implements IScrollContent
	{
		private var target:DisplayObject;
		
		private var _maxScrollH:int = int.MAX_VALUE;
		private var _maxScrollV:int = int.MAX_VALUE;
		
		public function RollContent(target:DisplayObject)
		{
			this.target = target;
		}
		
		public function get content():DisplayObject
		{
			return target;
		}
		
		public function get maxScrollH():int
		{
			return _maxScrollH;
		}
		
		public function get maxScrollV():int
		{
			return _maxScrollV;
		}
		
		public function set maxScrollH(v:int):void
		{
			_maxScrollH = v;
		}
		
		public function set maxScrollV(v:int):void
		{
			_maxScrollV = v;
		}
		
		public function get scrollH():int
		{
			return -content.x;
		}
		
		public function get scrollV():int
		{
			return -content.y;
		}
		
		public function set scrollH(v:int):void
		{
			content.x = -v;
		}
		
		public function set scrollV(v:int):void
		{
			content.y = -v;
		}
	}
}