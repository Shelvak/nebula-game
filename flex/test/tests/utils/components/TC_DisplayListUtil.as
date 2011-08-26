package tests.utils.components
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   import mx.core.FlexSprite;
   import mx.core.UIComponent;
   import mx.flash.UIMovieClip;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   
   import spark.components.Application;
   import spark.components.Group;
   import spark.core.SpriteVisualElement;
   
   import utils.components.DisplayListUtil;

   public class TC_DisplayListUtil
   {
      [Test]
      public function isInsideInstance_illegalParams() : void
      {
         assertThat(
            function():void{ DisplayListUtil.isInsideInstance(undefined, new Group()) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideInstance(null, new Group()) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideInstance(new Object(), new Group()) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideInstance(new Group(), null) },
            throws (ArgumentError)
         );
      };
      
      
      [Test]
      public function isInsideInstance() : void
      {
         var groupA0:Group = new Group();
         var groupA1:Group = new Group();
         groupA0.addElement(groupA1);
         var groupA2:Group = new Group();
         groupA1.addElement(groupA2);
         
         var groupB0:Group = new Group();
         var groupB1:Group = new Group();
         groupB0.addElement(groupB1);
         var groupB2:Group = new Group();
         groupB1.addElement(groupB2); 
         
         var child:UIComponent = new UIComponent();
         groupA2.addElement(child);
         
         // Should return false if element is compared against itself
         assertThat( DisplayListUtil.isInsideInstance(child, child), equalTo (false) );
         
         // Direct child
         assertThat( DisplayListUtil.isInsideInstance(child, groupA2), equalTo (true) );
         
         // Indirect child deep in the display list
         assertThat( DisplayListUtil.isInsideInstance(child, groupA1), equalTo (true) );
         assertThat( DisplayListUtil.isInsideInstance(child, groupA0), equalTo (true) );
         
         // Not a child: top container hasn't got parent
         assertThat( DisplayListUtil.isInsideInstance(child, groupB2), equalTo (false) );
         assertThat( DisplayListUtil.isInsideInstance(child, groupB1), equalTo (false) );
         assertThat( DisplayListUtil.isInsideInstance(child, groupB0), equalTo (false) );
      };
      
      
      [Test]
      public function isInsideType_illegalParams() : void
      {
         assertThat(
            function():void{ DisplayListUtil.isInsideType(undefined, Group) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideType(null, Group) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideType(new Object(), Group) },
            throws (ArgumentError)
         );
         assertThat(
            function():void{ DisplayListUtil.isInsideType(new Group(), null) },
            throws (ArgumentError)
         );
      };
      
      
      [Test]
      public function isInsideType() : void
      {
         var groupA0:UIComponent = new UIComponent();
         var groupA1:UIMovieClip = new UIMovieClip();
         groupA0.addChild(groupA1);
         
         var groupB0:SpriteVisualElement = new SpriteVisualElement();
         
         var topGroup:Group = new Group();
         topGroup.addElement(groupA0);
         topGroup.addElement(groupB0);
         
         var child:UIComponent = new UIComponent();
         groupA1.addChild(child);
         
         // Direct child
         assertThat( DisplayListUtil.isInsideType(child, UIMovieClip), equalTo (true) );
         
         // Indirect child deep in the display list
         assertThat( DisplayListUtil.isInsideType(child, UIComponent), equalTo (true) );
         assertThat( DisplayListUtil.isInsideType(child, Group), equalTo (true) );
         
         // Not a child
         assertThat( DisplayListUtil.isInsideType(child, SpriteVisualElement), equalTo (false) );
      };
   }
}