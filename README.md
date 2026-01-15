# triplex : Simple Tile Matching Game

A simple tile matching game made with [Flutter](https://flutter.dev).
Objective was to understand by myself how efficient Flutter is.

## Purpose
In this game, you have limited time to find matching triplets of tiles based on their attributes.
Each tile has different attributes (e.g. representation, size, color, background).

Select three tiles to form a match.

You have a valid match if, for each attribute, the three tiles are either all the same or all different.
The goal is to find as many valid matches as possible before time runs out!

For each matching tiles, a time bonus is given.
The more different attributes you have in the matching tiles, the more points you will score.
Yes, if the three tiles are the same then they are matching indeed but it to easy so no points will be given (only the time bonus).
On the contrary, if the tiles are not matching then negative points will be given (try to think better next time when selecting tiles...)

## Author
I am Laurent and I like playing with new language and computer technology. You can access my resume at https://webresume-lxxc.vercel.app.