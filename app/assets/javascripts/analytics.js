gapi.analytics.ready(function() {
    // Step 3: Authorize the user.
    var CLIENT_ID = '234938918280-nimcc64pmik65e05s003na432ttsi6bt.apps.googleusercontent.com';
    gapi.analytics.auth.authorize({
        container: 'auth-button',
        clientid: CLIENT_ID,
    });
    // Step 4: Create the view selector.
    /*
      var viewSelector = new gapi.analytics.ViewSelector({
        container: 'view-selector'
      });
    */
    // Step 5: Create the timeline chart.
    var timeline = new gapi.analytics.googleCharts.DataChart({
        reportType: 'ga',
        query: {
            'dimensions': 'ga:date',
            'metrics': 'ga:sessions',
            'start-date': '30daysAgo',
            'end-date': 'yesterday',
        },
        chart: {
            type: 'LINE',
            container: 'timeline'
        }
    });
    var dataChart = new gapi.analytics.googleCharts.DataChart({
        query: {
            metrics: 'ga:sessions',
            dimensions: 'ga:country',
            'start-date': '30daysAgo',
            'end-date': 'yesterday',
            'max-results': 6,
            sort: '-ga:sessions'
        },
        chart: {
            container: 'pie',
            type: 'PIE',
            options: {
                width: '100%',
                pieHole: 4 / 9
            }
        }
    });


    function makeApiCall() {
        var apiQuery = gapi.client.analytics.data.ga.get({
            'ids': "table",
            'start-date': '2010-01-01',
            'end-date': '2010-01-15',
            'metrics': 'ga:sessions',
            'dimensions': 'ga:source,ga:keyword',
            'sort': '-ga:sessions,ga:source',
            'filters': 'ga:medium==organic',
            'max-results': 25
        });
        apiQuery.execute(handleCoreReportingResults);
    }

    function handleCoreReportingResults(results) {
        if (!results.error) {
            console.log(results);
        } else {
            alert('There was an error: ' + results.message);
        }
    }
    makeApiCall();
    // Step 6: Hook up the components to work together.
    gapi.analytics.auth.on('success', function(response) {
        //viewSelector.execute();
        var ids = {
            query: {
                ids: 'ga:78185827'
            }
        }
        $("#auth-button").hide();
        dataChart.set(ids).execute();
        timeline.set(ids).execute();
    });
});
