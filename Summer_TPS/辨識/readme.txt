1.置入.point 檔案，並檔名命名規則如下 {類別}{編號}.point 例：bus1.point
2.用matlab執行 process.m 產生.match檔案
3.用matlab執行 findrate.m 可以產生辨識率
4.用matlab修改 show.m 中fid=fopen('檔名')後執行，可以觀看單一配段結果。