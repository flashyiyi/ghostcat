package ghostcat.display.transition
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.transfer.GBitmapCacheTransfer;
	import ghostcat.util.core.Handler;

	/**
	 * 使用位图特效过渡（马赛克，溶解）来显示过渡效果
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionTransferLayer extends TransitionLayer
	{
		/**
		 * 遮挡对象
		 */
		public var transfer:GBitmapCacheTransfer;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayer
		{
			container.addChild(transfer);
			return super.createTo(container);
		}
		
		public function TransitionTransferLayer(switchHandler:Handler,transferClass:Class,target:DisplayObject,fadeOut:int = 1000, wait:Boolean=false, easeOut:Function = null)
		{
			this.transfer = new transferClass(new DrawParse(target).createBitmap());
			transfer.deep = 0.0;
			
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeOut)
				fadeOutOper = new TweenOper(transfer,fadeOut,{deep:1.0,ease:easeOut});
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,null,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (transfer)
				transfer.destory();
			
			super.destory();
		}
	}
}