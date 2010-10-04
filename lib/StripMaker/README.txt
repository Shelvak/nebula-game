Usage:

java -jar StripMaker.jar data_dir frame_width

Data directory format:
  0_default/
    0.png
  1_action/
    00.png
    01.png
    02.png
    ...
  ...

Default action is named default. Box is determined out of it. It is not
written to config.