An app built while sleep deprived, to track activities with my newborn.

Feel free to grab the code and modify to meet your needs.

More details will be provided when things calm down :O)

Current dashboard example:
![dashboard](https://raw.githubusercontent.com/dcinzona/baby_tracker/assets/dashboard.png)

This app was primarily developed with a mobile use-case in mind.  The idea behind this was that the guardian / caretaker would enter the data quickly on the mobile phone, so everything is optimized for that particular story.

Here are some screenshots of the mobile UI:

<p align="center">
<img src="https://raw.githubusercontent.com/dcinzona/baby_tracker/assets/PlayTab.PNG" alt='Play Tab' 
     width="120" align="center"/>
<img src="https://raw.githubusercontent.com/dcinzona/baby_tracker/assets/Timeline.PNG" alt='Timeline'  
     width="120" align="center"/>
<img src="https://raw.githubusercontent.com/dcinzona/baby_tracker/assets/Sleeping.PNG" alt='Sleeping' 
     width="120" align="center"/>
<img src="https://raw.githubusercontent.com/dcinzona/baby_tracker/assets/PushNotifications.PNG" alt='PushNotifications'  width="120" align="center"/>
</p>

### Todo
- [ ] Support multiple babies.  I just had one so my view was pretty miopic. (This is somewhat imlemented with the data model (lookup on Contact with Baby Record Type) but is not really exposed).
- [ ] Packaged install with configuration steps
- [ ] Better support for multiple users (guardians)
- [ ] Community User support to allow for up to 25 different system users
- [ ] Timezone selection (right now, overnight sleeps break the record into two separate sleep records to be able to track how much sleep the baby got over a 24 hour period in standard reporting)

And probably a bunch of other stuff that I will never have the time to implement.


