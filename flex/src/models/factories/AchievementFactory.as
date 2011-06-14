package models.factories
{
   import models.achievement.MAchievement;
   
   import mx.collections.ArrayCollection;
   
   public class AchievementFactory
   {
      
      /**
       * Creates an achievement form a given simple object.
       *  
       * @param data An object representing an achievement.
       * 
       * @return instance of <code>MAchievement</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : MAchievement
      {
         if (!data)
         {
            throw new Error('Can not create achievement, null given');
         }
         var achievement: MAchievement = new MAchievement(data.type);
         achievement.alliance = data.alliance;
         achievement.count = data.count;
         achievement.key = data.key;
         achievement.level = data.level;
         achievement.limit = data.limit;
         achievement.npc = data.npc;
         achievement.outcome = data.outcome;
         achievement.completed = data.completed;
         return achievement;
      }
      
      public static function fromObjects(achievements: Array) : ArrayCollection
      {
         var source: Array = [];
         for each (var achievementData:Object in achievements)
         {
            var achievement:MAchievement = fromObject(achievementData);
            source.push(achievement);
         }
         return new ArrayCollection(source);
      }
   }
}