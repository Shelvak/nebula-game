package utils
{
   import flashx.textLayout.elements.TextFlow;

   import spark.utils.TextFlowUtil;

   import styles.LinkState;
   import styles.LinkStyle;


   public class TextFlowUtil
   {
      private static const EVENT_HREF:RegExp = /<a(.+?)(href=["']event:[^>]+?)>([^<]+?)<\/a>/;
      private static const LINK_HREF:RegExp = /<a(.+?)(href=["'].+?:\/\/[^>]+?)>([^<]+?)<\/a>/;
      
      private static function addLinkStyles(html:String): String {
         var match:Array = null;
         var substitute:String = null;
         while (match = EVENT_HREF.exec(html)) {
            substitute = "<a" + match[1] + match[2] + ">"
                            + createLinkFormats(LinkStyle.APP_URL)
                            + match[3] + "</a>";
            html = html.replace(match[0], substitute);
         }
         while (match = LINK_HREF.exec(html)) {
            substitute = "<a" + match[1] + match[2] + ">"
                            + createLinkFormats(LinkStyle.EXTERNAL_URL)
                            + match[3] + "</a>";
            html = html.replace(match[0], substitute);
         }
         return html;
      }

      private static function createLinkFormats(linkStyle:LinkStyle): String {
         return StringUtil.substitute(
            "<linkNormalFormat>{0}</linkNormalFormat>" +
               "<linkActiveFormat>{1}</linkActiveFormat>" +
               "<linkHoverFormat>{2}</linkHoverFormat>",
            createLinkStateFormat(linkStyle.normalState),
            createLinkStateFormat(linkStyle.activeState),
            createLinkStateFormat(linkStyle.hoverState)
         );
      }

      private static function createLinkStateFormat(linkState:LinkState): String {
         return StringUtil.substitute(
            "<TextLayoutFormat color='0x{0}' textDecoration='{1}' fontWeight='{2}'/>",
            linkState.color.toString(16),
            linkState.textDecoration,
            linkState.fontWeight
         );
      }

      public static function importFromString(value: String): TextFlow {
         return spark.utils.TextFlowUtil.importFromString(addLinkStyles(value));
      }
   }
}
