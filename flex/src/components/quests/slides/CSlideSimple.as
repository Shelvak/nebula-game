package components.quests.slides
{
   import flash.geom.Rectangle;

   import models.quest.slides.MSlideSimple;

   import spark.components.RichText;

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
      protected override function createChildren(): void {
         if (childrenAlreadyCreated) {
            return;
         }
         super.createChildren();

         txtText = new RichText();
         addElement(txtText);
      }

      protected override function modelCommit(): void {
         super.modelCommit();
         if (this.model != null) {
            const model:MSlideSimple = MSlideSimple(this.model);
            const textArea:Rectangle = model.textArea;
            txtText.textFlow = TextFlowUtil.importFromString(model.text);
            txtText.x = textArea.x;
            txtText.y = textArea.y;
            txtText.width = textArea.width;
            txtText.height = textArea.height;
         }
      }
   }
}
