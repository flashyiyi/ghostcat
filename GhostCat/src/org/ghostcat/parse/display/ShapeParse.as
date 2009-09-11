package org.ghostcat.parse.display
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsEndFill;
	import org.ghostcat.parse.graphics.IGraphicsFill;
	import org.ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class ShapeParse extends DisplayParse
	{
		public var line:IGraphicsLineStyle;
		public var fill:IGraphicsFill;
		public var parses:Array;
		public var grid9:Grid9Parse;
		public function ShapeParse(parses:Array,line:IGraphicsLineStyle=null,fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			this.parses = parses;
			
			this.line = line;
			this.fill = fill;
			
			this.grid9 = grid9;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (line)
				line.parse(target);
			
			if (fill)
				fill.parse(target);
			
			parseShape(target);
			
			if (fill)
				new GraphicsEndFill().parse(target);
		}
		public function parseShape(target:Graphics) : void
		{
			if (parses)
			{
				for (var i:int = 0;i < parses.length;i++)
					(parse[i] as DisplayParse).parse(target);
			}
		}
		
		public override function parseDisplay(target:DisplayObject) : void
		{
			super.parseDisplay(target);
			
			if (grid9)
				grid9.parse(target);
		}
	}
}