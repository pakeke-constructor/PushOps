
# okay we gotta really think about this.
This could easily spagettify and ruin everything, so lets
jot some ideas down:



-   :fullLoad(player)   called once, when the upgrade is loaded
-   :fullReset(player)  called once, when the upgrade is removed. 
                    (when run resets, NOT WHEN GOING NEXT LEVEL!!!)


- :load(player)
- :reset(player)
These r called whenever player destructs and reassembles.
(i.e. are called multiple times in a run, across levels.)





