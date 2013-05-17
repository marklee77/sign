<%def name="schedule(width, height, left, top)">
    <table id='schedule' class='widget' style="
        position: absolute; overflow: hidden;
        width: ${width}; top: ${top}; left: ${left};"
    />
    <script>
      var apiKey = 'FIXME';
      var calIdList = ['amac.cranfield@googlemail.com', 
                       'p2t1d9qvbg69lq59klqng5dc6s@group.calendar.google.com',
                       'ls6tjllu1ko99fl9j3vm1kpmio@group.calendar.google.com',
                       'e85187a6fn6jc818bp9mphgpmk@group.calendar.google.com',
                       'hhn8pbbqdhur0r7pq1vh1m31m8@group.calendar.google.com'];
      //               '6ciph13spq4rmq28shlai1s83s@group.calendar.google.com'];
      var ignoreTitleList = ['seminar slot', 'to be decided', 'tbd'];
      var maxMsInFuture = 7*24*60*60*1000;
      var maxResults = 20;
      var maxHeight = 640;
      var dataRefreshMs = 10*60*1000;
      var layoutRefreshMs = 30*1000;
      
      var scheduleTable = document.getElementById('schedule');
      var eventList = [];

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
            // substract off an hour + 1ms so that the time change does not make
            // easter look like it spans two days...
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

        return 0;
      }

      function updateEventList(newEventList) {
        var updatedEventList = [];
        var now = new Date();
        var i = 0, j = 0;
        while (i < eventList.length && j < newEventList.length) {

          // skip old events
          while(i < eventList.length && eventList[i].endDateTime < now) i++;
          if (i >= eventList.length) break;

          // pick a new event to add
          compVal = compareEvents(eventList[i], newEventList[j]);
          if (-1 == compVal) {
            updatedEventList.push(eventList[i++]);
          } else if (1 == compVal) { 
            updatedEventList.push(newEventList[j++]);
          } else {
            updatedEventList.push(eventList[i++]);
            j++;
          }
        }
        while (i < eventList.length) {
          updatedEventList.push(eventList[i++]);
        }
        while (j < newEventList.length) {
          updatedEventList.push(newEventList[j++]);
        }
        eventList = updatedEventList;
      }

      function dateFormat(dateTime) {
        var months = [ "January", "February", "March", "April", "May", "June",
                       "July", "August", "September", "October", "November",
                       "December" ];
        var retval = dateTime.getDate() + ' ' + months[dateTime.getMonth()];
        retval += ' ' + dateTime.getFullYear();
        return retval;
      }

      function timeFormat(dateTime) {
        var hours = dateTime.getHours();
        var minutes = dateTime.getMinutes();
        var ampm = (hours < 12) ? "am" : "pm";

        if (0 == hours) {
          hours = 12;
        } else if (hours > 12) {
          hours -= 12
        }

        if (minutes < 10) {
          minutes = '0' + minutes
        }

        return hours + ':' + minutes + ampm;
      }

      function layoutEvents() {
        var now = new Date();

        // clear out table
        while (scheduleTable.firstChild) {
          scheduleTable.removeChild(scheduleTable.firstChild);
        }

        // insert events
        var prevStartDateString = '';
        var prevEndDateString = '';     
    
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
            'width: 70px; padding: 0 10px 1px 0; vertical-align: top; text-align: right;');
          if (e.showStartTime) {
            var startText = 
              document.createTextNode(timeFormat(e.startDateTime));
            startCell.appendChild(startText);
          }
          eventRow.appendChild(startCell);
          var endCell = document.createElement('td');
          endCell.setAttribute('style', 
            'width: 70px; padding: 0 10px 1px 0; vertical-align: top; text-align: right;');
          if (e.showEndTime) {
            var endText = document.createTextNode(timeFormat(e.endDateTime));
            endCell.appendChild(endText);
          }
          eventRow.appendChild(endCell);
          var summaryCell = document.createElement('td');
          summaryCell.setAttribute('style', 
            'width: 350px; padding: 0 10px 1px 0; vertical-align: top;');
          var summaryText = document.createTextNode(e.summary)
          summaryCell.appendChild(summaryText);
          eventRow.appendChild(summaryCell);
          var locationCell = document.createElement('td'); 
          locationCell.setAttribute('style', 
            'width: 350px; padding: 0 10px 1px 0; vertical-align: top;');
          if (e.location) {
            var locationText = document.createTextNode(e.location);
            locationCell.appendChild(locationText);
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
          for (var i = 0; i < response.items.length; i++) {
              var item = response.items[i];
              if (ignoreTitleList.indexOf(item.summary.toLowerCase()) < 0) {
                newEventList.push(new Event(item));
              }
          }
          newEventList.sort(compareEvents);
          updateEventList(newEventList);
          layoutEvents();
        });
      }

      function loadEvents() {
        gapi.client.load('calendar', 'v3', function() {
          for(var i = 0; i < calIdList.length; i++) {
            loadCalendarEvents(calIdList[i]);
          }
        });
      }

      function handleClientLoad() {
        gapi.client.setApiKey(apiKey);
        loadEvents();
        setInterval(loadEvents, dataRefreshMs);
        setInterval(layoutEvents, layoutRefreshMs);
      }
    </script>
    <script src="https://apis.google.com/js/client.js?onload=handleClientLoad"></script>
</%def>
