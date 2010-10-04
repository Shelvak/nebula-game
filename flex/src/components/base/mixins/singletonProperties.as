// Declares references to application wide singletons as public static variables.
// Declared variables are suided for components but can be used elsewhere although
// in ActionSript code Singleton.instance 
// Binding to these variables won't cause any warnings.

import utils.assets.Cursors;
import utils.assets.ImagePreloader;

import models.ModelLocator;

import mx.resources.IResourceManager;
import mx.resources.ResourceManager;




[Bindable]
public var ML:  ModelLocator     = ModelLocator.getInstance ();
[Bindable]
public var RM:  IResourceManager = ResourceManager.getInstance ();
[Bindable]
public var IMG: ImagePreloader   = ImagePreloader.getInstance ();