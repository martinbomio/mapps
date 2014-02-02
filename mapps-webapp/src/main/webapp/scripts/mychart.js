function draw_chart(training){
	window.athleteData = [];
	window.athleteIndex = 0;
	for (var i = 0; i< training.athletes.length; i++){
		$.ajax({
		            url: "/mapps/getAthleteOnTrainingData",
		            type: "POST",
		            data: {t:training.name, a:training.athletes[i].idDocument},
		            success: function (response){
		            	if (window.created){
		            		update_values(response);
		            	}else{
		            		create_label(response);
		            		window.created = true;
		            	}
		                window.athleteData.push(response);
		                window.athleteIndex+=1;
		                if (window.athleteIndex == training.athletes.length){
		                	success();
		                }
		        },
		});
	}
}
function myData(data) {
	var data = window.athleteData;
	var series = [];
	for(var i = 0 ; i<data.length; i++){
		var series1 = [];
	    for(var j =0; j < data[i].posX.length; j ++) {
	        series1.push({
	            x: data[i].posX[j], y: data[i].posY[j]
	        });
	    }
	    var ret = {
	                   key: data[i].athlete.name,
	                   values: series1,
	                   color: "#0000ff"
	               };
	    series.push(ret);
	}
    return series;
}


function success(){
    nv.addGraph(function() {
        var chart = nv.models.lineChart().forceY([0, 60]).forceX([-55, 55]);

        chart.xAxis
            .axisLabel("Posicion X");

        chart.yAxis
            .axisLabel("Posicion Y")
            .tickFormat(d3.format("d"))
            ;

        d3.select("svg")
            .datum(myData())
            .transition().duration(500).call(chart);

        nv.utils.windowResize(
                function() {
                    chart.update();
                }
            );

        return chart;
    });
}

function create_label(data){
	var athlete = data.athlete;
	var distance = new String(data.traveledDistance);
	var split = distance.split('.');
	var distance = split[0] + '.' + split[1].substr(0,1);
	split = new String(data.averageSpeed).split('.');
	var speed = split[0] + '.' + split[1].substr(0,1);
	var players_div = $("#list_players");
	var first_div = $('<div id="'+athlete.idDocument+'" class="display_player"></div');
	var div_up = $('<a href="athletes/player_view_training.jsp?a='+athlete.idDocument+'&t='+data.trainingName+'"><div id="up" style="width:100%; height:60%;"><div id="img" style="display:inline-block; width:35%; height:100%;"><img src="'+athlete.imageURI+'" style="height:55px; margin-top:5px; vertical-align:middle"/></div><div id="name" style="display:inline-block; font-size:14px; width:60%; height:100%;">'+athlete.name+' '+athlete.lastName+'</div></div></a>');
	var div_down = $('<div id="down" style="width:100%; height:40%;"><div id="info_distance" class="tab_player_login"><div class="tag_info_player_login"> Distancia</div><div id="distance_'+athlete.i+'" class="tag_data_player_login"> '+ distance +' mts </div></div><div id="info_speed" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Velocidad Promedio</div><div id="speed_'+athlete.id+'" class="tag_data_player_login"> '+speed+' km/h </div></div><div id="info_heart" class="tab_player_login" style="border-left:solid 1px;"><div class="tag_info_player_login"> Pulso</div><div id="pulse_'+athlete.id+'" class="tag_data_player_login"> '+data.pulse[data.pulse.length-1]+' bpm </div></div></div>');
	first_div.append(div_up);
	first_div.append(div_down);
	players_div.append(first_div);
}

function update_values(data){
	var athlete = data.athlete;
	var distance = new String(data.traveledDistance);
	var split = distance.split('.');
	var distance = split[0] + '.' + split[1].substr(0,1);
	split = new String(data.averageSpeed).split('.');
	var speed = split[0] + '.' + split[1].substr(0,1);
	$('#distance_'+athlete.id+'').text(distance + " mts");
	$('#speed_'+athlete.id+'').text(speed + " km/h");
	$('#pulse_'+athlete.id+'').text(data.pulse[data.pulse.length-1] + " bpm");
}