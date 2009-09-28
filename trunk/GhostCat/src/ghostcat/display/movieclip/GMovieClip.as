package ghostcat.display.movieclip
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * 动画控制类，可以通过setLabel, queueLabel将动画推入列表，实现动画的灵活控制。这种方法可以非常简单地实现多方向行走，表情动作系统。
	 * frameRate可以设置播放速度。采用了getTimer的机制，播放速度不会受到浏览器和机器配置的影响。
	 * 
	 * 由于MovieClip播放的异步以及播放速度的不稳定特性，不断执行gotoAndStop等方法时将会造成子动画播放不正常，
	 * 请尽可能避免在动画内再放置“影片剪辑”，而以“图形”代替。
	 * 
	 * 设置paused=false时和原本的MovieClip行为相同。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GMovieClip extends GMovieClipBase
	{
		/**
		 * 时间线对象 
		 */
		public var timeLine:TimeLine;
		
		/**
		 * 
		 * @param mc	目标动画
		 * @param replace	是否替换
		 * @param paused	是否暂停
		 * 
		 */
		public function GMovieClip(mc:*=null, replace:Boolean=true, paused:Boolean=false)
		{
			super(mc, replace, paused);
		}
		
		/**
		 * 获得当前动画 
		 * @return 
		 * 
		 */
		public function get mc():MovieClip
		{
			return content as MovieClip;
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			if (mc)
			{
				timeLine = new TimeLine(mc);
				//最开始的初始化，当设置了Label后，将首先在第一个Label内循环
				mc.stop();
				clearQueue();
				if (labels && labels.length>0)
					setLabel(labels[0].name,-1);
			}
		}
		/** @inheritDoc*/
		public override function get curLabelName():String
		{
			return timeLine.curLabelName;
		}
		/** @inheritDoc*/
		public override function getLabelIndex(labelName:String):int
        {
        	return timeLine.getLabelIndex(labelName);
        }
		/** @inheritDoc*/
		public override function get labels():Array
		{
			return timeLine.labels;
		}
		/** @inheritDoc*/
		public override function get currentFrame():int
        {
        	return mc.currentFrame;
        }
        /** @inheritDoc*/
        public override function set currentFrame(frame:int):void
        {
        	mc.gotoAndStop(frame);
        }
        /** @inheritDoc*/
        public override function get totalFrames():int
        {
        	return mc.totalFrames;
        }
        /** @inheritDoc*/
        public override function nextFrame():void
        {
        	mc.nextFrame();
        }
        /**
         * 将动画缓存为位图并转化为GBitmapMovieClip对象
         * 注意这个缓存是需要时间的，如果要在完全生成GBitmapMovieClip对象进行一些操作，可监听GBitmapMovieClip的complete事件
         * 
         * @param rect		绘制范围
		 * @param start		起始帧
		 * @param len		长度
         * 
         * @return 
         * 
         */
        public function toGBitmapMovieClip(rect:Rectangle=null,start:int = 1,len:int = -1):GBitmapMovieClip
        {
        	var cacher:MovieClipCacher = new MovieClipCacher(mc,rect,start,len);
        	cacher.addEventListener(Event.COMPLETE,cacherCompleteHandler);
        	var bitmapMC:GBitmapMovieClip = new GBitmapMovieClip([]);
        	
        	function cacherCompleteHandler(event:Event):void
        	{
        		cacher.removeEventListener(Event.COMPLETE,cacherCompleteHandler);
        		
        		bitmapMC.bitmaps = cacher.result;
        		bitmapMC.labels = mc.currentLabels;
        		bitmapMC.dispatchEvent(new Event(Event.COMPLETE));
        		
        	}
        	
        	return bitmapMC;
        }
	}
}