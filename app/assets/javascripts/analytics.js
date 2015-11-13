gapi.analytics.ready(function() {
    //run anlytics dashboard
    init();
    //get stats
    function init() {
        //get fresh data or use session data
        //check if session data exists
        var data = sessionStorage.getItem('analytics');
        data ? visualize(JSON.parse(data)) : remoteData(visualize);
    }

    function visualize(data) {
        renderWeekOverWeekChart(data)
        renderYearOverYearChart(data);
        renderTopBrowsersChart(data);
        renderTopCountriesChart(data);
        renderVisitors(data);
        renderOverView(data)
        $("#page-views").text(data.stats[0][0]);
        $("#page-sessions").text(data.stats[0][1]);
    }

    function remoteData() {
        var url = "http://" + window.location.host + "/data";
        $.get(url, function(data) {
            storage(data)
            visualize(data);
        }).done(function() {
            console.log("API call successful")
        }).error(function(error) {
            alert(error);
        })
    }
    //local data storage
    function storage(data) {
        session_data = JSON.stringify(data);
        sessionStorage.setItem('analytics', session_data);
    }

    function renderOverView(results) {
        var data1 = results.overview.map(function(row) {
            return +row[1];
        });
        var labels = results.overview.map(function(row) {
            return +row[0];
        });
        labels = labels.map(function(label, index) {
            if (index % 4 === 0) {
                return moment(label, 'YYYYMMDD').format('DD');
            } else {
                return "";
            }
        });
        var data = {
            labels: labels,
            showTooltips: false,
            datasets: [{
                label: 'OverView',
                fillColor: 'rgba(220,220,220,0.5)',
                strokeColor: 'rgba(220,220,220,1)',
                pointColor: 'rgba(220,220,220,1)',
                pointStrokeColor: '#fff',
                data: data1
            }]
        };
        new Chart(makeCanvas('chart-5-container')).Line(data);
        generateLegend('legend-5-container', data.datasets);
    }
    /**
     * Draw the a chart.js line chart with data from the specified view that
     * overlays session data for the current week over session data for the
     * previous week.
     */
    function renderWeekOverWeekChart(results) {
        var data1 = results.thisWeek.map(function(row) {
            return +row[2];
        });
        var data2 = results.lastWeek.map(function(row) {
            return +row[2];
        });
        var labels = results.thisWeek.map(function(row) {
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
    }
    /**
     * Draw the a chart.js bar chart with data from the specified view that
     * overlays session data for the current year over session data for the
     * previous year, grouped by month.
     */
    function renderYearOverYearChart(results) {
        // Adjust `now` to experiment with different days, for testing only...
        var data1 = results.thisYear.map(function(row) {
            return +row[2];
        });
        var data2 = results.lastYear.map(function(row) {
            return +row[2];
        });
        var labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        // Ensure the data arrays are at least as long as the labels array.
        // Chart.js bar charts don't (yet) accept sparse datasets.
        for (var i = 0, len = labels.length; i < len; i++) {
            if (data1[i] === undefined) data1[i] = null;
            if (data2[i] === undefined) data2[i] = null;
        }
        var data = {
            labels: labels,
            datasets: [{
                label: 'Last Year',
                fillColor: 'rgba(220,220,220,0.5)',
                strokeColor: 'rgba(220,220,220,1)',
                data: data2
            }, {
                label: 'This Year',
                fillColor: 'rgba(151,187,205,0.5)',
                strokeColor: 'rgba(151,187,205,1)',
                data: data1
            }]
        };
        new Chart(makeCanvas('chart-2-container')).Bar(data);
        generateLegend('legend-2-container', data.datasets);
    }
    /**
     * Draw the a chart.js doughnut chart with data from the specified view that
     * show the top 5 browsers over the past seven days.
     */
    function renderTopBrowsersChart(response) {
        var data = [];
        var colors = ['#4D5360', '#949FB1', '#D4CCC5', '#E2EAE9', '#F7464A'];
        response.os.forEach(function(row, i) {
            data.push({
                value: +row[1],
                color: colors[i],
                label: row[0]
            });
        });
        new Chart(makeCanvas('chart-3-container')).Doughnut(data);
        generateLegend('legend-3-container', data);
    }
    /**
     * Draw the a chart.js doughnut chart with data from the specified view that
     * compares sessions from mobile, desktop, and tablet over the past seven
     * days.
     */
    function renderTopCountriesChart(response) {
        var data = [];
        var colors = ['#4D5360', '#949FB1', '#D4CCC5', '#E2EAE9', '#F7464A'];
        response.countries.forEach(function(row, i) {
            data.push({
                label: row[0],
                value: +row[1],
                color: colors[i]
            });
        });
        new Chart(makeCanvas('chart-4-container')).Doughnut(data);
        generateLegend('legend-4-container', data);
    }

    function renderVisitors(response) {
        var data = [];
        var colors = ['#4D5360', '#949FB1'];
        response.visitors.forEach(function(row, i) {
            data.push({
                label: row[0],
                value: +row[1],
                color: colors[i]
            });
        });
        new Chart(makeCanvas('chart-6-container')).Doughnut(data);
        generateLegend('legend-6-container', data);
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
