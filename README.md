# IFS - Iterated Function Systems

<p>
<img width="256" alt="ifs-5" src="https://user-images.githubusercontent.com/45020018/168407131-861fd3a6-7b3f-42d2-87f5-d80d3ccef88e.png">
<img width="256" alt="ifs-4" src="https://user-images.githubusercontent.com/45020018/168407187-5f6d0071-79b1-4210-b22b-461b16a08324.png">
<img width="256" alt="ifs-6" src="https://user-images.githubusercontent.com/45020018/168407198-712765b6-edee-4e7d-97da-f14afcac3b13.png">
<img width="256" alt="ifs-8" src="https://user-images.githubusercontent.com/45020018/168407209-44b5db24-d87e-4a26-af20-6b8a5e0e32e6.png">
<img width="256" alt="ifs-9" src="https://user-images.githubusercontent.com/45020018/168407306-de165ecf-1ea0-43d5-886a-99942e518054.png">
<img width="256" alt="ifs-7" src="https://user-images.githubusercontent.com/45020018/168407349-5ba856a2-3d29-4c95-b5a9-c4dd4968f1d7.png">
</p>

## Usage

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
