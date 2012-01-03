/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 12/12/11
 * Time: 7:21 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.DamageEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;

   import mx.core.FlexGlobals;

   import mx.events.FlexEvent;

   public class TextFlowUtil {
      public static function importFromString(value:String): TextFlow
      {
          var cfg:Configuration = new Configuration();

          Object(cfg.defaultLinkNormalFormat).color = 0x00D8E3;
          Object(cfg.defaultLinkHoverFormat).color = 0x00D8E3;
          Object(cfg.defaultLinkActiveFormat).color = 0x00D8E3;
          Object(cfg.defaultLinkNormalFormat).textDecoration  = TextDecoration.UNDERLINE;
          Object(cfg.defaultLinkHoverFormat).textDecoration  = TextDecoration.UNDERLINE;
          Object(cfg.defaultLinkActiveFormat).textDecoration  = TextDecoration.UNDERLINE;
          var flow: TextFlow = TextConverter.importToFlow(value,
                  TextConverter.TEXT_FIELD_HTML_FORMAT, cfg);

         return flow.getTextFlow();
      }
   }
}
