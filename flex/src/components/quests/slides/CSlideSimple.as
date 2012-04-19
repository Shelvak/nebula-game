package components.quests.slides
{
   import models.quest.slides.MSlideSimple;

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

      private var txtText: CSlideTextScrollable;

      protected override function createChildren(): void {
         if (childrenAlreadyCreated) {
            return;
         }
         super.createChildren();

         txtText = new CSlideTextScrollable();
         txtText.x = 10;
         txtText.y = 265;
         txtText.width = 650;
         txtText.height = 85;
         addElement(txtText);
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
