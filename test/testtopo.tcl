source /home/wenjun/音乐/ns-allinone-2.35/ns-2.35/test/ReadFile.tcl;   #author by
set pathNum 4
set lineRateDown 1Gb
set lineRateUp 1Gb
set packetSize 1460
set RTT 0.0001
set K 65
set startSwitchID 0

set longfno 0
set shortfno 30

set N 8
set B 250

set simulationTime 1.0

set startMeasurementTime 1
set stopMeasurementTime 2
set flowClassifyTime 0.001

set sourceAlg DC-TCP-Sack
set switchAlg RED


set DCTCP_g_ 0.0625
set ackRatio 1 
set packetSize 1460
 
set traceSamplingInterval 0.0001
set throughputSamplingInterval 0.01
set enableNAM 0

set ns [new Simulator]

Node set multiPath_ 1
Classifier/MultiPath set perflow_ 1
Classifier/MultiPath set checkpathid_ 1

Agent/TCP set ecn_ 1
Agent/TCP set old_ecn_ 1
Agent/TCP set packetSize_ $packetSize
Agent/TCP/FullTcp set segsize_ $packetSize
Agent/TCP set window_ 1256
Agent/TCP set slow_start_restart_ false
Agent/TCP set tcpTick_ 0.01
Agent/TCP set minrto_ 0.01 ; # minRTO = 200ms
Agent/TCP set windowOption_ 0

#if {[string compare $sourceAlg "DC-TCP-Sack"] == 0} {
    Agent/TCP set dctcp_ true
    Agent/TCP set dctcp_g_ $DCTCP_g_;
#}
Agent/TCP/FullTcp set segsperack_ $ackRatio; 
Agent/TCP/FullTcp set spa_thresh_ 3000;
Agent/TCP/FullTcp set interval_ 0.04 ; #delayed ACK interval = 40ms

Queue set limit_ 1000

Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ true
Queue/RED set mean_pktsize_ $packetSize
Queue/RED set setbit_ true
Queue/RED set gentle_ false
Queue/RED set q_weight_ 1.0
Queue/RED set mark_p_ 1.0
Queue/RED set thresh_ [expr $K]
Queue/RED set maxthresh_ [expr $K]
			 
DelayLink set avoidReordering_ true

set f [open ps.tr w]
$ns trace-all $f
set nf [open ps.nam w]
$ns namtrace-all $nf

set now [$ns now]
set now [format "%.6f" $now];
set linkIDTrace [open linkIDTrace.tr w]
set simpleLinkTrace [open simpleLinkTrace.tr w]
set storedStartSwitchIDFile [open storedStartSwitchID.tr w]
puts $storedStartSwitchIDFile "startSwitchID $startSwitchID pathnum $pathNum $now"
close $storedStartSwitchIDFile

$ns color 1 Red
$ns color 2 Yellow
$ns color 3 Green

#node
for {set i 0} {$i<[expr $pathNum+2]} {incr i} {
    set n($i) [$ns node]
}
for {set i 1000} {$i<[expr $shortfno+1000]} {incr i} {
    set n($i) [$ns node]
}
for {set i 2000} {$i<[expr $longfno+2000]} {incr i} {
    set n($i) [$ns node]
}
for {set i 3000} {$i<[expr $shortfno+3000]} {incr i} {
    set n($i) [$ns node]
}
for {set i 4000} {$i<[expr $longfno+4000]} {incr i} {
    set n($i) [$ns node]
}

#link
for {set i 1000} {$i<[expr $shortfno+1000]} {incr i} {
    $ns simplex-link $n($i) $n(0) $lineRateUp [expr $RTT/8] DropTail
    $ns simplex-link $n(0) $n($i) $lineRateUp [expr $RTT/8] RED
    $ns queue-limit $n($i) $n(0) 2000
}

for {set i 2000} {$i<[expr $longfno+2000]} {incr i} {
    $ns simplex-link $n($i) $n(0) $lineRateUp [expr $RTT/8] DropTail
    $ns simplex-link $n(0) $n($i) $lineRateUp [expr $RTT/8] RED
    $ns queue-limit $n($i) $n(0) 2000
}

for {set i 1} {$i<[expr $pathNum+1]} {incr i} {
    $ns duplex-link $n(0) $n($i) $lineRateDown [expr $RTT/8] RED
    $ns queue-limit $n(0) $n($i) 256
}

#$ns simplex-link $n(0) $n(2) $lineRateDown [expr $RTT/8+0.000276] RED
#$ns simplex-link $n(2) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(2) 256
#$ns simplex-link $n(0) $n(3) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(3) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(3) 256
#$ns simplex-link $n(0) $n(4) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(4) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(4) 256
#$ns simplex-link $n(0) $n(5) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(5) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(5) 256
#$ns simplex-link $n(0) $n(6) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(6) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(6) 256
#$ns simplex-link $n(0) $n(7) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(7) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(7) 256
#$ns simplex-link $n(0) $n(8) $lineRateDown [expr $RTT/8+0.000240] RED
#$ns simplex-link $n(8) $n(0) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(8) 256



#$ns duplex-link $n(0) $n(8) 1Gb [expr $RTT/8] RED
#$ns queue-limit $n(0) $n(8) 256

for {set i 1} {$i<[expr $pathNum+1]} {incr i} {
    $ns duplex-link $n($i) $n([expr $pathNum+1]) $lineRateDown [expr $RTT/8] RED
    $ns queue-limit $n($i) $n([expr $pathNum+1]) 256
}

#$ns simplex-link $n(10) $n(11) $lineRateDown [expr $RTT/8+2*$RTT] RED
#$ns simplex-link $n(11) $n(10) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(10) $n(11) 256

#$ns duplex-link $n(8) $n(9) $lineRateDown [expr $RTT/8] RED
#$ns queue-limit $n(8) $n(9) 256

for {set i 3000} {$i<[expr $shortfno+3000]} {incr i} {
    $ns simplex-link $n([expr $pathNum+1]) $n($i) $lineRateUp [expr $RTT/8] RED
	$ns simplex-link $n($i) $n([expr $pathNum+1]) $lineRateUp [expr $RTT/8] DropTail
	$ns queue-limit $n([expr $pathNum+1]) $n($i) 256
	$ns queue-limit $n($i) $n([expr $pathNum+1]) 256
}

for {set i 4000} {$i<[expr $longfno+4000]} {incr i} {
    $ns simplex-link $n([expr $pathNum+1]) $n($i) $lineRateUp [expr $RTT/8] RED
	$ns simplex-link $n($i) $n([expr $pathNum+1]) $lineRateUp [expr $RTT/8] DropTail
	$ns queue-limit $n([expr $pathNum+1]) $n($i) 256
	$ns queue-limit $n($i) $n([expr $pathNum+1]) 256
}
#tcp agent
#for {set i 0} {$i<$shortfno} {incr i} {
#set tcp($i) [new Agent/TCP/FullTcp/Newreno]
#	set shortnode [expr $i+1000]
#	$ns attach-agent $n($shortnode) $tcp($i)
#	$tcp($i) set fid_ $i
#}
#for {set i $shortfno} {$i < [expr $shortfno + $longfno] } {incr i} {
#set tcp($i) [new Agent/TCP/FullTcp/Newreno]
#   set longnode [expr $i - $shortfno + 2000]
#   $ns attach-agent $n($longnode) $tcp($i)
#   $tcp($i) set fid_  $i
#}

for {set i 0} {$i < $shortfno } {incr i} {
    if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	set tcp($i) [new Agent/TCP/FullTcp/Newreno]
        set shortnode [expr $i +1000]
        $ns attach-agent $n($shortnode) $tcp($i)
        $tcp($i) set fid_  $i 
	
    }
    if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DC-TCP-Sack"] == 0} { 
        set tcp($i) [new Agent/TCP/FullTcp/Sack]
        set shortnode [expr $i +1000]
        $ns attach-agent $n($shortnode) $tcp($i)
        $tcp($i) set fid_  $i 

    }
     
}  

for {set i $shortfno} {$i < [expr $longfno+$shortfno] } {incr i} {
    if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	set tcp($i) [new Agent/TCP/FullTcp/Newreno]
        set longnode [expr $i - $shortfno + 2000] 
        $ns attach-agent $n($longnode) $tcp($i)
        $tcp($i) set fid_  $i+1000 
	
    }
    if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DC-TCP-Sack"] == 0} { 
        set tcp($i) [new Agent/TCP/FullTcp/Sack]
        set longnode [expr $i - $shortfno + 2000] 
        $ns attach-agent $n($longnode) $tcp($i)
        $tcp($i) set fid_  $i+1000 

    }
     
}

$ns rtproto DV
Agent/rtProto/DV set advertInterval 16
#sink agent
#for {set i 0} {$i<$longfno} {incr i} {
#    set sinkno [expr $i+3000]
#	set sink($i) [new Agent/TCP/FullTcp/Newreno]
#	$sink($i) listen 
#	$ns attach-agent $n($sinkno) $sink($i)
#	$ns connect $tcp($i) $sink($i)
#}
#for {set i $shortfno} {$i <  [expr $shortfno + $longfno] } {incr i} {
#   set sinkno [expr $i - $shortfno + 4000]
#   set sink($i) [new Agent/TCP/FullTcp/Newreno]
#	$sink($i) listen 
#   $ns attach-agent $n($sinkno) $sink($i)
#   $ns connect $tcp($i) $sink($i)
#}

for {set i 0} {$i < $shortfno } {incr i} {
    if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	#set sink($i) [new Agent/TCPSink]
        set sink($i) [new Agent/TCP/FullTcp/Newreno]
	$sink($i) listen
        set sinkno [expr $i+3000]
        $ns attach-agent $n($sinkno) $sink($i)
        $ns connect $tcp($i) $sink($i)
    }
    if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DC-TCP-Sack"] == 0} {
	set sink($i) [new Agent/TCP/FullTcp/Sack]
        set sinkno [expr $i+3000]
        $ns attach-agent $n($sinkno) $sink($i)
        $ns connect $tcp($i) $sink($i)
	$sink($i) listen
    }    
}

for {set i $shortfno} {$i <  [expr $longfno+$shortfno] } {incr i} {
    if {[string compare $sourceAlg "Newreno"] == 0 || [string compare $sourceAlg "DC-TCP-Newreno"] == 0} {
	#set sink($i) [new Agent/TCPSink]
        set sink($i) [new Agent/TCP/FullTcp/Newreno]
	$sink($i) listen
        set sinkno [expr $i - $shortfno + 4000]
        $ns attach-agent $n($sinkno) $sink($i)
        $ns connect $tcp($i) $sink($i)
    }
    if {[string compare $sourceAlg "Sack"] == 0 || [string compare $sourceAlg "DC-TCP-Sack"] == 0} {
	set sink($i) [new Agent/TCP/FullTcp/Sack]
        set sinkno [expr $i - $shortfno + 4000]
        $ns attach-agent $n($sinkno) $sink($i)
        $ns connect $tcp($i) $sink($i)
	$sink($i) listen
    }    
}


for {set i 0} {$i<$shortfno} {incr i} {
    set ftp($i) [$tcp($i) attach-app FTP]
#	$ns at 0.1 "$ftp($i) send [expr 1460*100]"
    set fs [$flows($i) getFS];      #author by
    set ft [$flows($i) getAT];    
    $ns at $ft "$ftp($i) send [expr $fs*1460]";  #author by
	#puts $ft;
	#puts $fs;
	#puts [expr 1460*50];
}
for {set i $shortfno} {$i < [expr $shortfno + $longfno ] } {incr i} {
        set ftp($i) [$tcp($i) attach-app FTP]
        $ns at 0.1 "$ftp($i) send [expr 1460*1000]"
}

proc finish {} {
    global ns f nf 
	$ns flush-trace
	close $f
	close $nf
	#exec nam ps.nam &
	exit 0
}

$ns at 1.0 "finish"
$ns run



















