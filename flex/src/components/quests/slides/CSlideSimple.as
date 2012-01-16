package components.quests.slides
{
   import flash.text.engine.FontWeight;

   import models.quest.slides.MSlideSimple;

   import mx.graphics.SolidColor;

   import spark.components.Group;
   import spark.components.RichText;
   import spark.primitives.Rect;

   import utils.TextFlowUtil;
   import utils.assets.AssetNames;


   public class CSlideSimple extends CSlide
   {
      public function CSlideSimple() {
         super();
      }

      protected override function getBackgroundImageUrl(): String {
         return AssetNames.getQuestSlideBackgroundImageURL(model.key);
      }

      private var txtText:RichText;
      private var grpTextContainer:Group;

      protected override function createChildren(): void {
         if (childrenAlreadyCreated) {
            return;
         }
         super.createChildren();

         grpTextContainer = new Group();
         grpTextContainer.x = 10;
         grpTextContainer.y = 265;
         grpTextContainer.width = 650;
         grpTextContainer.height = 85;
         addElement(grpTextContainer);

         const textBackground:Rect = new Rect();
         textBackground.radiusX = 20;
         textBackground.radiusY = 20;
         textBackground.fill = new SolidColor(0x000000, 0.15);
         textBackground.percentWidth = 100;
         textBackground.percentHeight = 100;
         grpTextContainer.addElement(textBackground)

         txtText = new RichText();
         txtText.setStyle("fontSize", 14);
         txtText.setStyle("fontWeight", FontWeight.BOLD);
         txtText.left = 10;
         txtText.right = 10;
         txtText.top = 10;
         txtText.bottom = 10;
         grpTextContainer.addElement(txtText);
      }

      protected override function modelCommit(): void {
         super.modelCommit();
         if (this.model != null) {
            txtText.textFlow = TextFlowUtil.importFromString(
               MSlideSimple(this.model).text
            );
         }
      }
   }
}
