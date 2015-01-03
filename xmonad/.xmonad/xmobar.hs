Config { font = "-*-terminus-*-*-*-*-14-*-*-*-*-*-*-*"
    , bgColor = "#000000"
    , fgColor = "grey"
    , position = TopW L 90
    , commands = [ Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                 , Run Memory ["-t","Mem: <usedratio>%","-L","5","-H","60","--normal","green","--high","red"] 10
                 , Run Network "enp3s0" ["-L","0","-H","70","--normal","green","--high","red"] 10
                 , Run Date "%A %b %_d %H:%M" "date" 100
                 --, Run Volume ""
                 , Run StdinReader
                 ]
    , sepChar = "%"
    , alignSep = "}{"
    , template = " %StdinReader%}{ %cpu% | %memory% | %enp3s0% | <fc=#ee9a00>%date%</fc> "
}
