# calunedar: [see it in action](https://kaiyote.github.io/calunedar/)

It's a calendar. But with a Lunar bent. It tells you the day. Basically it.

## Features

### Navigation
![App Bar](./assets/doc/appbar.png)

The App Bar shows the currently displayed Month & Year.
You can click on the gear to open the settings drawer.

![Bottom Navigation](./assets/doc/bottom_nav.png)

The Bottom Navigation is how you maneuver through the months in the app.
Hit Previous Month or Next Month to go to the previous or next month.
Tapping Current Month will return you to "Today".

### The Settings Drawer
![Settings Drawer](./assets/doc/settings_drawer.png)

Here you can change to 24 hour time display, swap between implemented calendar
types, as well as toggle settings unique to that calendar. In the picture, 24 Hour Time is disabled, the Coligny Calendar has been selected, and you the metonic cycle
version of the calendar has been enabled.

### The Calendar
![Calendar](./assets/doc/calendar.png)

Its a calendar. "Today" is highlighted. Days w/ lunar events have those events
displayed on the day in question for quick viewing. Days from previous/future
months are greyed out.

### The Event Readout
![Event Readout](./assets/doc/readout.png)

Tells you what event is happening at what time on what day. It almost certainly
displays the time in your local timezone, but just in case, the timezone of the
displayed time is attached to the end. It also respects the 24hr time option
from the settings above. If your screen is short enough to not render both the
calendar and the readout at the same time (likely will always happen on
landscape orientation desktop monitors), this little icon will appear in the
bottom left corner:

![Readout Link](./assets/doc/events_link.png)

Clicking on it will scroll the Readout into view.
