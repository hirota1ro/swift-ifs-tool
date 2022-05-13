# IFS - Iterated Function Systems

create image
```
swift run Ifs ~/swift-ifs-tool/json/fig4a.json -o ~/Downloads/fig4a.png
```

create high quority image
```
swift run Ifs ~/swift-ifs-tool/json/fig4a.json -d 4 -o ~/Downloads/fig4ax4.png
```

create high quority image (about 10 mins).
```
swift run Ifs ~/swift-ifs-tool/json/fig4a.json -N 10000000 -d 4 -o ~/Downloads/x4.png
```

search
```
swift run Ifs search -o ~/tmp/ifs/found.json
```

export as csv
```
swift run Ifs export ~/tmp/ifs/found.json -o ~/tmp/ifs/export.csv
```
