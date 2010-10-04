package utils.datastructures
{
   import models.technology.Technology;
   
   public class LineSet extends Set
   {
      public function LineSet()
      {
         super(function (line: *): String
         {
            return line.xPos+','+line.yPos+','+line.wdth+','+line.hght;
         });
      }
      
      public function addLine(line: *, tech: Technology): void
      {
         var oldLine: * = super.getElement(line.xPos+','+line.yPos+','+line.wdth+','+line.hght);
         if (oldLine == undefined)
         {
            if (tech != null)
               line.addBaseTech(tech);
            addItem(line);
         }
         else
         {
            if (tech != null)
               oldLine.addBaseTech(tech);
         }
      }
   }
}