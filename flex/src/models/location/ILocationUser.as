package models.location
{
   /**
    * Classes that use istances of <code>models.loaction.Location</code> may
    * need to implement this interface to get their <code>Location.name</code>
    * property updated when the name of a planet has been changed.
    */
   public interface ILocationUser
   {
      /**
       * Updates <code>name</code> property of all instances of <code>Location</code> used.
       * 
       * <p>It is up to the implementer to check if <code>id</code>s match or if the instances of
       * <code>Location</code> are actually of <code>LocationType.SS_OBJECT</code> type.
       * <code>Location.updateName()</code> static method may be used for updating instances of
       * <code>Location</code> to make ones life easier.</p>
       * 
       * @param id id of a location that needs to be updated.
       * @param name new value of <code>name</code> property.
       * 
       * @see models.location.Location
       * @see models.location.Location#updateName()
       */
      function updateLocationName(id:int, name:String) : void;
   }
}