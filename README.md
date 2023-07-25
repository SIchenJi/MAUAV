# MAUAV
1. main.m: can be run directly. Gets attitude control and position control data stored in a 2-dimensional array called show in the workspace. The flag_tracking parameter is 1 for run position control simulation and the flag_tracking parameter is 0 for run attitude control simulation.

2. sliders_show.m: must be run after main.m. Used to display the position of the three sliders in the body coordinate system, and a GIF demonstration.

3. tracking_show.m: can be run directly. It is used to present the saved data, which includes the error of the position control of the csmc and lqr algorithms in the gust of force 0 to 6.
