<%def name="schedule(width, height, left, top, 
                     apiKey, calIdList, ignoreTitleList, maxDays, maxResults, 
                     dataRefreshSeconds, layoutRefreshSeconds)">
    <%
      import os
      scheduleId = os.urandom(16).encode('hex')
      handlerId = os.urandom(16).encode('hex')
    %>
 
    <table id='${scheduleId}' style="
        position: absolute; overflow: hidden;
        width: ${width}; top: ${top}; left: ${left};"
    />

    <script>
    function f${handlerId}() {
        gapi.client.setApiKey('${apiKey}');
        var calIdList = new Array();
        % for calId in calIdList:
            calIdList.push('${calId}');
        % endfor
        var ignoreTitleList = new Array();
        % for ignoreTitle in ignoreTitleList:
            ignoreTitleList.push('${ignoreTitle}');
        % endfor
        var maxMsInFuture = ${maxDays}*24*60*60*1000;
        var maxResults = ${maxResults};
        var maxHeight = 640; // FIXME
        var dataRefreshMs = ${dataRefreshSeconds}*1000;
        var layoutRefreshMs = ${layoutRefreshSeconds}*1000;
      
        var scheduleTable = document.getElementById('${scheduleId}');
        var eventLists = new Array();

        function Event(item) {
            this.summary = item.summary;
            if (item.location) {
                this.location = item.location;
            }
            if (item.start.dateTime) {
                this.startDateTime = new Date(item.start.dateTime);
                this.showStartTime = true;
            } else if (item.start.date) {
                this.startDateTime = new Date(item.start.date);
                this.showStartTime = false;
            }
            if (item.end.dateTime) {
                this.endDateTime = new Date(item.end.dateTime)
                this.showEndTime = true;
            } else if (item.end.date) {
                // all day events show as ending FOLLOWING date on google cal...
                var tmpEndDateTime = new Date(item.end.date);
                // substract off an hour + 1ms so that the time change does not 
                // make easter look like it spans two days...
                this.endDateTime = new Date(tmpEndDateTime.getTime() - 3600001);
                this.showEndTime = false;
            }
        }

        function compareEvents(a, b) {

            if (a.startDateTime < b.startDateTime) {
                return -1;
            } else if (a.startDateTime > b.startDateTime) {
                return 1;
            }

            if (a.endDateTime < b.endDateTime) {
                return -1;
            } else if (a.endDateTime > b.endDateTime) {
                return 1;
            }

            if (a.summary < b.summary) {
                return -1;
            } else if (a.summary > b.summary) {
                return 1;
            }

            if (a.location < b.location) {
                return -1;
            } else if (a.location > b.location) {
                return 1;
            }

            return 0;
        }

        function dateFormat(dateTime) {

            //return dateTime.toLocaleDateString();

            var months = [ "January", "February", "March", "April", "May", 
                           "June", "July", "August", "September", "October", 
                           "November", "December" ];
            var retval = dateTime.getDate() + ' ' + months[dateTime.getMonth()];
            retval += ' ' + dateTime.getFullYear();
            return retval;

        }

        function timeFormat(dateTime) {

            var hours = dateTime.getHours();
            var minutes = dateTime.getMinutes();

            if (minutes < 10) {
                minutes = '0' + minutes
            }

            return hours + ':' + minutes;
        }

        // FIXME: there is probably a cleaner way to do this with a library
        function mergeEventLists() {
            var mergeList = [];
            var eventList = [];

            for(var calId in eventLists) {
                mergeList = mergeList.concat(eventLists[calId]);
            }

            mergeList.sort(compareEvents);

            lastItem = null;
            for(var i = 0; i < mergeList.length; i++) {
                currItem = mergeList[i];
                if (null == lastItem || 0 != compareEvents(lastItem, currItem)) {
                    eventList.push(currItem);
                    lastItem = currItem;
                }
            }

            return eventList; 
        }

        // FIXME: this could be made a little more modular/less repetitive.
        function layoutEvents() {
            var now = new Date();

            // clear out table
            while (scheduleTable.firstChild) 
                scheduleTable.removeChild(scheduleTable.firstChild);

            // insert events
            var prevStartDateString = '';
            var prevEndDateString = '';     

            var eventList = mergeEventLists();
        
            for(var i = 0; i < eventList.length; i++) {
                var e = eventList[i];
                var startDateString = dateFormat(e.startDateTime);
                var endDateString = dateFormat(e.endDateTime);
                var dateRow = null;

                if (startDateString != prevStartDateString || 
                  endDateString != prevEndDateString) {
                    dateRow = document.createElement('tr');
                    var dateCell = document.createElement('td');
                    dateCell.setAttribute('colspan', 4);
                    var dateTextString = startDateString;
                    if (startDateString != endDateString) {
                        dateTextString += ' - ' + endDateString;
                    }
                    dateCell.innerHTML = dateTextString.bold();
                    dateRow.appendChild(dateCell);
                    scheduleTable.appendChild(dateRow);
                    prevStartDateString = startDateString;
                    prevEndDateString = endDateString;
                }

                var eventRow = document.createElement('tr');

                if (e.startDateTime <= now && now <= e.endDateTime) {
                    eventRow.setAttribute('style', 'color: red;');
                }

                var startCell = document.createElement('td');
                startCell.setAttribute('style', 
                  'width: 70px; padding: 0 10px 1px 0; ' + 
                  'vertical-align: top; text-align: right;');
                if (e.showStartTime) {
                    var startText = 
                      document.createTextNode(timeFormat(e.startDateTime));
                    startCell.appendChild(startText);
                }
                eventRow.appendChild(startCell);
                var endCell = document.createElement('td');
                endCell.setAttribute('style', 
                  'width: 70px; padding: 0 10px 1px 0; ' + 
                  'vertical-align: top; text-align: right;');
                if (e.showEndTime) {
                    var endText = 
                      document.createTextNode(timeFormat(e.endDateTime));
                    endCell.appendChild(endText);
                }
                eventRow.appendChild(endCell);
                var summaryCell = document.createElement('td');
                summaryCell.setAttribute('style', 
                  'width: 350px; padding: 0 10px 1px 0; vertical-align: top;');
                var summaryText = 
                    document.createTextNode(e.summary);
                summaryCell.appendChild(summaryText);
                eventRow.appendChild(summaryCell);
                var locationCell = document.createElement('td'); 
                locationCell.setAttribute('style', 
                  'width: 350px; padding: 0 10px 1px 0; vertical-align: top;');
                if (e.location) {
                    //var locationText = document.createTextNode(e.location);
                    //locationCell.appendChild(locationText);
                    // FIXME: hardcoded value...
                    var location = e.location;
                    if (location.length > 30) {
                        location = location.replace(/,/, ',<br />');
                    }
                    locationCell.innerHTML = location;
                }
                eventRow.appendChild(locationCell);
                scheduleTable.appendChild(eventRow);
                if (scheduleTable.clientHeight > maxHeight) {
                    if (dateRow) {
                      scheduleTable.removeChild(dateRow);
                    }
                    scheduleTable.removeChild(eventRow);
                    return;
                }
            }

        }

        function loadCalendarEvents(calId) {
            var now = new Date();
            var timeMax = new Date(now.getTime() + maxMsInFuture);
            var request = gapi.client.calendar.events.list({
              'calendarId': calId,
              'singleEvents': 'true',
              'timeMin': now,
              'timeMax': timeMax,
              'maxResults': maxResults,
              'orderBy': 'startTime'
            });
            request.execute(function(response) {
                var newEventList = new Array();
                if (response.items) {
                    for (var i = 0; i < response.items.length; i++) {
                        var item = response.items[i];
                        if (ignoreTitleList.indexOf(item.summary.toLowerCase()) 
                          < 0) {
                            newEventList.push(new Event(item));
                        }
                    }
                }
                eventLists[calId] = newEventList;
                layoutEvents();
            });
        }

        function loadEvents() {
            gapi.client.load('calendar', 'v3', function() {
                for(var i = 0; i < calIdList.length; i++) 
                    loadCalendarEvents(calIdList[i]);
            });
        }

        loadEvents();
        setInterval(loadEvents, dataRefreshMs);
        setInterval(layoutEvents, layoutRefreshMs);
    }
    </script>
    <script src="https://apis.google.com/js/client.js?onload=f${handlerId}"
        ></script>
</%def>
