package tests.models
{
   import flash.geom.Point;
   
   import models.BaseModel;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.notNullValue;
   
   import tests.models.classes.ModelNested;
   import tests.models.classes.ModelRequiredSelf;

   public class TCBaseModel
   {
      [Test]
      public function createModel_error() : void
      {
         assertThat(
            function():void{ BaseModel.createModel(ModelInvalidMetadata, {invalid: "invalid"}) },
            throws(Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelMissingCollectionMetadata, {collection: [1]}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelUnsupportedCollectionItem, {collection: [new Date()]}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelRequiredProps, {name: "MikisM"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelRequiredProps, {name: new Date(), age: 5}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelDateProp, {date: "not a date"}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelUnsupportedPropertyType, {point: new Point()}) },
            throws (Error)
         );
         
         assertThat(
            function():void{ BaseModel.createModel(ModelRequiredSelf, {id: 2, self: {id: 3}}) },
            throws (Error)
         );
         
         
         assertThat(
            function():void{ BaseModel.createModel(ModelAliasProperties, {}) },
            throws (Error)
         );
      };
      
      
      /**
       * Checks if tree-like structures are created using BaseModel.createModel().
       */
      public function createModel_nestedModels() : void
      {
         var model:ModelNested = BaseModel.createModel(ModelNested, {id: 1, nested: {id: 2}});
         assertThat( model.id, equalTo (1) );
         assertThat( model.nested, notNullValue() );
         assertThat( model.nested.id, equalTo (2) );
      };
      
      
      /**
       * Checks if null and undefined values are not copied when [Optional] tag is used. 
       */
      public function createModel_optional_undefinedAndNull() : void
      {
         var model:ModelOptionalMetadata = null;
         
         model = BaseModel.createModel(ModelOptionalMetadata, {optional: null});
         assertThat( model.optional, equalTo ("default") );
         
         model = BaseModel.createModel(ModelOptionalMetadata, {});
         assertThat( model.optional, equalTo ("default") );
      };
      
      
      [Test]
      /**
       * When "alias" attribute of [Optional] or [Required] metadata tag is specified property of
       * source object named as specified by that attribute should be used instead of staticly
       * typed property name of model beeing created.
       */
      public function createModel_propertyAlias() : void
      {
         var model:ModelAliasProperties = BaseModel.createModel(ModelAliasProperties, {
            "requiredAlias": "required",
            "optionalAlias": "optional",
            "requiredModelAlias": new BaseModel()
         });
         assertThat( model.required, equalTo ("required") );
         assertThat( model.optional, equalTo ("optional") );
         assertThat( model.requiredModel, notNullValue() );
      };
   }
}


import flash.geom.Point;

import models.BaseModel;


class ModelInvalidMetadata extends BaseModel
{
   [Required]
   [Optional]
   public var invalid:String = null;
}


class ModelOptionalMetadata extends BaseModel
{
   [Optional]
   public var optional:String = "default";
}


class ModelMissingCollectionMetadata extends BaseModel
{
   [Required]
   public var collection:Array = null;
}


class ModelUnsupportedCollectionItem extends BaseModel
{
   [ArrayElementType("Date")]
   [Required]
   public var collection:Array = null;
}


class ModelRequiredProps extends BaseModel
{
   [Required]
   public var name:String = "";
   [Required]
   public var age:int = 0;
}


class ModelDateProp extends BaseModel
{
   [Required]
   public var date:Date = null;
}


class ModelUnsupportedPropertyType extends BaseModel
{
   [Required]
   public var point:Point;
}


class ModelAliasProperties extends BaseModel
{
   [Required(alias="requiredAlias")]
   /**
    * [Required(serverAlias="requiredAlias")]
    */
   public var required:String = null;
   
   [Optional(alias="optionalAlias")]
   /**
    * [Optional(serverAlias="optionalAlias")]
    */
   public var optional:String = null;
   
   [Required(alias="requiredModelAlias")]
   /**
    * [Required(alias="requiredModelAlias")]
    */
   public var requiredModel:BaseModel = null;
}