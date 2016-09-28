# rename_season
A simple script to rename ill formatted episode titles in a season of a TV show
for example:  
Its.Always.Sunny.In.Philadelphia.S05E08.720p.BluRay.x264-SiNNERS.mkv  
**would become**  
It's Always Sunny In Philadelphia S05E08 Paddy's Pub Home of the Original Kitten Mittens [720p].mkv  

###Basic Usage:
Fill out the source_dir, imdb_id, seasons at the bottom of the file with appropriate values and run it!

For multiple seasons of the same show, do the following:
1) set source_dir to the parent of all folders. ex. /Mr. Robot, with child directories of /Mr. Robot/Season 1 and /Mr. Robot/Season2
2) set seasons at the bottom of the file to have the same number. ex. "1-2" or "1,2" (also supports the form: "1,2,4-6")


###Warnings, etc:
This is the first ruby script. It probably has mistakes you would expect given that information. If you have cooler (but still readable) ways to do something, comments on Ruby style, etc. I'm more than open to feedback and want to improve.

Use at your own risk, the most likely worst case scenario is you accidently rename some stuff incorrectly, but things should be OK if you get those 3 variables setup correctly and (num files == episodes in the season)

I only tested this on OS X although I suspect it should be fairly portable, minus illegal file character checking? I guess I don't really know ;p

###Improvments for the future in no particular order:  

1. At least some basic error checking
  * files in directory == episodes in the season? (allow user to correct times when there is a "double episode" such as a finale i.e. S01E15E16 cuz that will currently bork things) 
  * check for things like the IMDB ID not existing, season not existing, the folder/files not existing, etc
2. better input sanitization (look for things that might mess up the file on the OS, characters like :\/ etc)
3. option to replace all spaces with periods (some people like that format)
4. option to exclude the [quality]
5. maybe add a gui where you can pick the directory, IMDB ID, and Season? (stretch goal, I guess)
6. Let the user choose if they want to match based off of S01E01 naming convention to allow easier matching to overcome poor ordering (currently alpha order must be perfect for dir.glob)
7. Overcome duplicate IMDB entries in the same season (i.e. S07E08 of Always Sunny)
8. Refactor the check and rename functions to be more similar, or part of the same function so that differences don't arise in the future
9. Consider changing the human matching to omit the path? Might make it easier to review
10. anything else that seems cool
