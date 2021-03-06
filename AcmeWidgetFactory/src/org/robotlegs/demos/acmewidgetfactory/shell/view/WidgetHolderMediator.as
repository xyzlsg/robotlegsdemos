package org.robotlegs.demos.acmewidgetfactory.shell.view
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	import mx.controls.SWFLoader;
	import mx.modules.ModuleLoader;
	
	import org.robotlegs.demos.acmewidgetfactory.shell.controller.ShellEvent;
	import org.robotlegs.demos.acmewidgetfactory.shell.controller.ShellWidgetEvent;
	import org.robotlegs.demos.acmewidgetfactory.shell.model.ActiveWidgetModel;
	import org.robotlegs.demos.acmewidgetfactory.shell.model.ActiveWidgetModelEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class WidgetHolderMediator extends Mediator
	{
		private static const MODULE_URL:String = 'org/robotlegs/demos/acmewidgetfactory/modules/generic/GenericModule.swf';
		
		[Inject]
		public var view:WidgetHolderView;
		
		[Inject]
		public var activeWidgetModel:ActiveWidgetModel;
		
		public function WidgetHolderMediator()
		{
		}
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, ActiveWidgetModelEvent.WIDGET_CREATED, onWidgetCreated);
			eventMap.mapListener(eventDispatcher, ShellWidgetEvent.SHUTDOWN_WIDGET_COMPLETE, onShutdownWidgetComplete);
			eventMap.mapListener(eventDispatcher, ShellEvent.ADD_GENERIC_MODULE, addGenericModule);
		}
		
		protected function onWidgetCreated(e:ActiveWidgetModelEvent):void
		{
			view.addChild(activeWidgetModel.getWidget(e.widgetId));
		}
		
		protected function onShutdownWidgetComplete(e:ShellWidgetEvent):void
		{
			view.removeChild(activeWidgetModel.getWidget(e.widgetId) as DisplayObject);
			eventDispatcher.dispatchEvent(new ShellWidgetEvent(ShellWidgetEvent.REMOVE_WIDGET_COMPLETE, e.widgetId));
		}
		
		protected function addGenericModule(e:ShellEvent):void
		{
			var modLoader:ModuleLoader = new ModuleLoader();
			modLoader.width = 124;
			modLoader.height = 84;
			modLoader.loadModule(MODULE_URL);
			view.addChild(modLoader);
		}
	}
}