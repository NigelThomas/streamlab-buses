# streamlab-buses

This example installs a single StreamLab project. The Dockerfile is in a directory alongside a single slab file. Any manually created dashboards should be in the dashboards sub-directory.

The Dockerfile builds a version-specific image – the project version is bound into the image at image creation time. Any container based on this image will use the same build time project version. When the project slab file is updated, just rebuild the image.

The example uses the SQLstream "Sydney Buses" demo application - exported here as buses.slab.

The dockerbuild.sh and dockerrun.sh commands are for my convenience, and use my Docker hub account - if you use this you should use these as models. 

To use this to run your own project, just clone this project, and replace buses.slab with your own StreamLab project export file.

Coming soon: a multi-project installer.

