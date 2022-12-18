$TargetFileName = "./dist/simple_ejdict.csv";

$Lines = Get-Content -Path $TargetFileName -Encoding UTF-8

$result = @()
foreach ($line in $Lines) {
    $word, $japanese = $line.Split(",")

    if ($japanese -match "[a-zA-Z]") {
        continue # アルファベットが含まれている
    }

    Set-Content -Path ./tmp/in.txt -Value $japanese
    mecab ./tmp/in.txt -o ./tmp/out.txt
    $out = Get-Content -Path ./tmp/out.txt -Raw

    if ($out.Contains("助詞") -or $out.Contains("動詞") -or $out.Contains("形容詞")) {
        continue
    }

    $katakana = @()
    $mecabLine = Get-Content -Path ./tmp/out.txt
    foreach ($l in $mecabLine) {
        $l = $l.Trim()
        if ($l.Contains("EOS")) {
            continue
        }
        
        $n = $l.Split(",")
        if ($n[6].Contains("*")) {
            $katakana += $n[0].Split("	")[0]
        } else {
            $katakana += $n[7]
        }
    }

    Write-Host ($line + "," + [string]::Join("", $katakana))
    $result += ($line + "," + [string]::Join("", $katakana))
}

Set-Content -Path ./dist/noun_dict.csv -Value $result