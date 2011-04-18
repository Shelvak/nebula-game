package utils.locale
{
   import flash.errors.IllegalOperationError;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   import mx.utils.StringUtil;
   
   
   public class XMLBundleContentProxy extends Proxy
   {
      public function XMLBundleContentProxy(content:XML)
      {
         super();
         _contentXML = content;
         _content = new Object();
      }
      
      
      private var _contentXML:XML;
      private var _content:Object;
      
      
      flash_proxy override function callProperty(name:*, ...parameters) : *
      {
         throw new IllegalOperationError("No callable methods are defined!");
      }
      
      
      flash_proxy override function deleteProperty(name: *) : Boolean
      {
         if (flash_proxy::hasProperty(name))
         {
            return delete _content[name];
         }
         return false;
      }
      
      
      flash_proxy override function getProperty(name:*) : *
      {
         if (_content[name] === undefined)
         {
            var prop:XML = _contentXML.child(name)[0];
            var value:String = "";
            var refAttrs:XMLList = prop.attribute("ref");
            var valueAttrs:XMLList = prop.attribute("value");
            if (refAttrs.length() > 0)
            {
               value = "[reference:" + refAttrs[0] + "]";
            }
            else if (valueAttrs.length() > 0)
            {
               value = valueAttrs[0];
            }
            else if (prop.hasSimpleContent())
            {
               value = StringUtil.trim(prop.toString().replace(/\s+/g, " "));
            }
            else
            {
               var paragraphs:Array = new Array();
               for each (var p:XML in prop.children())
               {
                  if (p.hasSimpleContent())
                  {
                     paragraphs.push(StringUtil.trim(p.toString().replace(/\s+/g, " ")));
                  }
                  else
                  {
                     var parts:Vector.<String> = new Vector.<String>();
                     for each (var part:XML in p.text())
                     {
                        parts.push(StringUtil.trim(part.toString().replace(/\s+/g, " ")));
                     }
                     paragraphs.push(parts.join("\n"));
                  }
               }
               value = paragraphs.join("\n\n");
            }
            _content[name] = value;
         }
         return _content[name];
      }
      
      
      flash_proxy override function hasProperty(name:*) : Boolean
      {
         return _content[name] !== undefined ||
                _contentXML.child(name).length() > 0;
      }
      
      
      flash_proxy override function setProperty(name:*, value:*) : void
      {
         throw new IllegalOperationError("All properties are read only!");
      }
   }
}