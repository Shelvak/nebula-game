package components.chat
{
   import spark.components.Group;
   import spark.layouts.HorizontalLayout;
   
   
   /**
    * Groups three chat sub-buttons: main, alliance and private channel. 
    */
   public class CChatOpenChanButtons extends Group
   {
      public function CChatOpenChanButtons()
      {
         super();
         mouseEnabled = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var layout:HorizontalLayout = new HorizontalLayout();
         layout.gap = 0;
         this.layout = layout;
         
         addElement(new CChatOpenChanButtonMain());
         addElement(new CChatOpenChanButtonAlliance());
         addElement(new CChatOpenChanButtonPrivate());
      }
   }
}