package ghostcat.operation
{
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import ghostcat.events.OperationEvent;

	/**
	 * 本地保存文件 
	 * @author flashyiyi
	 * 
	 */
	public class FileSaveOper extends Oper
	{
		public var file:FileReference;
		
		private var data:ByteArray;
			
		public function FileSaveOper(data:ByteArray,rHandler:Function = null,eHandler:Function = null)
		{
			this.file = new FileReference();
			this.data = data;
			
			if (rHandler!=null)
				addEventListener(OperationEvent.OPERATION_COMPLETE,rHandler);
			
			if (eHandler!=null)
				addEventListener(OperationEvent.OPERATION_ERROR,eHandler);
		}
		
		public override function execute() : void
		{
			super.execute();
			
			file.addEventListener(Event.SELECT,selectFileHandler);
			file.addEventListener(Event.CANCEL,fault);
			file.browse();
		}
		
		private function selectFileHandler(event:Event):void
		{
			file.removeEventListener(Event.COMPLETE,selectFileHandler);
			file.addEventListener(Event.COMPLETE,result);
			file.save(data);
		}
		
		protected override function end(event:*=null) : void
		{
			file.removeEventListener(Event.COMPLETE,result);
			file.removeEventListener(Event.CANCEL,fault);
			super.end(event);
		}
	}
}