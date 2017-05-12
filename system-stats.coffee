command: "
scutil --get ComputerName;
system_profiler SPSoftwareDataType | head -5 | tail -1 | cut -c 23-50;
echo 'i7-6700K @ 4.70Ghz';
echo 'NVIDIA GeForce GTX 980';
echo '16 GB';

ipconfig getifaddr en0;
curl -s icanhazip.com;

then=$(sysctl kern.boottime | awk '{print $5}' | sed \"s/,//\")
now=$(date +%s)
diff=$(($now-$then))
days=$(($diff/86400));
diff=$(($diff-($days*86400)))
hours=$(($diff/3600))
diff=$(($diff-($hours*3600)));
if [ $days == 1 ]; then echo $days 'Day, '; else echo $days 'Days, '; fi; if [ $hours == 1 ]; then echo $hours 'Hour'; else echo $hours 'Hours'; fi;

X=$(/usr/sbin/netstat -ibn | awk \"/en0/\"'{print $7; exit}');
if [ -z $X ];
then echo 'Nothing Downloaded';
elif [ $X == 1 ];
  then
  echo $X ' Byte';
elif [ $X -ge 2 -a $X -le 999 ];
  then
  X=$(echo \"$X Bytes\");

elif [ $X -ge 1000 -a $X -le 999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000) }');
  X=$(echo \"$X\" | awk '{printf(\"%.1f\", $1)}');
  X=$(echo \"$X KB\");

elif [ $X -ge 1000000 -a $X -le 999999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000) }');
  X=$(echo \"$X\" | awk '{printf(\"%.2f\", $1)}');
  X=$(echo \"$X MB\");

elif [ $X -ge 1000000000 -a $X -le 999999999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000000) }');
  X=$(echo \"$X\" | awk '{printf(\"%.2f\", $1)}');
  X=$(echo \"$X GB\");

elif [ $X -ge 1000000000000  ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000000000) }');
  X=$(echo \"$X\" | awk '{printf(\"%.2f\", $1)}');
  X=$(echo \"$X TB\");
fi;
echo $X;

dir () {
X=$(ls -l /$1 | awk '{print $5}' | awk '{total = total + $1}END{print total}');
if [ -z $X ];
then echo 'Empty';
elif [ $X == 1 ];
  then
  echo $X ' Byte';
elif [ $X -ge 2 -a $X -le 999 ];
  then
  echo $X ' Bytes';
elif [ $X -ge 1000 -a $X -le 999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000) }');
  echo $X | awk '{printf(\"%.1f\", $1)}';
  echo ' KB';
elif [ $X -ge 1000000 -a $X -le 999999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000) }');
  echo $X | awk '{printf(\"%.1f\", $1)}';
  echo ' MB';
elif [ $X -ge 1000000000 -a $X -le 999999999999 ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000000) }');
  echo $X | awk '{printf(\"%.2f\", $1)}';
  echo ' GB';
elif [ $X -ge 1000000000000  ];
  then
  X=$(awk -v X=$X 'BEGIN { print ((X) / 1000000000000) }');
  echo $X | awk '{printf(\"%.2f\", $1)}';
  echo ' TB';
fi;
};
dir ~/Downloads;
dir ~/\.Trash;

disk () {
if [ ! -d $1 ];
then
echo \"Not Available\";
else
total=$(df -H $1 | tail -1 | awk '{print $2}');
used=$(df -H $1 | tail -1 | awk '{print $3}');
remaining=$(df -H $1 | tail -1 | awk '{print $4}');
percent=$(df -H $1 | tail -1 | awk '{print $5}');

echo \"$used\"B /\" $total\"B\ \"($percent Used)\";
fi;
};

disk /;
disk /Volumes/Games;
disk /Volumes/Instruments;
disk /Volumes/nas;
"

refreshFrequency: '1h'

style: """
  font-family: Myriad Pro
  font-size: 16px
  top: 10px
  left: 10px
  color: rgba(#fff, 1)
  text-align: left
  padding: 0
  margin: 0

  table tr td:nth-child(1)
  	width: 160px;



"""

render: (output) -> """
<table>
	<tr>
		<td>Computer Name:</td>
		<td class='name'></td>
	</tr>
	<tr>
		<td>Operating System:</td>
		<td class='os'></td>
	</tr>
	<tr>
		<td>CPU:</td>
		<td class='cpu'></td>
	</tr>
		<tr>
		<td>GPU:</td>
		<td class='gpu'></td>
	</tr>
	<tr>
		<td>RAM:</td>
		<td class='ram'></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Local IP:</td>
		<td class='local-ip'></td>
	</tr>
	<tr>
		<td>Public IP:</td>
		<td class='public-ip'></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Uptime:</td>
		<td class='uptime'></td>
	</tr>
	<tr>
		<td>Session Data:</td>
		<td class='session-data'></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Downloads Directory:</td>
		<td class='downloads-dir'></td>
	</tr>
	<tr>
		<td>Trash Directory:</td>
		<td class='trash-dir'></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>OSX:</td>
		<td class='osx-hd'></td>
	</tr>
	<tr>
		<td>Games:</td>
		<td class='games-hd'></td>
	</tr>
	<tr>
		<td>Instruments:</td>
		<td class='instruments-hd'></td>
	</tr>
	<tr>
		<td>NAS:</td>
		<td class='nas-hd'></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
"""

update: (output, domEl) ->
  item = output.split('\n')

  $(domEl).find(".name").html(item[0]);
  $(domEl).find(".os").html(item[1]);
  $(domEl).find(".cpu").html(item[2]);
  $(domEl).find(".gpu").html(item[3]);
  $(domEl).find(".ram").html(item[4]);

  $(domEl).find(".local-ip").html(item[5]);
  $(domEl).find(".public-ip").html(item[6]);

  $(domEl).find(".uptime").html(item[7]+item[8]);
  $(domEl).find(".session-data").html(item[9]);

  $(domEl).find(".downloads-dir").html(item[10]);
  $(domEl).find(".trash-dir").html(item[11]);

  $(domEl).find(".osx-hd").html(item[12]);
  $(domEl).find(".games-hd").html(item[13]);
  $(domEl).find(".instruments-hd").html(item[14]);
  $(domEl).find(".nas-hd").html(item[15]);
