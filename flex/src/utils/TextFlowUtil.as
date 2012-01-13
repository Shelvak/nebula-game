package utils
{
   import flashx.textLayout.conversion.TextLayoutImporter;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.TextLayoutFormat;

   import styles.LinkState;
   import styles.LinkStyle;
   import styles.ParagraphStyle;


   public class TextFlowUtil
   {
      private static const REGEXP_EVENT_HREF:RegExp =
                              /<a(.+?)(href=["']event:[^>]+?)>([^<]+?)<\/a>/g;
      private static const REGEXP_LINK_HREF:RegExp =
                              /<a(.+?)(href=["'].+?:\/\/[^>]+?)>([^<]+?)<\/a>/g;
      
      private static function addLinkStyles(html:String): String {
         html = html.replace(
            REGEXP_EVENT_HREF,
            "<a$1$2>" + createLinkFormats(LinkStyle.APP_URL) + "$3</a>"
         );
         html = html.replace(
            REGEXP_LINK_HREF,
            "<a$1$2>" + createLinkFormats(LinkStyle.EXTERNAL_URL) + "$3</a>"
         );
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

      private static const REGEXP_NEWLINE:RegExp = /\n/g;
      private static const REGEXP_SPACE_BEGIN_END:RegExp = /^\s+|\s+$/g;
      private static const REGEXP_SPACE_PARAS:RegExp = /<\/p>\s+<p>/g;

      public static function importFromString(value: String): TextFlow {
         value =
            "<TextFlow xmlns='http://ns.adobe.com/textLayout/2008'>" +
               addLinkStyles(
                  value.replace(REGEXP_NEWLINE, "")
                       .replace(REGEXP_SPACE_BEGIN_END, "")
                       .replace(REGEXP_SPACE_PARAS, "</p><p>")
               ) +
            "</TextFlow>";

         const config:Configuration = new Configuration(false);
         const layoutFormat:TextLayoutFormat = new TextLayoutFormat();
         layoutFormat.paragraphSpaceBefore = ParagraphStyle.SPACE_BEFORE;
         layoutFormat.paragraphSpaceAfter = ParagraphStyle.SPACE_AFTER;
         config.textFlowInitialFormat = layoutFormat;
         return getImporter(config).importToFlow(value);
      }

      private static function getImporter(config:Configuration): TextLayoutImporter {
         const importer:TextLayoutImporter = new TextLayoutImporter(config);
         importer.throwOnError = true;
         return importer;
      }
   }
}
