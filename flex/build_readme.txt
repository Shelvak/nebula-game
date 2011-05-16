For FlexUnit ant tasks to work, you have to modify *default* flex-config.xml file
of the Flex SDK you are using to compile SWFs:

1. Locate flex-config.xml (usually in {sdk_root}\frameworks directory).
2. Put following XML snippet inside <compiler/> element:

<keep-as3-metadata>
   <!-- ################################### -->
   <!-- ### REQUIRED BY BINDING FEATURE ### -->
   <!-- ################################### -->
   <name>Bindable</name>
   <name>Managed</name>
   <name>ChangeEvent</name>
   <name>NonCommittingChangeEvent</name>
   <name>Transient</name>
   <!-- ############################################# -->
   <!-- ### REQUIRED BY NEBULA44: MAY BE MODIFIED ### -->
   <!-- ############################################# -->
   <name>Required</name>
   <name>Optional</name>
   <name>ArrayElementType</name>
   <name>SkipProperty</name>
</keep-as3-metadata>

3. Save the file.

Specifying compiler options in "test" task (our own build.xml) is not
possible with FlexUnit 4.1 (and 4.2 is in alpha). And since you are required to put
<keep-as3-metadata/> in the default flex-config.xml there is no need to specify those
compiler options in "compile" task.

See following links for information on this issue:
http://forums.adobe.com/message/3217170#3217170
http://forums.adobe.com/message/2897423#2897423
https://bugs.adobe.com/jira/browse/FXU-116
https://bugs.adobe.com/jira/browse/FXU-118
