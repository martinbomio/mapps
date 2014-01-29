$.ajax({
            url: "/mapps/getAthleteOnTrainingData",
            type: "POST",
            data: {t:'nombreTraining', a:'1.111.111-0'},
            success: function (response){
                success(response);
        },
});

function myData(data) {
    var series1 = [];
    for(var i =0; i < data.posX.length; i ++) {
        series1.push({
            x: data.posX[i], y: data.posY[i]
        });
    }

    return [
        {
            key: "Series #1",
            values: series1,
            color: "#0000ff"
        }
    ];
}
function success(response){
    nv.addGraph(function() {
        var chart = nv.models.lineChart();

        chart.xAxis
            .axisLabel("X-axis Label");

        chart.yAxis
            .axisLabel("Y-axis Label")
            .tickFormat(d3.format("d"))
            ;

        d3.select("svg")
            .datum(myData(response))
            .transition().duration(500).call(chart);

        nv.utils.windowResize(
                function() {
                    chart.update();
                }
            );

        return chart;
    });
}