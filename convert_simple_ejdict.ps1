$TargetFileName = "./ejdict-hand-utf8.txt";

class EJDictLine {
    [string]$Word
    [string]$Japanese
    EJDictLine([string]$Row) {
        $this.Word, $this.Japanese = $Row.Split("	")
    }

    [void]Print() {
        Write-Host $this.Word.PadRight(18) $this.Japanese
    }

    [bool]IsSingle() {
        return !$this.Word.Contains(" ")
    }

    [string[]]GetWords() {
        # EJDictはワードが二つあることがある genetic,genetical
        return $this.Word -split {$_ -eq ","}
    }

    [string[]]GetJapaneseWords() {
        # 単純化
        $s = [regex]::Replace($this.Japanese, "\([^)]+\)", "")
        $s = [regex]::Replace($s, "（[^)]+）", "")
        $s = [regex]::Replace($s, "‘[^)]+'", "")

        # 複数意味 / ; ,で分割
        $a = $s -split {$_ -eq "/" -or $_ -eq ";" -or $_ -eq "," -or $_ -eq "・"}

        $result = @()
        foreach($b in $a) {
            $b = [regex]::Replace($b, "『", "")
            $b = [regex]::Replace($b, "』", "")
            $b = [regex]::Replace($b, "〈[^)]+〉", "")
            $b = [regex]::Replace($b, "\[[^)]+\]", "")
            $b = [regex]::Replace($b, "《[^)]+》", "")

            $b = $b.Trim()

            if ($b.Contains("=") -or $b.Contains("…") -or $b.Contains("'")) {
                return @()
            }

            # ネストしたかっこはいったん無視😇
            if ($b.Contains(")")) {
                return @()
            }

            $result += $b
        }

        return $result
    }
}

$Lines = Get-Content -Path $TargetFileName -Encoding UTF-8 # | Get-Random -Count 10

$Result = @()
$Lines | ForEach-Object {
    $EJDictLine = [EJDictLine]::new($_)

    if (!$EJDictLine.IsSingle()) {
        return
    }

    foreach ($word in $EJDictLine.GetWords()) {
        foreach ($japanese in $EJDictLine.GetJapaneseWords()) {
            if (-not ($japanese -eq "")) {
                Write-Host ($word + "," + $japanese)
                $Result += ($word + "," + $japanese)
            }
        }
    }
}

Set-Content -Path ./dist/simple_ejdict.csv -Value $Result
