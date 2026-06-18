---
title: Sky natural time is here
created: 2026-06-18
authors:
  - avrahambenemanuel
---
Years ago, I realized something: when Shabbat comes, I shouldn't be wearing a watch. A watch is an attempt to control our day and our life, but on Shabbat, we should be free of that. I don't know exactly where that thought came from. I do know that I have a tendency to be very pedantic when it comes to being on time. Yet, part of me really wants to live in a world of fuzzy time, of approximation.

Why do I need to know exactly what time it is? It's the morning, it's the evening, it's the middle of the week, it's the beginning of the summer. There'll be a full moon tonight.

Thus, I find myself drawn to the sky and to nature to guide me through time and how I relate to it.

The project that I created here, called **Sky**, bases itself on the knowns. We know when the moon is new and when it's full. We know when the seasons begin and end. We know when sunrise and sunset are. As for the day of the week, we have a tradition of many millennia to tell us what day it is and to give us the structure of the week.

Bringing all of that together, **Sky** gives us four rings:

 * **The Season:** Defined by the equinoxes and solstices, divided simply into three parts: the beginning, the middle, and the end of the season.

 * **The Lunar Month:** Kept simple, tracking from new moon to new moon.

 * **The Week:** Rooted in tradition of the 7 day week and which day it has a long  history. 

 * **The Hour of the Day or Night:** Calculated by dividing daylight (from dawn to dusk) into 12 hours, and nighttime (from dusk to dawn) into 12 hours.

And that's it. It's a return to a more natural, rhythmic way of experiencing our lives.

I’ve built this concept into an open-source project. You can find the repository below, which generates the website, an Android app, and a companion smartwatch face so you can carry this alternative relationship with time on your wrist.

The project which started with a simple tile based design became one which is so simple.

The web site https://sky.geulah.org.il/ is still with the tiles
The apps  ![watchface](assets/images/watchface_shot.png)

   Unified four-ring "cycle" design across the phone app, home-screen widget, and Wear OS watch face, driven by a shared `:core` module.
  
   ## Design
   Four concentric notched rings, each divided into its cycle and filled clockwise from the top by progress, colored per `colors.md` (12-hue wheel):

   - **season** — 3 notches (the current season's triad)
   - **lunar** — 29 notches (one per day of the month, each in its day's wheel color)
   Four concentric notched rings, each divided into its cycle and filled clockwise from the top by progress, colored per `colors.md` (12-hue wheel):
   
   - **season** — 3 notches (the current season's triad)
   - **lunar** — 29 notches (one per day of the month, each in its day's wheel color)
   - **week** — 7 notches (per-day colors)
   - **hour** — 12 notches (the 00:00–11:00 wheel)
   
   ## Surfaces
   - **Phone app** — pure rings, no text; uses device location when granted, else the Jerusalem default.
   - **Widget** — the same rings (2×2 rings; 4×2 adds the moon).
   - **Watch face** — code-based Wear OS (Galaxy Watch 6) face with a dim monochrome ambient mode.

   ## Assets
   - `Sky-release.apk` — phone app 
   - `wear-release.apk` — watch face
   
 **Check out the project on GitHub:** [https://github.com/benemanuel/SKY/]