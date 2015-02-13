# Warning

This will explain how to get started with the object tracking. I'll warn you
that this was never packaged as an easy plug-and-play solution. It was
something that I used and I've successfully shared with people that have
asked, but it takes some work learn.

# This library

You'll need to add this whole claffey_matlab to your matlab path. The object
tracking functionality is in the video folder. There's a ton of other stuff
that is completely unrelated, but there's a few misc dependencies that I
haven't bothered to separate out.

# ffmpeg

This depends on an external program called ffmpeg to explore a video into
individual images to analyze. Installing and using ffmpeg is a process in it's
own right that I won't go into, there's stuff on the web for that.

# Demo

The script that provides a demo of how to run everything together is video/vidz_demo.m. It's very similar
to what I used in the YouTube video. Copy that into your own project folder and start trying to run it. It will
probably take some tweaking.

# Quick Overview

## 1. Calibration image

You need at least 1 calibration image, which is what the background looks
like before the tracked object is introduced. The script
vidz_analyze_callibration.m is going to loop over those images and determine
some min/max values for each pixel. Once the object is introduced, if the
pixel changes outside those min/max values, it's an indication that the object
might have moved into that pixel.

## 2. Loading the video images

vidz_load_data_images.m is going to read in all your data images, which are the exploded images once the object is introduced in the movie.

## 3. Object locating

vidz_analyze_out_of_bg_minmax.m looks for data pixels that are outside the
min/max ranges set in step 1. vidz_analyze_candidate_pixels.m continues that
process. vidz_analyze_find_nonbg_object.m does the meat of the work,
identifying a contiguous set of pixels that are outside the min/max range (the
object)

