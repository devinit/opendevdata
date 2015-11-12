gapi.analytics.ready(function() {
    /**
     * Authorize the user immediately if the user has already granted access.
     * If no access has been created, render an authorize button inside the
     * element with the ID "embed-api-auth-container".
     */
    var CLIENT_ID = '234938918280-nimcc64pmik65e05s003na432ttsi6bt.apps.googleusercontent.com';
    gapi.analytics.auth.authorize({
        container: 'embed-api-auth-container',
        clientid: CLIENT_ID
    });
    gapi.analytics.auth.on('success', function(response) {
        //hide the auth-button
        document.querySelector("#embed-api-auth-container").style.display = 'none';
    });
    var data = {
            ids: 'ga:78185827'
        }
        //rendering charts
    renderWeekOverWeekChart(data.ids);
    renderYearOverYearChart(data.ids);
    renderTopBrowsersChart(data.ids);
    renderTopCountriesChart(data.ids);
    //get stats
    //stats(data.ids);
    /**
     *Get stats
     */
    /**
     * Draw the a chart.js line chart with data from the specified view that
     * overlays session data for the current week over session data for the
     * previous week.
     */
    function renderWeekOverWeekChart(ids) {
        // Adjust `now` to experiment with different days, for testing only...
        var now = moment(); // .subtract(3, 'day');
        var thisWeek = query({
            'ids': ids,
            'dimensions': 'ga:date,ga:nthDay',
            'metrics': 'ga:sessions',
            'start-date': moment(now).subtract(1, 'day').day(0).format('YYYY-MM-DD'),
            'end-date': moment(now).format('YYYY-MM-DD')
        });
        var lastWeek = query({
            'ids': ids,
            'dimensions': 'ga:date,ga:nthDay',
            'metrics': 'ga:sessions',
            'start-date': moment(now).subtract(1, 'day').day(0).subtract(1, 'week').format('YYYY-MM-DD'),
            'end-date': moment(now).subtract(1, 'day').day(6).subtract(1, 'week').format('YYYY-MM-DD')
        });
        var pageViews = query({
            'ids': ids,
            'metrics': 'ga:pageviews',
            'start-date': moment(now).subtract(30, 'days').format('YYYY-MM-DD'),
            'end-date': moment(now).format('YYYY-MM-DD')
        });
        Promise.all([thisWeek, lastWeek, pageViews]).then(function(results) {
            var data1 = results[0].rows.map(function(row) {
                return +row[2];
            });
            var data2 = results[1].rows.map(function(row) {
                return +row[2];
            });
            var labels = results[1].rows.map(function(row) {
                return +row[0];
            });
            labels = labels.map(function(label) {
                return moment(label, 'YYYYMMDD').format('ddd');
            });
            var data = {
                labels: labels,
                datasets: [{
                    label: 'Last Week',
                    fillColor: 'rgba(220,220,220,0.5)',
                    strokeColor: 'rgba(220,220,220,1)',
                    pointColor: 'rgba(220,220,220,1)',
                    pointStrokeColor: '#fff',
                    data: data2
                }, {
                    label: 'This Week',
                    fillColor: 'rgba(151,187,205,0.5)',
                    strokeColor: 'rgba(151,187,205,1)',
                    pointColor: 'rgba(151,187,205,1)',
                    pointStrokeColor: '#fff',
                    data: data1
                }]
            };
            new Chart(makeCanvas('chart-1-container')).Line(data);
            generateLegend('legend-1-container', data.datasets);
        });
    }
    /**
     * Draw the a chart.js bar chart with data from the specified view that
     * overlays session data for the current year over session data for the
     * previous year, grouped by month.
     */
    function renderYearOverYearChart(ids) {
        // Adjust `now` to experiment with different days, for testing only...
        var now = moment(); // .subtract(3, 'day');

        var thisYear = query({
            'ids': ids,
            'dimensions': 'ga:date,ga:nthDay',
            'metrics': 'ga:sessions',
            'start-date': moment(now).subtract(30, 'days').format('YYYY-MM-DD'),
            'end-date': moment(now).format('YYYY-MM-DD')
        });

        Promise.all([thisYear]).then(function(results) {
            var data1 = results[0].rows.map(function(row) {
                return +row[2];
            });

            var labels = results[0].rows.map(function(row) {
                return +row[0];
            });

            labels = labels.map(function(label) {
                return moment(label, 'YYYYMMDD').format('DD');
            });
            var data = {
                labels: labels,
                datasets: [{
                    label: 'This Month',
                    fillColor: 'rgba(151,187,205,0.5)',
                    strokeColor: 'rgba(151,187,205,1)',
                    data: data1
                }]
            };
            new Chart(makeCanvas('chart-2-container')).Line(data);
            generateLegend('legend-2-container', data.datasets);
        }).catch(function(err) {
            console.error(err.stack);
        });
    }
    /**
     * Draw the a chart.js doughnut chart with data from the specified view that
     * show the top 5 browsers over the past seven days.
     */
    function renderTopBrowsersChart(ids) {
        query({
            'ids': ids,
            'dimensions': 'ga:operatingSystem',
            'metrics': 'ga:pageviews',
            'sort': '-ga:pageviews',
            'max-results': 5
        }).then(function(response) {
            var data = [];
            var colors = ['#4D5360', '#949FB1', '#D4CCC5', '#E2EAE9', '#F7464A'];
            response.rows.forEach(function(row, i) {
                data.push({
                    value: +row[1],
                    color: colors[i],
                    label: row[0]
                });
            });
            new Chart(makeCanvas('chart-3-container')).Doughnut(data);
            generateLegend('legend-3-container', data);
        });
    }
    /**
     * Draw the a chart.js doughnut chart with data from the specified view that
     * compares sessions from mobile, desktop, and tablet over the past seven
     * days.
     */
    function renderTopCountriesChart(ids) {
        query({
            'ids': ids,
            'dimensions': 'ga:country',
            'metrics': 'ga:sessions',
            'sort': '-ga:sessions',
            'max-results': 5
        }).then(function(response) {
            var data = [];
            var colors = ['#4D5360', '#949FB1', '#D4CCC5', '#E2EAE9', '#F7464A'];
            response.rows.forEach(function(row, i) {
                data.push({
                    label: row[0],
                    value: +row[1],
                    color: colors[i]
                });
            });
            new Chart(makeCanvas('chart-4-container')).Doughnut(data);
            generateLegend('legend-4-container', data);
        });
    }
    /**
     * Extend the Embed APIs `gapi.analytics.report.Data` component to
     * return a promise the is fulfilled with the value returned by the API.
     * @param {Object} params The request parameters.
     * @return {Promise} A promise.
     */
    function query(params) {
        return new Promise(function(resolve, reject) {
            var data = new gapi.analytics.report.Data({
                query: params
            });
            data.once('success', function(response) {
                resolve(response);
            }).once('error', function(response) {
                reject(response);
            }).execute();
        });
    }
    /**
     * Create a new canvas inside the specified element. Set it to be the width
     * and height of its container.
     * @param {string} id The id attribute of the element to host the canvas.
     * @return {RenderingContext} The 2D canvas context.
     */
    function makeCanvas(id) {
        var container = document.getElementById(id);
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        container.innerHTML = '';
        canvas.width = container.offsetWidth;
        canvas.height = container.offsetHeight;
        container.appendChild(canvas);
        return ctx;
    }
    /**
     * Create a visual legend inside the specified element based off of a
     * Chart.js dataset.
     * @param {string} id The id attribute of the element to host the legend.
     * @param {Array.<Object>} items A list of labels and colors for the legend.
     */
    function generateLegend(id, items) {
        var legend = document.getElementById(id);
        legend.innerHTML = items.map(function(item) {
            var color = item.color || item.fillColor;
            var label = item.label;
            return '<li><i style="background:' + color + '"></i>' + label + '</li>';
        }).join('');
    }
    // Set some global Chart.js defaults.
    Chart.defaults.global.animationSteps = 60;
    Chart.defaults.global.animationEasing = 'easeInOutQuart';
    Chart.defaults.global.responsive = true;
    Chart.defaults.global.maintainAspectRatio = false;
});
