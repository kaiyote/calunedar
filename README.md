# calunedar: [see it in action](https://kaiyote.github.io/calunedar/)

It's a calendar. But with a Lunar bent. It tells you the day. Basically it.

## Features

### The App Bar
![App Bar](./assets/doc/appbar.png)

From left to right the elements are:
1. The Hamburger menu opens the Settings Drawer where you can
switch which type of calendar you want to view
2. The left arrow moves back a month
3. The text displays the Currently Displayed Month and Year in the selected calendar
4. The right arrow moves forward a month
5. The "refresh" icon will return to the current month

### The Settings Drawer
![Settings Drawer](./assets/doc/settings_drawer.png)

Here you can swap between implemented calendar types, as well as toggle settings
unique to that calendar. In the picture, the Coligny Calendar has been selected
and you can see a setting to set whether you want the metonic cycle version or
not.

### The Calendar
![Calendar](./assets/doc/calendar.png)

Its a calendar. "Today" is highlighted. Days w/ lunar events have those events
displayed on the day in question for quick viewing. Days from previous/future
months are greyed out.

### The Event Readout
![Event Readout](./assets/doc/readout.png)

Tells you what event is happening at what time on what day. It almost certainly
displays the time in your local timezone. If your screen is short enough to not
render both the calendar and the readout at the same time (likely will always
happen on landscape orientation desktop monitors), this little icon will
appear in the bottom left corner:

![Readout Link](./assets/doc/events_link.png)

Clicking on it will scroll the Readout into view.
