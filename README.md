Lightbox Exporter Plugin for iPhoto
===================================
This plugin allows you to export your photos in a [lightbox](http://lokeshdhakar.com/projects/lightbox2/) / [slimbox](http://www.digitalia.be/software/slimbox)
ready format: A small preview image and a big version when you click on it.
The plugin also creates an HTML snippet referencing all the images and using
the images' description as caption.

I wrote this for an early version of iPhoto in 2009, but it seems to still
compile and work with iPhoto 9.5 and MacOS X 10.9, so that is surprising :-)

To use, just build and run it with XCode. You will get a new tab in the
export window of iPhoto that lets you specify the identifier under which
you want to group the pictures together as well as the final path of the
photos (for my site, I use an absolute path so that it doesn't matter
where I place the HTML referencing the images).
