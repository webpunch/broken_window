$(() => {
  /**
   * Create a constructor for sparklines that takes some sensible defaults and merges in the individual
   * chart options. This function is also available from the jQuery plugin as $(element).highcharts('SparkLine').
   */
  Highcharts.SparkLine = function (a, b, c) {
    var hasRenderToArg = typeof a === 'string' || a.nodeName,
        options = arguments[hasRenderToArg ? 1 : 0],
        defaultOptions = {
            chart: {
                renderTo: (options.chart && options.chart.renderTo) || this,
                backgroundColor: null,
                borderWidth: 0,
                type: 'area',
                margin: [2, 0, 2, 0],
                width: 120,
                height: 20,
                style: {
                    overflow: 'visible'
                },

                // small optimalization, saves 1-2 ms each sparkline
                skipClone: true
            },
            title: {
                text: ''
            },
            credits: {
                enabled: false
            },
            xAxis: {
                labels: {
                    enabled: false
                },
                title: {
                    text: null
                },
                startOnTick: false,
                endOnTick: false,
                tickPositions: []
            },
            yAxis: {
                endOnTick: false,
                startOnTick: false,
                labels: {
                    enabled: false
                },
                title: {
                    text: null
                },
                tickPositions: [0]
            },
            legend: {
                enabled: false
            },
            tooltip: {
                hideDelay: 0,
                outside: true,
                shared: true
            },
            plotOptions: {
                series: {
                    animation: false,
                    lineWidth: 1,
                    shadow: false,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    },
                    marker: {
                        radius: 1,
                        states: {
                            hover: {
                                radius: 2
                            }
                        }
                    },
                    fillOpacity: 0.25
                },
                column: {
                    negativeColor: '#910000',
                    borderColor: 'silver'
                }
            }
        };

    options = Highcharts.merge(defaultOptions, options);

    return hasRenderToArg ?
        new Highcharts.Chart(a, options, c) :
        new Highcharts.Chart(options, b);
  };

  var start = +new Date(),
    $divs = $('div[data-sparkline]'),
    fullLen = $divs.length,
    n = 0;

  // Creating sparkline charts is quite fast in modern browsers, but IE8 and mobile
  // can take some seconds, so we split the input into chunks and apply them in timeouts
  // in order avoid locking up the browser process and allow interaction.
  function doChunk() {
    var time = +new Date(),
        i,
        len = $divs.length,
        $div,
        data,
        chart;

    for (i = 0; i < len; i += 1) {
        $div = $($divs[i]);
        data = $div.data('sparkline').map((datum) => [Date.parse(datum.date), +datum.value]);

        chart = {
          width: $div.data('width'),
          height: $div.data('height'),
        };

        $div.highcharts('SparkLine', {
            series: [{
                data: data,
            }],
            tooltip: {
                headerFormat: 'Value: <b>{point.y}' + $div.data('value-type') + '</b><br/>',
                pointFormat: '{point.x:%Y-%m-%d}'
            },
            chart: chart,
            yAxis: {
              plotLines: [{
                value: $div.data('critical-value'),
                color: 'black',
                dashStyle: 'shortdash',
                width: 2,
              }],
            }
        });

        n += 1;

        // If the process takes too much time, run a timeout to allow interaction with the browser
        if (new Date() - time > 500) {
            $divs.splice(0, i + 1);
            setTimeout(doChunk, 0);
            break;
        }

        // Print a feedback on the performance
        if (n === fullLen) {
            $('#result').html('Generated ' + fullLen + ' sparklines in ' + (new Date() - start) + ' ms');
        }
    }
  }
  doChunk();
})
