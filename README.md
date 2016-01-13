# rename_season
A simple script to rename ill formatted episode titles in a season of a TV show
for example:  
Its.Always.Sunny.In.Philadelphia.S05E08.720p.BluRay.x264-SiNNERS.mkv  
**would become**  
It's Always Sunny In Philadelphia S05E08 Paddy's Pub Home of the Original Kitten Mittens [720p].mkv  

###Basic Usage:
fill out the source_dir, imdb_id, season_number at the bottom of the file with appropriate values and run it!

###Warnings, etc:
This is the first version of my first ruby script. It probably has mistakes you would expect given that information. If you have cooler (but still readable) ways to do something, comments on Ruby style, etc. I'm more than open to feedback and want to improve.

Use at your own risk, the most likely worst case scenario is you accidently rename some stuff incorrectly, but things should be OK if you get those 3 variables setup correctly and (num files == episodes in the season)

I only tested this on OS X although I suspect it should be fairly portable, minus illegal file character checking? I guess I don't really know ;p

###Improvments for the future in no particular order:  

1. At least some basic error checking
  * files in directory == episodes in the season? (allow user to correct times when there is a "double episode" such as a finale i.e. S01E15E16 cuz that will currently bork things) 
  * ~~fuzzy search to detect a complete mismatch, or at least provide the user w/ the ability to review the changes~~ DONE! Decided the first part probably wasn't worth implementing due to other improvements
  * check for things like the IMDB ID not existing, season not existing, the folder/files not existing, etc
2. better input sanitization (look for things that might mess up the file on the OS, characters like :\/ etc)
3. option to replace all spaces with periods (some people like that format)
4. option to exclude the [quality]
5. Potentional to make it do a whole show instead of just one season (do all ten seasons of a show that are in individual folders within a top folder)
6. maybe add a gui where you can pick the directory, IMDB ID, and Season? (stretch goal, I guess)
7. ~~update it to use 2 spaces instead of tabs for Damien~~
8. Let the user choose if they want to match based off of S01E01 naming convention to allow easier matching to overcome poor ordering (currently alpha order must be perfect for dir.glob)
  * ~~consider trying to convert all the files in the directory to lowercase first? This matters for dir.glob~~ DONE! Users are nwo prompted to review a case-insensitive regex match that looks for the same S##E## string the old file and proposed name
9. Overcome duplicate IMDB entries in the same season (i.e. S07E08 of Always Sunny)
10. Refactor the check and rename functions to be more similar, or part of the same function so that differences don't arise in the future
11. Consider changing the human matching to omit the path? Might make it easier to review
12. anything else that seems cool
